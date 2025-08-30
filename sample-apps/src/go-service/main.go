package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"time"
)

type LogEntry struct {
	Timestamp string `json:"ts"`
	Service   string `json:"svc"`
	Level     string `json:"lvl"`
	Message   string `json:"msg"`
	User      string `json:"user"`
	LatencyMs int    `json:"latency_ms"`
}

func randomUser() string {
	// generate uXXX where each digit is between 1-9
	return fmt.Sprintf("u%d%d%d",
		rand.Intn(9)+1,
		rand.Intn(9)+1,
		rand.Intn(9)+1,
	)
}

func main() {
	rand.Seed(time.Now().UnixNano())

	// Separate messages for different log levels
	infoMessages := []string{"created", "updated", "processed", "completed"}
	errorMessages := []string{"timeout", "failed", "connection_error", "validation_failed"}

	for {
		// Generate random number 1-100 to determine log level
		// 1-11 = ERROR (11%), 12-100 = INFO (89%)
		isError := rand.Intn(100)+1 <= 11

		var level string
		var message string
		var latency int

		if isError {
			level = "ERROR"
			message = errorMessages[rand.Intn(len(errorMessages))]
			// Error requests tend to have higher latency
			latency = rand.Intn(2000) + 500 // 500-2499ms
		} else {
			level = "INFO"
			message = infoMessages[rand.Intn(len(infoMessages))]
			// Normal requests have lower latency
			latency = rand.Intn(800) // 0-799ms
		}

		entry := LogEntry{
			Timestamp: time.Now().UTC().Format(time.RFC3339),
			Service:   "orders",
			Level:     level,
			Message:   message,
			User:      randomUser(),
			LatencyMs: latency,
		}

		data, _ := json.Marshal(entry)
		fmt.Println(string(data))

		time.Sleep(500 * time.Millisecond)
	}
}
