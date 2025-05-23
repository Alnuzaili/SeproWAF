package services

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"SeproWAF/models"

	"github.com/beego/beego/v2/core/logs" // Added missing import
	"github.com/beego/beego/v2/server/web"
)

type GenAIService struct {
	apiKey     string
	apiURL     string
	httpClient *http.Client
}

// NewGenAIService creates a new GenAI service with appropriate timeouts
func NewGenAIService() *GenAIService {
	// Read API key from environment or config
	apiKey := web.AppConfig.DefaultString("google_genai_api_key", "")

	// Log warning if API key is empty
	if apiKey == "" {
		logs.Warn("Google GenAI API key is not configured. AI summarization will not work.")
	}

	// Create HTTP client with increased timeout (30 seconds instead of default 10)
	client := &http.Client{
		Timeout: 30 * time.Second, // Increase timeout to 30 seconds
	}

	return &GenAIService{
		apiKey:     apiKey,
		apiURL:     "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent",
		httpClient: client,
	}
}

// GenerateLogReport generates a summary report from WAF logs
func (s *GenAIService) GenerateLogReport(logEntries []*models.WAFLog) (string, error) {
	if len(logEntries) == 0 {
		return "No logs found to analyze.", nil
	}

	// Check if API key is configured
	if s.apiKey == "" {
		return "", fmt.Errorf("Google GenAI API key is not configured")
	}

	// Create context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 25*time.Second)
	defer cancel()

	// Format logs for the AI model
	logsData := prepareLogsForAI(logEntries)

	// Prepare the request payload - updated to match current Gemini API format
	payload := map[string]interface{}{
		"contents": []map[string]interface{}{
			{
				"role": "user",
				"parts": []map[string]interface{}{
					{
						"text": fmt.Sprintf(`You are SeproWAF Security Analyst, an expert in web application security.

Analyze these WAF security logs and create a concise security report with the following sections:

1. EXECUTIVE SUMMARY: 
   - A 1-2 sentence overview of the security situation
   - Overall threat level (Critical/High/Medium/Low)

2. KEY FINDINGS:
   - Top attack types detected (maximum 3)
   - Most targeted endpoints (maximum 2)
   - Most concerning source IPs (if any)

3. CRITICAL ISSUES:
   - Highlight only the most serious security events
   - List any successful attacks or concerning patterns

4. RECOMMENDATIONS:
   - 2-3 specific actions to improve security

Format the report with section headers using markdown. Be extremely concise and direct - the entire report should be no more than 350 words.

WAF LOGS:
%s`, logsData),
					},
				},
			},
		},
		"generationConfig": map[string]interface{}{
			"temperature":     0.2,
			"maxOutputTokens": 800,
			"topK":            40,
			"topP":            0.95,
		},
	}

	jsonData, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("failed to marshal request: %v", err)
	}

	// Create request with context for timeout
	req, err := http.NewRequestWithContext(ctx, "POST", fmt.Sprintf("%s?key=%s", s.apiURL, s.apiKey), bytes.NewBuffer(jsonData))
	if err != nil {
		return "", fmt.Errorf("failed to create request: %v", err)
	}

	req.Header.Set("Content-Type", "application/json")

	// Send request with logging
	logs.Info("Sending request to GenAI API")
	startTime := time.Now()
	resp, err := s.httpClient.Do(req)

	if err != nil {
		if ctx.Err() == context.DeadlineExceeded {
			logs.Error("GenAI API request timed out after %v seconds", time.Since(startTime).Seconds())
			return "", fmt.Errorf("request timed out - the AI service is currently slow or unavailable")
		}
		logs.Error("GenAI API request failed: %v", err)
		return "", fmt.Errorf("API request failed: %v", err)
	}
	defer resp.Body.Close()

	logs.Info("GenAI API request completed in %v seconds with status %d", time.Since(startTime).Seconds(), resp.StatusCode)

	// Read and parse response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response: %v", err)
	}

	if resp.StatusCode != http.StatusOK {
		logs.Error("GenAI API returned non-200 status: %d, body: %s", resp.StatusCode, string(body))
		return "", fmt.Errorf("API returned error status: %d - %s", resp.StatusCode, string(body))
	}

	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		return "", fmt.Errorf("failed to parse response: %v", err)
	}

	// Extract the generated text - updated to match the current API response format
	candidates, ok := result["candidates"].([]interface{})
	if !ok || len(candidates) == 0 {
		return "", fmt.Errorf("no text generated")
	}

	// The response structure has changed, so let's handle it differently
	if text, ok := candidates[0].(map[string]interface{})["output"].(string); ok {
		return text, nil
	}

	// Fallback to previous structure if the format has changed
	if content, ok := candidates[0].(map[string]interface{})["content"].(map[string]interface{}); ok {
		if parts, ok := content["parts"].([]interface{}); ok && len(parts) > 0 {
			if text, ok := parts[0].(map[string]interface{})["text"].(string); ok {
				return text, nil
			}
		}
	}

	return "", fmt.Errorf("unable to extract text from the response: %s", string(body))
}

// Helper function to prepare logs for AI analysis
func prepareLogsForAI(logEntries []*models.WAFLog) string {
	var buffer bytes.Buffer

	// Limit to 50 logs to avoid overwhelming the AI
	maxLogs := 50
	if len(logEntries) > maxLogs {
		logEntries = logEntries[:maxLogs]
	}

	for i, log := range logEntries {
		buffer.WriteString(fmt.Sprintf("[%d] Time: %s, IP: %s, Method: %s, URI: %s, Action: %s, Status: %d, Category: %s, Severity: %s\n",
			i+1,
			log.CreatedAt.Format(time.RFC3339),
			log.ClientIP,
			log.Method,
			log.URI,
			log.Action,
			log.StatusCode,
			log.Category,
			log.Severity))
	}

	return buffer.String()
}
