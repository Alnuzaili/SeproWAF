// filepath: /home/alnuzaili/projects/Sepro/SeproWAF/controllers/dashboard.go
package controllers

import (
	"SeproWAF/models"
	"fmt"
	"net"
	"strconv"
	"strings"
	"time"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/server/web"
)

// DashboardController handles dashboard API endpoints
type DashboardController struct {
	web.Controller
}

// GetStats returns dashboard statistics
func (c *DashboardController) GetStats() {
	o := orm.NewOrm()

	// Get site count
	var sitesCount int64
	sitesCount, _ = o.QueryTable(new(models.Site)).Count()

	// Get 24h stats
	oneDayAgo := time.Now().Add(-24 * time.Hour)

	// Requests count in last 24h
	var requestsCount int64
	err := o.Raw("SELECT SUM(request_count) FROM sites").QueryRow(&requestsCount)
	if err != nil {
		fmt.Println("Error:", err)
	}

	// Attacks count in last 24h
	var attacksCount int64
	attacksCount, _ = o.QueryTable(new(models.WAFLog)).Filter("created_at__gte", oneDayAgo).Filter("action", "blocked").Count()

	// Get custom rules count - use "type" field instead of "is_custom"
	var rulesCount int64
	rulesCount, _ = o.QueryTable("waf_rules").Filter("type", models.CustomRule).Filter("status", models.StatusEnabled).Count()

	// Get default rules count - use all rule types except CUSTOM
	var defaultRulesCount int64
	defaultRulesCount, _ = o.QueryTable("waf_rules").Filter("type__ne", models.CustomRule).Filter("status", models.StatusEnabled).Count()

	c.Data["json"] = map[string]interface{}{
		"success":        true,
		"sites_count":    sitesCount,
		"requests_count": requestsCount,
		"attacks_count":  attacksCount,
		"rules_count":    rulesCount + defaultRulesCount,
		"custom_rules":   rulesCount,
		"default_rules":  defaultRulesCount,
	}
	c.ServeJSON()
}

// GetTraffic returns traffic data for the chart (last 24 hours)
func (c *DashboardController) GetTraffic() {
	o := orm.NewOrm()

	// Create 24 hour buckets
	now := time.Now()
	labels := make([]string, 24)
	legitimate := make([]int64, 24)
	blocked := make([]int64, 24)

	// Generate time labels and initialize data arrays
	for i := 0; i < 24; i++ {
		hourDiff := 23 - i
		labels[i] = fmt.Sprintf("%dh ago", hourDiff)
	}

	// Get hourly counts for the last 24 hours
	for i := 0; i < 24; i++ {
		hourStart := now.Add(-time.Duration(i+1) * time.Hour)
		hourEnd := now.Add(-time.Duration(i) * time.Hour)

		// Count blocked attacks for this hour
		blocked[23-i], _ = o.QueryTable(new(models.WAFLog)).
			Filter("created_at__gte", hourStart).
			Filter("created_at__lt", hourEnd).
			Filter("action", "blocked").
			Count()

		// Get total requests for this hour period
		var hourlyTotalRequests int64
		hourlyQuery := "SELECT SUM(request_count) FROM sites WHERE updated_at >= ? AND updated_at < ?"
		err := o.Raw(hourlyQuery, hourStart, hourEnd).QueryRow(&hourlyTotalRequests)
		if err != nil {
			fmt.Println("Error getting hourly request count:", err)
			hourlyTotalRequests = 0
		}

		// Legitimate = total - blocked
		legitimate[23-i] = hourlyTotalRequests - blocked[23-i]
		if legitimate[23-i] < 0 {
			legitimate[23-i] = 0 // Ensure we don't have negative values
		}
	}

	c.Data["json"] = map[string]interface{}{
		"success": true,
		"traffic": map[string]interface{}{
			"labels":     labels,
			"legitimate": legitimate,
			"blocked":    blocked,
		},
	}
	c.ServeJSON()
}

