# Home Media and Automation Center - Code Repository


This repository contains all the code, configurations, and automation scripts for the home media and automation center project.


## 📁 Repository Structure


```
home_media_automation/
├── docker/                          # Docker configurations
│   ├── docker-compose.yml          # Main orchestration file for all services
│   └── .env.example                # Environment variables template
│
├── scripts/                         # Installation and maintenance scripts
│   ├── 01-system-prep.sh           # System preparation (run first)
│   ├── 02-install-docker.sh        # Docker installation
│   ├── 03-setup-services.sh        # Services deployment
│   ├── backup.sh                   # Automated backup script
│   └── monitor.sh                  # System monitoring dashboard
│
├── configs/                         # Service configuration files
│   ├── mosquitto.conf              # MQTT broker configuration
│   ├── nginx-default.conf          # Nginx reverse proxy config
│   └── prometheus.yml              # Metrics collection config
│
├── automations/                     # Home automation examples
│   ├── morning-routine.yaml        # Morning wake-up automation
│   ├── security-mode.yaml          # Away mode security
│   ├── movie-night-scene.yaml      # Movie watching scene
│   ├── energy-saving.yaml          # Energy optimization
│   └── nodered-morning-routine.json # Node-RED flow example
│
├── diagrams/                        # Architecture and planning diagrams
│   ├── system-architecture.md      # Complete system diagram
│   ├── network-topology.md         # Network layout
│   ├── deployment-diagram.md       # Docker deployment
│   ├── data-flow.md               # Workflow diagrams
│   ├── automation-examples.md      # Automation flowcharts
│   ├── quick-reference.md          # Quick reference diagrams
│   └── README.md                   # Diagram index
│
├── IMPLEMENTATION-GUIDE.md         # Detailed step-by-step guide
├── README.md                       # Project documentation
└── LICENSE                         # MIT License


```


## 🚀 Quick Start


### Prerequisites


- Ubuntu Server 22.04 LTS (or Debian 12)
- Minimum 4GB RAM
- 500GB storage (SSD recommended)
- Static IP address configured
- Internet connection


### Installation Steps


1. **Clone this repository** (or copy files to your server):
   ```bash
   git clone https://github.com/nicolassnider/home_media_automation.git
   cd home_media_automation
   ```


2. **Make scripts executable**:
   ```bash
   chmod +x scripts/*.sh
   ```


3. **Run system preparation**:
   ```bash
   sudo ./scripts/01-system-prep.sh
   ```


4. **Install Docker**:
   ```bash
   sudo ./scripts/02-install-docker.sh
   ```


5. **Log out and back in** (to apply Docker group membership)


6. **Set up services**:
   ```bash
   ./scripts/03-setup-services.sh
   ```


7. **Access your services**:
   - Plex: `http://YOUR_IP:32400/web`
   - Home Assistant: `http://YOUR_IP:8123`
   - Node-RED: `http://YOUR_IP:1880`
   - Portainer: `http://YOUR_IP:9000`
   - Grafana: `http://YOUR_IP:3000`


## 📦 What's Included


### Docker Services


| Service | Purpose | Port |
|---------|---------|------|
| **Plex** | Media streaming server | 32400 |
| **Home Assistant** | Home automation platform | 8123 |
| **Node-RED** | Visual automation workflows | 1880 |
| **Mosquitto** | MQTT message broker | 1883 |
| **Nginx** | Reverse proxy with SSL | 80, 443 |
| **Portainer** | Docker management UI | 9000 |
| **Prometheus** | Metrics collection | 9090 |
| **Grafana** | Metrics visualization | 3000 |
| **Node Exporter** | System metrics | 9100 |


### Automation Examples


All automation examples are in the `automations/` folder:


- **Morning Routine** - Gradual wake-up with lights, coffee maker, thermostat
- **Security Mode** - Automatic arming when leaving, motion alerts
- **Movie Night** - Perfect ambiance for watching movies
- **Energy Saving** - Nighttime optimization and daily reports


### Utility Scripts


- **backup.sh** - Automated backup of all configurations
- **monitor.sh** - Real-time system status dashboard
- **System scripts** - Automated installation and setup


## 🔧 Configuration


### Environment Variables


Copy `.env.example` to `.env` and configure:


```bash
cd /opt/docker
cp .env.example .env
nano .env
```


Key variables to set:
- `PLEX_CLAIM_TOKEN` - Get from https://www.plex.tv/claim/
- `GRAFANA_ADMIN_PASSWORD` - Change from default
- `TZ` - Your timezone
- `SERVER_IP` - Your server's static IP


