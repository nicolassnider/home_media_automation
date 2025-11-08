#!/bin/bash


# ================================================
# Home Media and Automation Center
# Docker Installation Script
# ================================================
# This script installs Docker and Docker Compose
# Run as: sudo ./02-install-docker.sh


set -e  # Exit on error


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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


check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run as root or with sudo"
        exit 1
    fi
}


# Main Script
print_info "============================================"
print_info "Docker Installation"
print_info "============================================"


check_root


# Remove old versions
print_info "Removing old Docker versions (if any)..."
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true


# Install prerequisites
print_info "Installing prerequisites..."
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


# Add Docker's official GPG key
print_info "Adding Docker GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg


# Set up Docker repository
print_info "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null


# Install Docker Engine
print_info "Installing Docker Engine..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Start and enable Docker
print_info "Starting Docker service..."
systemctl start docker
systemctl enable docker


# Add user to docker group
if [ ! -z "$SUDO_USER" ]; then
    print_info "Adding $SUDO_USER to docker group..."
    usermod -aG docker $SUDO_USER
    print_warn "You need to log out and back in for group changes to take effect"
fi


# Configure Docker daemon
print_info "Configuring Docker daemon..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-address-pools": [
    {
      "base": "172.17.0.0/16",
      "size": 24
    }
  ]
}
EOF


# Restart Docker to apply configuration
print_info "Restarting Docker..."
systemctl restart docker


# Verify installation
print_info "Verifying Docker installation..."
docker --version
docker compose version


# Test Docker
print_info "Running Docker hello-world test..."
docker run --rm hello-world


print_info "============================================"
print_info "Docker installation complete!"
print_info "============================================"
print_info "Docker version: $(docker --version)"
print_info "Docker Compose version: $(docker compose version)"
print_info ""
print_warn "IMPORTANT: Log out and back in to use Docker without sudo"
print_info ""
print_info "Next steps:"
print_info "1. Log out and back in"
print_info "2. Run: ./03-setup-services.sh"
print_info "============================================"