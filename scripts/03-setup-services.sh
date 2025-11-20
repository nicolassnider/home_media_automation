#!/bin/bash




# ================================================
# Home Media and Automation Center
# Services Setup Script
# ================================================
# This script sets up all Docker services
# Run as: ./03-setup-services.sh (no sudo needed)




set -e  # Exit on error




# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color




# Functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}




print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}




print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}




print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}




# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$PROJECT_DIR/docker"
CONFIG_DIR="$PROJECT_DIR/configs"




# Main Script
print_info "============================================"
print_info "Services Setup"
print_info "============================================"




# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Run 02-install-docker.sh first"
    exit 1
fi




# Check if user is in docker group
if ! groups | grep -q docker; then
    print_error "User is not in docker group. Log out and back in, or run: newgrp docker"
    exit 1
fi




# Create directory structure in /opt/docker
print_step "Creating directory structure..."
sudo mkdir -p /opt/docker/{mosquitto/{config,data,log},plex/{config,transcode},homeassistant/config,nodered/data,nginx/{conf,ssl,logs},portainer/data,prometheus/config,grafana/provisioning}




# Copy docker-compose.yml
print_step "Copying Docker Compose configuration..."
sudo cp "$DOCKER_DIR/docker-compose.yml" /opt/docker/




# Copy configuration files
print_step "Copying configuration files..."
sudo cp "$CONFIG_DIR/mosquitto.conf" /opt/docker/mosquitto/config/
sudo cp "$CONFIG_DIR/nginx-default.conf" /opt/docker/nginx/conf/default.conf
sudo cp "$CONFIG_DIR/prometheus.yml" /opt/docker/prometheus/config/




# Copy environment file
if [ -f "$DOCKER_DIR/.env.example" ]; then
    if [ ! -f /opt/docker/.env ]; then
        print_step "Creating environment file..."
        sudo cp "$DOCKER_DIR/.env.example" /opt/docker/.env
        print_warn "Please edit /opt/docker/.env and configure your settings"
    else
        print_info "Environment file already exists, skipping"
    fi
fi




# Set permissions
print_step "Setting permissions..."
sudo chown -R $USER:$USER /opt/docker




# Create MQTT password file
print_step "Setting up MQTT authentication..."
read -p "Enter MQTT username [admin]: " MQTT_USER
MQTT_USER=${MQTT_USER:-admin}
read -s -p "Enter MQTT password: " MQTT_PASS
echo




# Start mosquitto temporarily to create password
cd /opt/docker
docker compose up -d mosquitto
sleep 5
docker exec mosquitto mosquitto_passwd -c -b /mosquitto/config/passwd "$MQTT_USER" "$MQTT_PASS"
docker compose restart mosquitto




print_info "MQTT credentials created"




# Configure firewall
print_step "Configuring firewall rules..."
sudo ufw allow 32400/tcp comment 'Plex Media Server'
sudo ufw allow 8123/tcp comment 'Home Assistant'
sudo ufw allow 1880/tcp comment 'Node-RED'
sudo ufw allow 1883/tcp comment 'MQTT'
sudo ufw allow 9001/tcp comment 'MQTT WebSocket'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw allow 9000/tcp comment 'Portainer'
sudo ufw allow 3000/tcp comment 'Grafana'




print_info "Firewall rules updated"




# Start all services
print_step "Starting all services..."
cd /opt/docker
docker compose up -d




print_info "Waiting for services to start..."
sleep 10




# Show status
print_step "Service Status:"
docker compose ps




print_info "============================================"
print_info "Services Setup Complete!"
print_info "============================================"
print_info ""
print_info "Access your services:"
print_info "  Plex:           http://$(hostname -I | awk '{print $1}'):32400/web"
print_info "  Home Assistant: http://$(hostname -I | awk '{print $1}'):8123"
print_info "  Node-RED:       http://$(hostname -I | awk '{print $1}'):1880"
print_info "  Portainer:      http://$(hostname -I | awk '{print $1}'):9010"
print_info "  Grafana:        http://$(hostname -I | awk '{print $1}'):3000"
print_info ""
print_warn "IMPORTANT: Complete the setup for each service through their web interfaces"
print_info ""
print_info "Next steps:"
print_info "1. Get Plex claim token from https://www.plex.tv/claim/"
print_info "2. Add claim token to /opt/docker/.env"
print_info "3. Run: cd /opt/docker && docker compose up -d plex"
print_info "4. Configure Home Assistant"
print_info "5. Set up Node-RED"
print_info "============================================"