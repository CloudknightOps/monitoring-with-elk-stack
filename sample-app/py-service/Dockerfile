# Use lightweight Python base image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy script into container
COPY log_generator.py .

# Ensure logs flush immediately (important for streaming logs)
ENV PYTHONUNBUFFERED=1

# Run script
CMD ["python", "log_generator.py"]
