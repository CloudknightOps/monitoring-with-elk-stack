#!/bin/bash
set -e

# Update and install prerequisites
apt-get update -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install latest Docker Engine and CLI
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker service
systemctl enable docker
systemctl start docker

# Create ELK directory
mkdir -p /opt/elk
cd /opt/elk

# Write docker-compose.yml
cat > docker-compose.yml << 'EOF'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.17.5
    container_name: elk_elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.17.5
    container_name: elk_kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  logstash:
    image: docker.elastic.co/logstash/logstash:8.17.5
    container_name: elk_logstash
    volumes:
      - ./logstash/pipeline.conf:/usr/share/logstash/pipeline/pipeline.conf
    depends_on:
      - elasticsearch
    ports:
      - "5044:5044"
EOF

# Create logstash pipeline directory and sample pipeline
mkdir -p /opt/elk/logstash
cat > /opt/elk/logstash/pipeline.conf << 'EOF'
input { stdin { } }
output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
  }
  stdout { codec => rubydebug }
}
EOF

docker compose up -d