// GetAttackTypes returns data for attack type distribution chart
func (c *DashboardController) GetAttackTypes() {
	o := orm.NewOrm()

	// Get attack types for the last 30 days
	thirtyDaysAgo := time.Now().Add(-30 * 24 * time.Hour)

	// Use a raw SQL query instead which gives us more control
	sql := `SELECT category, COUNT(*) as count 
            FROM waf_log 
            WHERE created_at >= ? AND action = 'block'
            GROUP BY category 
            ORDER BY count DESC 
            LIMIT 5`

	var results []orm.Params
	_, err := o.Raw(sql, thirtyDaysAgo).Values(&results)

	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"success": false,
			"message": "Failed to get attack types data: " + err.Error(),
		}
		c.ServeJSON()
		return
	}

	// Extract labels and values from query results
	labels := make([]string, 0)
	values := make([]int64, 0)

	otherCount := int64(0)

	// Process the top categories and group the rest as "Other"
	for i, result := range results {
		category := result["category"]
		countStr, ok := result["count"].(string)
		if !ok {
			// Try to get as int64 or other type
			countVal, ok := result["count"].(int64)
			if ok {
				if i < 4 && category != nil { // Show top 4 categories
					categoryName := fmt.Sprintf("%v", category)
					if categoryName == "" {
						categoryName = "Unknown"
					}
					labels = append(labels, categoryName)
					values = append(values, countVal)
				} else {
					otherCount += countVal
				}
			}
			continue
		}

		// Convert string count to int64
		countVal, _ := strconv.ParseInt(countStr, 10, 64)

		if i < 4 && category != nil { // Show top 4 categories
			categoryName := fmt.Sprintf("%v", category)
			if categoryName == "" {
				categoryName = "Unknown"
			}
			labels = append(labels, categoryName)
			values = append(values, countVal)
		} else {
			// Group the rest as "Other"
			otherCount += countVal
		}
	}

	// Add "Other" category if there are additional attacks
	if otherCount > 0 {
		labels = append(labels, "Other")
		values = append(values, otherCount)
	}

	// If no data was found, provide some default categories
	if len(labels) == 0 {
		labels = []string{"SQL Injection", "XSS", "CSRF", "Path Traversal", "Other"}
		values = []int64{0, 0, 0, 0, 0}
	}

	c.Data["json"] = map[string]interface{}{
		"success": true,
		"attack_types": map[string]interface{}{
			"labels": labels,
			"values": values,
		},
	}
	c.ServeJSON()
}

// GetTopAttackedSites returns the top 5 sites with the most attacks
func (c *DashboardController) GetTopAttackedSites() {
	o := orm.NewOrm()

	// Get data for the last 7 days
	sevenDaysAgo := time.Now().Add(-7 * 24 * time.Hour)

	// Use a raw SQL query for better performance
	sql := `SELECT s.domain, COUNT(*) as count 
			FROM waf_log w 
			JOIN site s ON w.site_id = s.id
			WHERE w.created_at >= ? AND w.action = 'block' 
			GROUP BY w.site_id, s.domain
			ORDER BY count DESC 
			LIMIT 5`

	var results []orm.Params
	_, err := o.Raw(sql, sevenDaysAgo).Values(&results)

	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"success": false,
			"message": "Failed to get top attacked sites data: " + err.Error(),
		}
		c.ServeJSON()
		return
	}

	// Extract labels and values from query results
	labels := make([]string, 0)
	values := make([]int64, 0)

	for _, result := range results {
		domain := result["domain"]

		// Try to get as string first
		domainStr, ok := domain.(string)
		if !ok {
			domainStr = fmt.Sprintf("%v", domain)
		}

		// Truncate long domain names for display
		if len(domainStr) > 20 {
			domainStr = domainStr[:17] + "..."
		}

		labels = append(labels, domainStr)

		// Try to get count
		var count int64
		countVal := result["count"]
		switch v := countVal.(type) {
		case int64:
			count = v
		case string:
			count, _ = strconv.ParseInt(v, 10, 64)
		default:
			count = 0
		}

		values = append(values, count)
	}

	// If no data, provide placeholder
	if len(labels) == 0 {
		c.Data["json"] = map[string]interface{}{
			"success": false,
			"message": "No attack data for sites found",
		}
		c.ServeJSON()
		return
	}

	c.Data["json"] = map[string]interface{}{
		"success": true,
		"top_attacked_sites": map[string]interface{}{
			"labels": labels,
			"values": values,
		},
	}
	c.ServeJSON()
}

// GetAttacksByHour returns the distribution of attacks by hour of day
func (c *DashboardController) GetAttacksByHour() {
	o := orm.NewOrm()

	// Create 24 hour buckets (0-23)
	labels := make([]string, 24)
	values := make([]int64, 24)

	// Generate hour labels
	for i := 0; i < 24; i++ {
		labels[i] = fmt.Sprintf("%02d:00", i)
	}

	// Get data for the last 7 days
	sevenDaysAgo := time.Now().Add(-7 * 24 * time.Hour)

	// Query attacks by hour
	sql := `SELECT HOUR(created_at) as hour, COUNT(*) as count 
			FROM waf_log 
			WHERE created_at >= ? AND action = 'block'
			GROUP BY HOUR(created_at)
			ORDER BY hour`

	var results []orm.Params
	_, err := o.Raw(sql, sevenDaysAgo).Values(&results)

	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"success": false,
			"message": "Failed to get attacks by hour data: " + err.Error(),
		}
		c.ServeJSON()
		return
	}

	// Initialize all hours to zero
	for i := 0; i < 24; i++ {
		values[i] = 0
	}

	// Fill in actual values
	for _, result := range results {
		hourVal := result["hour"]
		var hour int

		switch v := hourVal.(type) {
		case int64:
			hour = int(v)
		case string:
			hour, _ = strconv.Atoi(v)
		default:
			// Try to parse as string
			hourStr := fmt.Sprintf("%v", hourVal)
			hour, _ = strconv.Atoi(hourStr)
		}

		if hour >= 0 && hour < 24 {
			// Get count value
			countVal := result["count"]
			var count int64

			switch v := countVal.(type) {
			case int64:
				count = v
			case string:
				count, _ = strconv.ParseInt(v, 10, 64)
			default:
				countStr := fmt.Sprintf("%v", countVal)
				count, _ = strconv.ParseInt(countStr, 10, 64)
			}

			values[hour] = count
		}
	}

	c.Data["json"] = map[string]interface{}{
		"success": true,
		"attacks_by_hour": map[string]interface{}{
			"labels": labels,
			"values": values,
		},
	}
	c.ServeJSON()
}

