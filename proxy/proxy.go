package proxy

import (
	db "SeproWAF/database"
	"SeproWAF/models"
	"context"
	"crypto/tls"
	"errors"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/http/httputil"
	"net/url"
	"sync"
	"time"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
	"github.com/exaring/ja4plus"
)

// ProxyServer represents the reverse proxy server
type ProxyServer struct {
	httpServer        *http.Server
	httpsServer       *http.Server
	domainMap         map[string]*SiteProxy
	mapMutex          sync.RWMutex
	httpPort          int
	httpsPort         int
	certManager       *CertificateManager
	defaultHost       string
	tlsConfig         *tls.Config
	wafManager        *WAFManager   // Added WAF manager
	requestCounters   map[int]int64 // Maps site ID to request count
	countersMutex     sync.Mutex
	counterUpdateTick *time.Ticker // Update DB every 30 seconds
}

// SiteProxy represents a site's proxy configuration
type SiteProxy struct {
	Site             *models.Site
	ReverseProxy     *httputil.ReverseProxy
	Certificate      *models.Certificate
	LastAccessedTime time.Time
	UseHTTPS         bool
	WAFEnabled       bool // Added WAF enabled flag
}

// CertificateManager manages TLS certificates
type CertificateManager struct {
	certificates map[string]*tls.Certificate
	mutex        sync.RWMutex
}

// JA4Middleware extracts JA4 fingerprints from the TLS connection and adds them to the request headers.
func JA4Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Check if the request is over TLS
		if r.TLS != nil {
			// Assuming you have a way to extract ClientHelloInfo
			clientHelloInfo := extractClientHelloInfo(r.TLS) // Extract ClientHelloInfo
			// Compute JA4 hash from the client hello info
			ja4Hash := ja4plus.JA4(clientHelloInfo)

			if ja4Hash != "" {
				// Add JA4 header to the request
				r.Header.Set("X-JA4", ja4Hash)
			} else {
				log.Printf("Error computing JA4 hash")
			}
		}
		// Pass the request to the next handler in the chain
		next.ServeHTTP(w, r)
	})
}

// extractClientHelloInfo intercepts the ClientHello information during the handshake
func extractClientHelloInfo(connState *tls.ConnectionState) *tls.ClientHelloInfo {
	// In a real implementation, you'd need to hook into the handshake process
	// and capture the ClientHelloInfo. This is a simplified approach.

	// Example logic for creating a mock ClientHelloInfo (you'll need to capture real info)
	clientHelloInfo := &tls.ClientHelloInfo{
		SupportedVersions: []uint16{tls.VersionTLS13, tls.VersionTLS12},
		CipherSuites:      []uint16{tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384},
		// Add other fields as needed (SNI, ALPN, etc.)
	}

	return clientHelloInfo
}

// NewCertificateManager creates a new certificate manager
func NewCertificateManager() *CertificateManager {
	return &CertificateManager{
		certificates: make(map[string]*tls.Certificate),
	}
}

// GetCertificate is a callback function for tls.Config
func (cm *CertificateManager) GetCertificate(hello *tls.ClientHelloInfo) (*tls.Certificate, error) {
	host := hello.ServerName

	// If ServerName is empty, use a default certificate if available
	if host == "" {
		cm.mutex.RLock()
		cert, ok := cm.certificates["_default"]
		cm.mutex.RUnlock()
		if ok {
			return cert, nil
		}
		// Continue to check if we have any certificate that could be used
		// by getting the first one in the map
		cm.mutex.RLock()
		for _, cert := range cm.certificates {
			cm.mutex.RUnlock()
			return cert, nil
		}
		cm.mutex.RUnlock()
	}

	cm.mutex.RLock()
	cert, ok := cm.certificates[host]
	cm.mutex.RUnlock()

	if ok {
		return cert, nil
	}

	// No certificate found for this domain
	logs.Warning("No certificate found for domain: %s", host)
	return nil, fmt.Errorf("no certificate for domain: %s", host)
}

