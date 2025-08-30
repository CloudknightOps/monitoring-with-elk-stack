# Use official Go image as build stage
FROM golang:1.22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod files (if you have them)
# COPY go.mod go.sum ./
# RUN go mod download

# Copy source code
COPY main.go .

# Build the application
RUN go build -o log-generator main.go

# Use minimal alpine image for final stage
FROM alpine:latest

# Install ca-certificates for any HTTPS calls (good practice)
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user for security
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup appuser

# Set working directory
WORKDIR /app

# Copy binary from builder stage
COPY --from=builder /app/log-generator .

# Change ownership to non-root user
RUN chown appuser:appgroup log-generator

# Switch to non-root user
USER appuser

# Run the application
CMD ["./log-generator"]