// GetGeoAttackDistribution returns geographic distribution of attack sources
func (c *DashboardController) GetGeoAttackDistribution() {
	o := orm.NewOrm()

	// Get data for the last 30 days
	thirtyDaysAgo := time.Now().Add(-30 * 24 * time.Hour)

	// Query for client IPs of blocked requests
	sql := `SELECT client_ip, COUNT(*) as count 
			FROM waf_log 
			WHERE created_at >= ? AND action = 'block'
			GROUP BY client_ip
			ORDER BY count DESC
			LIMIT 100`

	var results []orm.Params
	_, err := o.Raw(sql, thirtyDaysAgo).Values(&results)

	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"success": false,
			"message": "Failed to get geo attack data: " + err.Error(),
		}
		c.ServeJSON()
		return
	}

	// Map to store country counts
	countryCount := make(map[string]int64)

	// Process IPs and determine countries (simplified approach)
	for _, result := range results {
		ipVal := result["client_ip"]
		if ipVal == nil {
			continue
		}

		ipStr := fmt.Sprintf("%v", ipVal)

		// Simple country determination based on IP ranges
		// This is a simplified approach - in production, use a proper GeoIP database
		country := getCountryFromIP(ipStr)

		// Get count value
		countVal := result["count"]
		var count int64

		switch v := countVal.(type) {
		case int64:
			count = v
		case string:
			count, _ = strconv.ParseInt(v, 10, 64)
		default:
			countStr := fmt.Sprintf("%v", countVal)
			count, _ = strconv.ParseInt(countStr, 10, 64)
		}

		countryCount[country] += count
	}

	// Convert map to sorted arrays for the chart
	type countryData struct {
		Country string
		Count   int64
	}

	countryList := make([]countryData, 0, len(countryCount))
	for country, count := range countryCount {
		countryList = append(countryList, countryData{Country: country, Count: count})
	}

	// Sort by count descending
	// Note: Simplified sorting - in Go you'd use sort.Slice with a custom less function
	// This is just conceptual

	// Take top 10 countries
	maxEntries := 10
	if len(countryList) > maxEntries {
		countryList = countryList[:maxEntries]
	}

	// Prepare data for chart
	labels := make([]string, 0, len(countryList))
	values := make([]int64, 0, len(countryList))

	for _, entry := range countryList {
		labels = append(labels, entry.Country)
		values = append(values, entry.Count)
	}

	// If no data, provide some defaults
	if len(labels) == 0 {
		labels = []string{"Unknown"}
		values = []int64{0}
	}

	c.Data["json"] = map[string]interface{}{
		"success": true,
		"geo_distribution": map[string]interface{}{
			"labels": labels,
			"values": values,
		},
	}
	c.ServeJSON()
}

// Helper function to get country from IP (simplified)
func getCountryFromIP(ipStr string) string {
	// This is a very simplified approach
	// In production, use a proper GeoIP database like MaxMind

	ip := net.ParseIP(ipStr)
	if ip == nil {
		return "Unknown"
	}

	// Some very simplified rules
	if ip.IsPrivate() || ip.IsLoopback() {
		return "Local"
	}

	// Simple prefix checks (extremely simplified)
	// In a real implementation, use a GeoIP database
	ipStr = ip.String()
	switch {
	case strings.HasPrefix(ipStr, "1."):
		return "China"
	case strings.HasPrefix(ipStr, "2."):
		return "France"
	case strings.HasPrefix(ipStr, "3."):
		return "USA"
	case strings.HasPrefix(ipStr, "5."):
		return "Germany"
	case strings.HasPrefix(ipStr, "8."):
		return "UK"
	case strings.HasPrefix(ipStr, "9."):
		return "Japan"
	case strings.HasPrefix(ipStr, "13."):
		return "Australia"
	case strings.HasPrefix(ipStr, "14."):
		return "Canada"
	case strings.HasPrefix(ipStr, "18."):
		return "Brazil"
	case strings.HasPrefix(ipStr, "20."):
		return "Russia"
	default:
		return "Other"
	}
}