// AddCertificate adds a certificate to the manager
func (cm *CertificateManager) AddCertificate(domain string, cert *tls.Certificate) {
	cm.mutex.Lock()
	defer cm.mutex.Unlock()

	cm.certificates[domain] = cert
}

// RemoveCertificate removes a certificate from the manager
func (cm *CertificateManager) RemoveCertificate(domain string) {
	cm.mutex.Lock()
	defer cm.mutex.Unlock()

	delete(cm.certificates, domain)
}

// NewProxyServer creates a new proxy server
func NewProxyServer(httpPort, httpsPort int) *ProxyServer {
	certManager := NewCertificateManager()

	tlsConfig := &tls.Config{
		GetCertificate: certManager.GetCertificate,
		MinVersion:     tls.VersionTLS12,
		CipherSuites: []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
		},
		PreferServerCipherSuites: true,
	}

	// Initialize WAF manager
	wafManager, err := NewWAFManager()
	if err != nil {
		logs.Error("Failed to initialize WAF manager: %v", err)
		logs.Warning("WAF functionality will be disabled")
		// Continue without WAF
	} else {
		logs.Info("Coraza WAF manager initialized successfully")
	}

	server := &ProxyServer{
		domainMap:         make(map[string]*SiteProxy),
		mapMutex:          sync.RWMutex{},
		httpPort:          httpPort,
		httpsPort:         httpsPort,
		certManager:       certManager,
		defaultHost:       "localhost",
		tlsConfig:         tlsConfig,
		wafManager:        wafManager,
		requestCounters:   make(map[int]int64),
		countersMutex:     sync.Mutex{},
		counterUpdateTick: time.NewTicker(30 * time.Second), // Update DB every 30 seconds
	}

	// Start the counter update goroutine
	go server.updateRequestCounters()

	// Create HTTP server
	server.httpServer = &http.Server{
		Addr:    fmt.Sprintf(":%d", httpPort),
		Handler: server,
	}

	// Create HTTPS server
	server.httpsServer = &http.Server{
		Addr:      fmt.Sprintf(":%d", httpsPort),
		Handler:   server,
		TLSConfig: tlsConfig,
	}

	return server
}

// Start starts the proxy server
func (ps *ProxyServer) Start() error {
	// Load active sites from database
	err := ps.LoadActiveSites()
	if err != nil {
		return fmt.Errorf("failed to load active sites: %v", err)
	}

	// Start monitoring for site changes
	go ps.MonitorSiteChanges()

	// Start monitoring for certificate changes
	go ps.MonitorCertificates()

	// Start HTTP server in a goroutine
	go func() {
		if err := ps.httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logs.Error("HTTP server error: %v", err)
		}
	}()

	// Only start HTTPS server if we have certificates
	ps.certManager.mutex.RLock()
	hasCertificates := len(ps.certManager.certificates) > 0
	ps.certManager.mutex.RUnlock()

	if hasCertificates {
		// Start HTTPS server in a goroutine - make it non-fatal if it fails
		go func() {
			if err := ps.httpsServer.ListenAndServeTLS("", ""); err != nil && err != http.ErrServerClosed {
				logs.Error("HTTPS server error: %v", err)
				logs.Warning("HTTPS server failed to start. SSL functionality will be unavailable.")
			}
		}()
	}

	return nil
}

// Stop stops the proxy server
func (ps *ProxyServer) Stop() error {
	// Stop the counter ticker
	ps.counterUpdateTick.Stop()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := ps.httpServer.Shutdown(ctx); err != nil {
		logs.Error("HTTP server shutdown error: %v", err)
	}

	if err := ps.httpsServer.Shutdown(ctx); err != nil {
		logs.Error("HTTPS server shutdown error: %v", err)
		return err
	}

	return nil
}

// LoadActiveSites loads all active sites from the database
func (ps *ProxyServer) LoadActiveSites() error {
	o := orm.NewOrm()
	var sites []*models.Site

	_, err := o.QueryTable(new(models.Site).TableName()).
		Filter("status", models.SiteStatusActive).
		All(&sites)

	if err != nil {
		return err
	}

	for _, site := range sites {
		err = ps.AddOrUpdateSite(site)
		if err != nil {
			logs.Error("Failed to add site %s: %v", site.Domain, err)
		}
	}

	return nil
}