### MQTT Authentication


MQTT credentials are set during `03-setup-services.sh`. To change:


```bash
docker exec mosquitto mosquitto_passwd -b /mosquitto/config/passwd USERNAME PASSWORD
docker restart mosquitto
```


### SSL Certificates


For production use with domain name:


```bash
# Install certbot
sudo apt install certbot


# Get certificate
sudo certbot certonly --standalone -d yourdomain.com


# Update nginx config to use certificates
sudo nano /opt/docker/nginx/conf/default.conf
```


## 📊 Monitoring


### System Monitor


Run the monitoring script for a quick overview:


```bash
./scripts/monitor.sh
```


For continuous monitoring:


```bash
watch -n 5 ./scripts/monitor.sh
```


### Grafana Dashboards


Access Grafana at `http://YOUR_IP:3000`:
- Default credentials: admin/admin (change on first login)
- Add Prometheus data source: http://prometheus:9090
- Import dashboard ID 1860 for Node Exporter metrics


## 💾 Backup & Restore


### Manual Backup


```bash
./scripts/backup.sh
```


Backups are stored in `/backup/` and keep the last 7 backups automatically.


### Automated Daily Backup


Add to crontab:


```bash
crontab -e
```


Add line:
```
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```


### Restore from Backup


```bash
cd /backup
tar -xzf home-media-backup-YYYYMMDD_HHMMSS.tar.gz
# Copy configs back to /opt/docker/
```


## 🏠 Home Assistant Setup


### Initial Setup


1. Access Home Assistant at `http://YOUR_IP:8123`
2. Create owner account
3. Set location and timezone
4. Add MQTT integration (broker: `192.168.1.100`, port: `1883`)


### Installing Automations


1. Copy automation files from `automations/` folder
2. Place in `/opt/docker/homeassistant/config/automations/`
3. Edit entity IDs to match your devices
4. Restart Home Assistant or reload automations


## 🔴 Node-RED Setup


### Initial Setup


1. Access Node-RED at `http://YOUR_IP:1880`
2. Secure with password (edit `/opt/docker/nodered/data/settings.js`)
3. Install Home Assistant nodes via Palette Manager


### Importing Flows


1. Copy content from `automations/nodered-*.json`
2. In Node-RED: Menu → Import → Clipboard
3. Paste JSON content
4. Deploy


## 🔒 Security Best Practices


- [ ] Change all default passwords
- [ ] Enable SSL/HTTPS for external access
- [ ] Use VPN for remote access (recommended)
- [ ] Keep all services updated
- [ ] Regular backup to external drive
- [ ] Monitor failed login attempts
- [ ] Use separate VLAN for IoT devices


## 📖 Documentation


- **[IMPLEMENTATION-GUIDE.md](IMPLEMENTATION-GUIDE.md)** - Detailed step-by-step implementation
- **[diagrams/README.md](diagrams/README.md)** - Architecture diagrams and references
- **[README.md](README.md)** - Project overview and specifications


## 🔄 Updates


### Update Docker Images


```bash
cd /opt/docker
docker compose pull
docker compose up -d
docker image prune -a
```


### Update System


```bash
sudo apt update && sudo apt upgrade -y
```


## 🐛 Troubleshooting


### Services Won't Start


```bash
# Check Docker status
sudo systemctl status docker


# View service logs
cd /opt/docker
docker compose logs SERVICE_NAME


# Restart service
docker compose restart SERVICE_NAME
```


### Network Issues


```bash
# Check firewall
sudo ufw status


# Test connectivity
ping YOUR_SERVER_IP
curl http://YOUR_SERVER_IP:8123
```


### Performance Issues


```bash
# Check resources
./scripts/monitor.sh


# View Docker stats
docker stats


# Check disk space
df -h
```


## 🤝 Contributing


This is a personal project, but improvements are welcome:


1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request


## 📄 License


MIT License - see [LICENSE](LICENSE) file for details


## 🆘 Support


For issues or questions:
- Check the [IMPLEMENTATION-GUIDE.md](IMPLEMENTATION-GUIDE.md) troubleshooting section
- Review service logs: `docker compose logs SERVICE_NAME`
- Open an issue on GitHub


## 📝 Changelog


### November 2025
- Initial project setup
- Complete Docker compose configuration
- Installation scripts created
- Automation examples added
- Documentation completed


---


**Last Updated:** November 08, 2025  
**Project Status:** Ready for deployment  
**Author:** Nicolas Snider