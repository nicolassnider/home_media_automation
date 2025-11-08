#!/bin/bash


# ================================================
# Home Media and Automation Center
# System Preparation Script
# ================================================
# This script prepares Ubuntu Server for the home automation center
# Run as: sudo ./01-system-prep.sh


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
print_info "Home Media Server - System Preparation"
print_info "============================================"


check_root


# Update system
print_info "Updating system packages..."
apt update
apt upgrade -y
apt dist-upgrade -y


# Install essential tools
print_info "Installing essential packages..."
apt install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tmux \
    net-tools \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    ufw \
    fail2ban \
    unattended-upgrades \
    samba \
    samba-common-bin


# Configure automatic security updates
print_info "Configuring automatic security updates..."
dpkg-reconfigure -plow unattended-upgrades


# Configure firewall
print_info "Configuring UFW firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw --force enable


print_info "Firewall configured. Current status:"
ufw status verbose


# Configure fail2ban
print_info "Configuring fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban


if [ ! -f /etc/fail2ban/jail.local ]; then
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    print_info "Created fail2ban local configuration"
fi


# Create directory structure
print_info "Creating directory structure..."
mkdir -p /opt/docker
mkdir -p /opt/scripts
mkdir -p /media/{movies,tv,music,photos}
mkdir -p /backup


# Set ownership (change to your actual user)
if [ ! -z "$SUDO_USER" ]; then
    chown -R $SUDO_USER:$SUDO_USER /opt/docker
    chown -R $SUDO_USER:$SUDO_USER /opt/scripts
    chown -R $SUDO_USER:$SUDO_USER /media
    chown -R $SUDO_USER:$SUDO_USER /backup
    print_info "Set ownership to $SUDO_USER"
fi


# System tweaks for media server
print_info "Applying system tweaks..."


# Increase file watchers (for Plex and other services)
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
    sysctl -p
fi


# Optimize network settings
if ! grep -q "net.core.rmem_max" /etc/sysctl.conf; then
    cat >> /etc/sysctl.conf << EOF


# Network optimizations for media streaming
net.core.rmem_max=26214400
net.core.rmem_default=26214400
net.core.wmem_max=26214400
net.core.wmem_default=26214400
EOF
    sysctl -p
fi


# Clean up
print_info "Cleaning up..."
apt autoremove -y
apt autoclean


print_info "============================================"
print_info "System preparation complete!"
print_info "============================================"
print_info "Next steps:"
print_info "1. Review and configure fail2ban: /etc/fail2ban/jail.local"
print_info "2. Run: sudo ./02-install-docker.sh"
print_info "============================================"