// MonitorSiteChanges periodically checks for changes in site configurations
func (ps *ProxyServer) MonitorSiteChanges() {
	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			ps.LoadActiveSites() // Refresh the site list
		}
	}
}

// MonitorCertificates checks for certificate changes and starts HTTPS when needed
func (ps *ProxyServer) MonitorCertificates() {
	httpsStarted := false
	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			if !httpsStarted {
				// Check if we have certificates now
				ps.certManager.mutex.RLock()
				hasCertificates := len(ps.certManager.certificates) > 0
				ps.certManager.mutex.RUnlock()

				if hasCertificates {
					// Start HTTPS server
					go func() {
						if err := ps.httpsServer.ListenAndServeTLS("", ""); err != nil && err != http.ErrServerClosed {
							logs.Error("HTTPS server error: %v", err)
							logs.Warning("HTTPS server failed to start. SSL functionality will be unavailable.")
						}
					}()
					httpsStarted = true
				}
			}
		}
	}
}

// ServeHTTP handles HTTP requests
func (ps *ProxyServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	host := r.Host

	// Strip port from host if present
	hostWithoutPort := host
	if h, _, err := net.SplitHostPort(host); err == nil {
		hostWithoutPort = h
	}

	// Find the site proxy for this host
	ps.mapMutex.RLock()
	siteProxy, exists := ps.domainMap[hostWithoutPort]
	ps.mapMutex.RUnlock()

	// If site not found, return 404
	if !exists {
		http.Error(w, "Site not found", http.StatusNotFound)
		return
	}

	// Update last access time
	siteProxy.LastAccessedTime = time.Now()

	// Check if we should redirect HTTP to HTTPS
	if r.TLS == nil && siteProxy.UseHTTPS {
		// Create the HTTPS URL with the correct port
		target := fmt.Sprintf("https://%s:%d", hostWithoutPort, ps.httpsPort)

		if r.URL.Path != "" {
			target += r.URL.Path
		}
		if r.URL.RawQuery != "" {
			target += "?" + r.URL.RawQuery
		}

		http.Redirect(w, r, target, http.StatusMovedPermanently)
		return
	}

	// Instead of creating a DB connection for every request, just increment the counter
	ps.countersMutex.Lock()
	ps.requestCounters[siteProxy.Site.ID]++
	ps.countersMutex.Unlock()

	// Apply WAF if enabled for this site and WAF manager is available
	if siteProxy.WAFEnabled && ps.wafManager != nil {
		wafHandler := ps.wafManager.WAFHandler(siteProxy.ReverseProxy, siteProxy.Site.ID, siteProxy.Site.Domain)

		// لف WAF handler مع JA4+ middleware
		ja4plusWrapped := JA4Middleware(wafHandler)
		ja4plusWrapped.ServeHTTP(w, r)
		return
	}

	// Forward the request to the backend server if WAF is not enabled
	siteProxy.ReverseProxy.ServeHTTP(w, r)
}

