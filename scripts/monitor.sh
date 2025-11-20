#!/bin/bash




# ================================================
# Home Media and Automation Center
# System Monitoring Script
# ================================================
# This script displays current system status
# Run as: ./monitor.sh




# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color




# Clear screen
clear




echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}Home Media Server - System Status${NC}"
echo -e "${CYAN}============================================${NC}"
echo -e "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""




# System Information
echo -e "${BLUE}=== System Information ===${NC}"
echo "Hostname:    $(hostname)"
echo "IP Address:  $(hostname -I | awk '{print $1}')"
echo "Uptime:      $(uptime -p)"
echo "OS:          $(lsb_release -d | cut -f2)"
echo ""




# CPU and Memory
echo -e "${BLUE}=== CPU & Memory ===${NC}"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
MEMORY=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
MEMORY_PERCENT=$(free | awk '/^Mem:/ {printf("%.1f"), $3/$2 * 100}')




echo "CPU Usage:   ${CPU_USAGE}%"
echo "Memory:      $MEMORY (${MEMORY_PERCENT}%)"
echo ""




# Disk Usage
echo -e "${BLUE}=== Disk Usage ===${NC}"
df -h | grep -E '^/dev/' | awk '{printf "%-20s %5s / %5s (%s)\n", $6, $3, $2, $5}'
echo ""




# Temperature (if available)
if command -v sensors &> /dev/null; then
    echo -e "${BLUE}=== Temperature ===${NC}"
    sensors | grep -E 'Core|temp' || echo "Temperature sensors not available"
    echo ""
fi




# Docker Containers Status
if command -v docker &> /dev/null; then
    echo -e "${BLUE}=== Docker Containers ===${NC}"
   
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}Docker daemon is not running${NC}"
    else
        RUNNING=$(docker ps -q | wc -l)
        STOPPED=$(docker ps -aq | wc -l)
        TOTAL=$((RUNNING + STOPPED - RUNNING))
       
        echo "Running: $RUNNING | Stopped: $TOTAL"
        echo ""
       
        # List containers with status
        docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | \
        while IFS= read -r line; do
            if [[ $line == *"Up"* ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line == *"Exited"* ]]; then
                echo -e "${RED}$line${NC}"
            else
                echo "$line"
            fi
        done
    fi
    echo ""
fi




# Network Connections
echo -e "${BLUE}=== Active Network Connections ===${NC}"
CONNECTIONS=$(ss -tunap 2>/dev/null | grep ESTAB | wc -l)
echo "Established connections: $CONNECTIONS"
echo ""




# Top 5 Processes by CPU
echo -e "${BLUE}=== Top 5 Processes (CPU) ===${NC}"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-20s %5s%%  %s\n", $11, $3, $2}'
echo ""




# Top 5 Processes by Memory
echo -e "${BLUE}=== Top 5 Processes (Memory) ===${NC}"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-20s %5s%%  %s\n", $11, $4, $2}'
echo ""




# Service Status Check
echo -e "${BLUE}=== Service URLs ===${NC}"
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Plex:           http://${SERVER_IP}:32400/web"
echo "Home Assistant: http://${SERVER_IP}:8123"
echo "Node-RED:       http://${SERVER_IP}:1880"
echo "Portainer:      http://${SERVER_IP}:9010"
echo "Grafana:        http://${SERVER_IP}:3000"
echo ""




# Recent Errors in System Log
echo -e "${BLUE}=== Recent System Errors (Last 10) ===${NC}"
sudo journalctl -p err -n 10 --no-pager | tail -5 || echo "No recent errors"
echo ""




echo -e "${CYAN}============================================${NC}"
echo -e "${GREEN}For continuous monitoring, run: watch -n 5 ./monitor.sh${NC}"
echo -e "${CYAN}============================================${NC}"