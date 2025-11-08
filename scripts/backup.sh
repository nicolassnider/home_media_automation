#!/bin/bash


# ================================================
# Home Media and Automation Center
# Backup Script
# ================================================
# This script backs up all important configurations and data
# Run as: ./backup.sh


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


# Configuration
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="home-media-backup-$DATE"
TEMP_BACKUP_DIR="$BACKUP_DIR/$BACKUP_NAME"


# Number of backups to keep
KEEP_BACKUPS=7


# Main Script
print_info "============================================"
print_info "Starting Backup - $DATE"
print_info "============================================"


# Create backup directory
mkdir -p "$TEMP_BACKUP_DIR"


# Backup Docker configurations
print_info "Backing up Docker configurations..."
if [ -d "/opt/docker" ]; then
    mkdir -p "$TEMP_BACKUP_DIR/docker"
   
    # Backup docker-compose files and env
    cp /opt/docker/docker-compose.yml "$TEMP_BACKUP_DIR/docker/" 2>/dev/null || true
    cp /opt/docker/.env "$TEMP_BACKUP_DIR/docker/" 2>/dev/null || true
   
    # Backup service configs (not data)
    print_info "Backing up Home Assistant config..."
    if [ -d "/opt/docker/homeassistant/config" ]; then
        mkdir -p "$TEMP_BACKUP_DIR/docker/homeassistant"
        cp -r /opt/docker/homeassistant/config "$TEMP_BACKUP_DIR/docker/homeassistant/"
    fi
   
    print_info "Backing up Node-RED config..."
    if [ -d "/opt/docker/nodered/data" ]; then
        mkdir -p "$TEMP_BACKUP_DIR/docker/nodered"
        cp -r /opt/docker/nodered/data "$TEMP_BACKUP_DIR/docker/nodered/"
    fi
   
    print_info "Backing up MQTT config..."
    if [ -d "/opt/docker/mosquitto/config" ]; then
        mkdir -p "$TEMP_BACKUP_DIR/docker/mosquitto"
        cp -r /opt/docker/mosquitto/config "$TEMP_BACKUP_DIR/docker/mosquitto/"
    fi
   
    print_info "Backing up Nginx config..."
    if [ -d "/opt/docker/nginx/conf" ]; then
        mkdir -p "$TEMP_BACKUP_DIR/docker/nginx"
        cp -r /opt/docker/nginx/conf "$TEMP_BACKUP_DIR/docker/nginx/"
    fi
   
    print_info "Backing up Prometheus config..."
    if [ -d "/opt/docker/prometheus/config" ]; then
        mkdir -p "$TEMP_BACKUP_DIR/docker/prometheus"
        cp -r /opt/docker/prometheus/config "$TEMP_BACKUP_DIR/docker/prometheus/"
    fi
fi


# Backup scripts
print_info "Backing up scripts..."
if [ -d "/opt/scripts" ]; then
    cp -r /opt/scripts "$TEMP_BACKUP_DIR/"
fi


# Backup system configurations
print_info "Backing up system configurations..."
mkdir -p "$TEMP_BACKUP_DIR/system"


# UFW rules
if command -v ufw &> /dev/null; then
    sudo ufw status numbered > "$TEMP_BACKUP_DIR/system/ufw-rules.txt" 2>/dev/null || true
fi


# Crontab
crontab -l > "$TEMP_BACKUP_DIR/system/crontab.txt" 2>/dev/null || true


# Samba config
if [ -f "/etc/samba/smb.conf" ]; then
    sudo cp /etc/samba/smb.conf "$TEMP_BACKUP_DIR/system/" 2>/dev/null || true
fi


# Create backup info file
print_info "Creating backup metadata..."
cat > "$TEMP_BACKUP_DIR/backup-info.txt" << EOF
Backup Date: $DATE
Hostname: $(hostname)
Server IP: $(hostname -I | awk '{print $1}')
OS Version: $(lsb_release -d | cut -f2)
Docker Version: $(docker --version 2>/dev/null || echo "Not installed")
Backup Contents:
  - Docker configurations
  - Home Assistant config
  - Node-RED flows
  - MQTT config
  - Nginx config
  - Prometheus config
  - Scripts
  - System configurations
EOF


# Create compressed archive
print_info "Creating compressed archive..."
cd "$BACKUP_DIR"
tar -czf "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"


# Remove temporary directory
rm -rf "$TEMP_BACKUP_DIR"


# Calculate archive size
ARCHIVE_SIZE=$(du -h "$BACKUP_NAME.tar.gz" | cut -f1)
print_info "Backup archive created: $BACKUP_NAME.tar.gz ($ARCHIVE_SIZE)"


# Clean old backups
print_info "Cleaning old backups (keeping last $KEEP_BACKUPS)..."
cd "$BACKUP_DIR"
ls -t home-media-backup-*.tar.gz 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)) | xargs -r rm
REMAINING=$(ls -1 home-media-backup-*.tar.gz 2>/dev/null | wc -l)


# Show summary
print_info "============================================"
print_info "Backup Complete!"
print_info "============================================"
print_info "Backup file: $BACKUP_DIR/$BACKUP_NAME.tar.gz"
print_info "Archive size: $ARCHIVE_SIZE"
print_info "Backups stored: $REMAINING"
print_info ""
print_info "To restore, run: tar -xzf $BACKUP_NAME.tar.gz"
print_info "============================================"


# Optional: Copy to external drive if mounted
EXTERNAL_BACKUP="/mnt/external-backup"
if [ -d "$EXTERNAL_BACKUP" ] && mountpoint -q "$EXTERNAL_BACKUP"; then
    print_info "Copying to external backup drive..."
    cp "$BACKUP_DIR/$BACKUP_NAME.tar.gz" "$EXTERNAL_BACKUP/"
    print_info "External backup created successfully"
fi


exit 0