// AddOrUpdateSite adds or updates a site in the proxy
func (ps *ProxyServer) AddOrUpdateSite(site *models.Site) error {
	// Skip if site is not active
	if site.Status != models.SiteStatusActive {
		// Remove site if it exists
		ps.RemoveSite(site.Domain)
		return nil
	}

	// Parse the target URL
	targetURL, err := url.Parse(site.TargetURL)
	if err != nil {
		return fmt.Errorf("invalid target URL for site %s: %v", site.Domain, err)
	}

	// Create a reverse proxy
	proxy := httputil.NewSingleHostReverseProxy(targetURL)

	// Configure custom error handling for the proxy
	proxy.ErrorHandler = func(w http.ResponseWriter, r *http.Request, err error) {
		// Don't log context canceled errors as they're usually just client disconnections
		if !errors.Is(err, context.Canceled) {
			logs.Error("Proxy error for %s: %v", site.Domain, err)
		}

		// Only send error response if headers weren't written yet
		if w.Header().Get("Content-Type") == "" {
			http.Error(w, "Backend server error", http.StatusBadGateway)
		}
	}

	// Modify the director to update the Host header
	originalDirector := proxy.Director
	proxy.Director = func(req *http.Request) {
		originalDirector(req)

		// Update the Host header to the target host
		req.Host = targetURL.Host
	}

	// Check if site has a certificate - make this optional
	useHTTPS := false
	var certificate *models.Certificate = nil

	if site.CertificateID != nil {
		// Attempt to load the certificate, but don't fail if it's not found
		cert, err := models.GetCertificateByID(*site.CertificateID)
		if err == nil && cert != nil {
			// Try to load the certificate into memory
			tlsCert, err := tls.X509KeyPair([]byte(cert.Certificate), []byte(cert.PrivateKey))
			if err == nil {
				// Add the certificate to the manager
				ps.certManager.AddCertificate(site.Domain, &tlsCert)
				useHTTPS = true
				certificate = cert
			} else {
				logs.Warning("Failed to parse certificate for %s: %v - HTTPS will be disabled", site.Domain, err)
			}
		} else {
			logs.Warning("Certificate not found for site %s - HTTPS will be disabled", site.Domain)
		}
	}

	// Create or update site proxy
	siteProxy := &SiteProxy{
		Site:             site,
		ReverseProxy:     proxy,
		Certificate:      certificate,
		LastAccessedTime: time.Now(),
		UseHTTPS:         useHTTPS,
		WAFEnabled:       site.WAFEnabled, // Set WAF enabled flag
	}

	// Add to domain map
	ps.mapMutex.Lock()
	ps.domainMap[site.Domain] = siteProxy
	ps.mapMutex.Unlock()

	return nil
}

// RemoveSite removes a site from the proxy
func (ps *ProxyServer) RemoveSite(domain string) {
	ps.mapMutex.Lock()
	defer ps.mapMutex.Unlock()

	if siteProxy, exists := ps.domainMap[domain]; exists {
		// Remove certificate from manager if it exists
		if siteProxy.UseHTTPS {
			ps.certManager.RemoveCertificate(domain)
		}

		delete(ps.domainMap, domain)
	}
}

// Replace the updateRequestCounters method with this version

func (ps *ProxyServer) updateRequestCounters() {
	for range ps.counterUpdateTick.C {
		ps.countersMutex.Lock()
		counters := make(map[int]int64)
		for siteID, count := range ps.requestCounters {
			counters[siteID] = count
			ps.requestCounters[siteID] = 0 // Reset counter
		}
		ps.countersMutex.Unlock()

		if len(counters) == 0 {
			continue
		}

		// Use connection pool
		o := db.GetPool().GetOrm()

		// Check if site table exists before attempting update
		tableExists := false
		err := o.Raw("SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'sites'").QueryRow(&tableExists)
		if err != nil || !tableExists {
			// Log once instead of spamming logs
			logs.Warning("Site table doesn't exist in database, disabling request count updates")

			// Disable periodic updates by stopping and nullifying the ticker
			ps.counterUpdateTick.Stop()
			ps.counterUpdateTick = nil
			return
		}

		// Use a single transaction for all updates
		tx, err := o.Begin()
		if err != nil {
			logs.Error("Failed to begin transaction for request counts: %v", err)
			continue
		}

		success := true
		for siteID, count := range counters {
			_, err := tx.Raw("UPDATE sites SET request_count = request_count + ? WHERE i_d = ?", count, siteID).Exec()
			if err != nil {
				logs.Error("Failed to update request count for site %d: %v", siteID, err)
				success = false
				break
			}
		}

		if success {
			err = tx.Commit()
			if err != nil {
				logs.Error("Failed to commit request count updates: %v", err)
				tx.Rollback()
			}
		} else {
			tx.Rollback()
		}
	}
}
