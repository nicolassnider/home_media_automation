# Home Media and Automation Center

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Project Status](https://img.shields.io/badge/Status-Planning-yellow.svg)]()

**Author:** Nicolas Snider  
**Date:** November 08, 2025 a
**Location:** Mexico

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Hardware Specifications](#hardware-specifications)
- [Software Stack](#software-stack)
- [Implementation Plan](#implementation-plan)
- [Network Architecture](#network-architecture)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Project Overview

This project aims to repurpose legacy Core 2 processor hardware into a fully functional home media and automation center. By leveraging open-source technologies and lightweight software solutions, we can create a cost-effective, sustainable smart home hub capable of managing media streaming, IoT devices, and home automation workflows.

## ✨ Objectives

- **Repurpose Legacy Hardware:** Transform existing Core 2 processor-based computer into a reliable media and automation hub
- **Cost-Effective Solution:** Utilize open-source and lightweight technologies to minimize costs
- **Professional Architecture:** Implement scalable design patterns for future expansion
- **Energy Efficiency:** Optimize power consumption for 24/7 operation
- **User-Friendly Interface:** Provide intuitive access to media and automation features

## 💻 Hardware Specifications

### Minimum Requirements

| Component     | Specification                  | Notes                                               |
| ------------- | ------------------------------ | --------------------------------------------------- |
| **Processor** | Intel Core 2 Duo or equivalent | Sufficient for media streaming and light automation |
| **Memory**    | 4GB RAM (minimum 2GB)          | 4GB recommended for better performance              |
| **Storage**   | 500GB HDD/SSD                  | SSD highly recommended for OS and applications      |
| **Network**   | Gigabit Ethernet               | Wi-Fi adapter optional                              |
| **USB Ports** | 2+ USB 2.0/3.0                 | For peripherals and external storage                |
| **Graphics**  | Integrated graphics            | Sufficient for 1080p video playback                 |

### Recommended Upgrades

- **RAM:** Upgrade to 4GB or 8GB if motherboard supports
- **Storage:** Add SSD for OS and frequently accessed media
- **Network:** USB Wi-Fi adapter for flexible placement
- **Cooling:** Clean and replace thermal paste for optimal temperatures

## 🛠️ Software Stack

### Operating System

**Recommended:** Ubuntu Server 22.04 LTS or Debian 12

- Lightweight and stable
- Long-term support
- Extensive package repositories
- Strong community support

### Media Center Solutions

#### Plex Media Server

- **Purpose:** Primary media streaming platform
- **Features:**
  - Cross-platform streaming
  - User management
  - Mobile apps support
  - Transcoding capabilities
- **Installation:** `sudo apt install plexmediaserver`

#### Kodi (Optional)

- **Purpose:** Local media player with rich UI
- **Features:**
  - Extensive plugin ecosystem
  - Custom skins and themes
  - Local and network media playback
- **Installation:** `sudo apt install kodi`

#### Jellyfin (Alternative)

- **Purpose:** Free and open-source media system
- **Features:**
  - No premium features or paid tiers
  - Privacy-focused
  - Active development
- **Installation:** Via official repository

### Home Automation Platform

#### Primary: Home Assistant

- **Language:** Python-based
- **Features:**
  - 2000+ integrations
  - Visual automation editor
  - Mobile apps (iOS/Android)
  - Voice assistant support
  - Local control (no cloud required)
- **Installation:** Docker or supervised installation
- **Resource Usage:** Moderate (optimized for Raspberry Pi)

#### Alternative: Node-RED + Homebridge

- **Language:** Node.js
- **Features:**
  - Visual flow programming
  - Apple HomeKit integration
  - MQTT support
  - Custom nodes ecosystem
- **Installation:**

  ```bash
  sudo npm install -g node-red homebridge
  ```

### Supporting Services

| Service       | Purpose              | Installation                                                             |
| ------------- | -------------------- | ------------------------------------------------------------------------ |
| **Docker**    | Container management | `curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh` |
| **Portainer** | Docker UI management | Docker container                                                         |
| **Nginx**     | Reverse proxy        | `sudo apt install nginx`                                                 |
| **Mosquitto** | MQTT broker for IoT  | `sudo apt install mosquitto`                                             |
| **Samba**     | Network file sharing | `sudo apt install samba`                                                 |

### Development Framework Choice: Node.js vs .NET

Both Node.js and .NET work **excellently on Linux**. Choose based on your needs:

#### Node.js - Recommended for This Project

**Advantages:**

- **Lighter resource footprint** - Critical for Core 2 processor
- **Event-driven architecture** - Perfect for real-time home automation
- **Rich IoT ecosystem** - Libraries for almost every smart home device
- **Lower memory usage** - Typically 50-100MB vs 200-300MB for .NET
- **Faster startup** - Important when running multiple services

**Best for:**

- Home automation workflows
- MQTT message handling
- WebSocket real-time communication
- Rapid prototyping of automation scripts

**Installation:**

```bash
# Install Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

#### .NET 8 - Also Works Great on Linux

**Advantages:**

- **Full Linux support** - Microsoft officially supports and optimizes for Linux
- **Strong typing** - C# prevents many runtime errors
- **Better for complex logic** - Great for data processing, algorithms
- **Excellent performance** - After startup, performs very well
- **Modern language features** - async/await, LINQ, pattern matching

**Resource considerations:**

- Requires ~200-300MB RAM per application
- Slightly slower startup than Node.js
- Still very efficient compared to other frameworks

**Installation:**

```bash
# Install .NET 8 SDK
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0
```

**Use .NET if you:**

- Prefer C# over JavaScript
- Need strong typing and compile-time checks
- Plan to build complex business logic
- Want to integrate with Azure services
- Already know .NET ecosystem

#### Hybrid Approach (Best of Both Worlds)

You can use **both** on the same Linux server:

- **Node.js** for Node-RED and lightweight automation
- **.NET** for custom services or complex data processing
- Both integrate well via REST APIs or MQTT

**Example architecture:**

```
Linux Server
├── Home Assistant (Python) - Main automation
├── Node-RED (Node.js) - Visual workflows
├── Custom .NET Service - Complex processing
└── Plex (C++) - Media streaming
```

> **Bottom Line:** Linux is the best OS choice regardless of whether you pick Node.js or .NET. Both run efficiently on Linux, and .NET on Linux is a first-class experience backed by Microsoft.

## 📝 Implementation Plan

### Phase 1: System Preparation (Week 1)

1. **Hardware Assessment**

   - Clean computer components and check for dust buildup
   - Test RAM modules and storage devices
   - Verify all ports and connections
   - Replace thermal paste if necessary

2. **Operating System Installation**

   - Download Ubuntu Server 22.04 LTS
   - Create bootable USB drive
   - Install OS with minimal packages
   - Configure SSH for remote access
   - Set up static IP address

3. **Initial Configuration**

   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y

   # Install essential tools
   sudo apt install -y curl git htop tmux vim

   # Configure firewall
   sudo ufw allow ssh
   sudo ufw enable
   ```

### Phase 2: Media Center Setup (Week 2)

1. **Plex Installation**

   ```bash
   # Add Plex repository
   wget https://downloads.plex.tv/plex-keys/PlexSign.key -O - | sudo apt-key add -
   echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

   # Install Plex
   sudo apt update
   sudo apt install plexmediaserver
   ```

2. **Media Organization**

   - Create directory structure:

     ```
     /media/
     ├── movies/
     ├── tv_shows/
     ├── music/
     └── photos/
     ```

   - Set up Samba shares for easy file transfer
   - Configure Plex libraries

3. **Storage Configuration**
   - Mount external drives (if applicable)
   - Configure automatic mounting via `/etc/fstab`
   - Set up backup strategy

### Phase 3: Home Automation Setup (Week 3-4)

1. **Docker Installation**

   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER
   ```

2. **Home Assistant Deployment**

   ```bash
   # Create docker-compose.yml
   docker-compose up -d
   ```

3. **Device Integration**

   - Configure smart lights (Philips Hue, LIFX, etc.)
   - Set up smart thermostats
   - Integrate security cameras
   - Connect voice assistants (Alexa, Google Home)

4. **Automation Development**
   - Create morning/evening routines
   - Set up presence detection
   - Configure energy monitoring
   - Develop custom dashboards

### Phase 4: Testing and Optimization (Week 5)

1. **Performance Testing**

   - Monitor CPU and RAM usage
   - Test media streaming quality (local and remote)
   - Verify automation response times
   - Check network bandwidth utilization

2. **Security Hardening**

   - Configure SSL certificates (Let's Encrypt)
   - Set up VPN for remote access
   - Enable two-factor authentication
   - Regular security updates schedule

3. **Documentation**
   - Create user guides for family members
   - Document automation workflows
   - Prepare troubleshooting guides

### Phase 5: Deployment and Maintenance

1. **Physical Installation**

   - Position server in well-ventilated area
   - Connect to network and power
   - Configure UPS for power protection

2. **Monitoring Setup**

   - Install monitoring tools (Grafana, Prometheus)
   - Set up alerts for system issues
   - Configure log rotation

3. **Backup Strategy**
   - Automated configuration backups
   - Regular media library backups
   - System snapshot schedule

## 🌐 Network Architecture

```
Internet
    │
    ├─ Router/Firewall
         │
         ├─ Home Server (Static IP: 192.168.1.100)
         │   ├─ Plex Media Server (Port 32400)
         │   ├─ Home Assistant (Port 8123)
         │   ├─ Node-RED (Port 1880)
         │   └─ Nginx Reverse Proxy (Port 80/443)
         │
         ├─ Smart Home Devices (IoT VLAN)
         │   ├─ Smart Lights
         │   ├─ Thermostats
         │   ├─ Security Cameras
         │   └─ Sensors
         │
         └─ Client Devices
             ├─ Smart TVs
             ├─ Mobile Devices
             └─ Computers
```

### Port Configuration

| Service        | Internal Port | External Port | Protocol | Purpose                    |
| -------------- | ------------- | ------------- | -------- | -------------------------- |
| Plex           | 32400         | 32400         | TCP      | Media streaming            |
| Home Assistant | 8123          | -             | TCP      | Web interface (local only) |
| Node-RED       | 1880          | -             | TCP      | Flow editor (local only)   |
| SSH            | 22            | -             | TCP      | Remote administration      |
| Nginx          | 80/443        | 443           | TCP      | Reverse proxy with SSL     |
| Samba          | 445           | -             | TCP      | File sharing               |

### Recommended Network Settings

- **VLAN Segmentation:** Separate IoT devices from main network
- **Static IP:** Configure static IP for reliable access
- **DNS:** Use local DNS or router reservation
- **Quality of Service (QoS):** Prioritize streaming traffic

## 🔒 Security Considerations

### Essential Security Measures

1. **Firewall Configuration**

   ```bash
   # Configure UFW
   sudo ufw default deny incoming
   sudo ufw default allow outgoing
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 32400/tcp # Plex
   sudo ufw enable
   ```

2. **SSH Hardening**

   - Disable root login
   - Use SSH keys instead of passwords
   - Change default SSH port
   - Install fail2ban for brute-force protection

3. **Regular Updates**

   ```bash
   # Enable automatic security updates
   sudo apt install unattended-upgrades
   sudo dpkg-reconfigure -plow unattended-upgrades
   ```

4. **SSL/TLS Certificates**

   - Use Let's Encrypt for free SSL certificates
   - Configure HTTPS for all web interfaces
   - Set up automatic certificate renewal

5. **Access Control**

   - Implement strong passwords (20+ characters)
   - Enable two-factor authentication where available
   - Use VPN (WireGuard or OpenVPN) for remote access
   - Regularly audit user permissions

6. **IoT Device Security**
   - Change default passwords on all devices
   - Disable unused features and ports
   - Keep firmware updated
   - Use separate VLAN for IoT devices

## 🔧 Troubleshooting

### Common Issues and Solutions

#### System Performance

**Problem:** High CPU usage or system slowdown

- **Solution:** Check running processes with `htop`
- Disable unnecessary services
- Optimize Plex transcoding settings
- Add swap space if RAM is limited

#### Media Playback

**Problem:** Buffering or stuttering during playback

- **Solution:** Check network bandwidth
- Reduce Plex transcoding quality
- Ensure media files are properly encoded
- Use wired connection instead of Wi-Fi

#### Home Automation

**Problem:** Devices not responding

- **Solution:** Verify network connectivity
- Restart Home Assistant service
- Check device battery levels
- Review automation logs

#### Network Access

**Problem:** Cannot access services remotely

- **Solution:** Verify port forwarding settings
- Check firewall rules
- Confirm dynamic DNS is updating
- Test VPN connection

### Useful Commands

```bash
# Check system resources
htop
df -h
free -h


# View service status
sudo systemctl status plexmediaserver
sudo systemctl status home-assistant


# Check logs
sudo journalctl -u plexmediaserver -f
sudo journalctl -u home-assistant -f


# Network diagnostics
ip addr show
ping 192.168.1.1
traceroute google.com


# Docker management
docker ps
docker logs <container_name>
docker-compose restart
```

## 🚀 Future Enhancements

### Short-term (3-6 months)

- [ ] Implement automated backup to cloud storage
- [ ] Add weather station integration
- [ ] Create custom Home Assistant dashboard
- [ ] Set up energy monitoring for home devices
- [ ] Integrate calendar and reminder system

### Medium-term (6-12 months)

- [ ] Add facial recognition for security cameras
- [ ] Implement voice control throughout the home
- [ ] Create advanced automation based on AI/ML patterns
- [ ] Set up multi-room audio system
- [ ] Develop mobile app for quick access

### Long-term (1+ years)

- [ ] Upgrade to more powerful hardware as needed
- [ ] Implement solar panel monitoring
- [ ] Add electric vehicle charging control
- [ ] Create home security system with alerts
- [ ] Develop predictive maintenance for home systems

## 📊 Estimated Costs

| Item                   | Estimated Cost | Notes                      |
| ---------------------- | -------------- | -------------------------- |
| Hardware (existing)    | $0             | Repurposed computer        |
| RAM Upgrade (optional) | $20-40         | 4GB DDR2/DDR3              |
| SSD Upgrade (optional) | $30-60         | 240GB-500GB                |
| Smart Devices          | $100-500       | Lights, sensors, etc.      |
| UPS (recommended)      | $60-120        | Protect against power loss |
| **Total**              | **$210-720**   | Varies based on choices    |

## 🤝 Contributing

This is a personal project, but suggestions and improvements are welcome! If you have ideas for optimizations or additional features, please feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Resources and References

### Documentation

- [Plex Media Server Documentation](https://support.plex.tv/)
- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Node-RED Documentation](https://nodered.org/docs/)
- [Docker Documentation](https://docs.docker.com/)

### Communities

- [r/homelab](https://www.reddit.com/r/homelab/) - Home server enthusiasts
- [r/Plex](https://www.reddit.com/r/Plex/) - Plex community
- [r/homeassistant](https://www.reddit.com/r/homeassistant/) - Home Assistant community
- [Home Assistant Community Forums](https://community.home-assistant.io/)

### Tutorials

- [Ubuntu Server Setup Guide](https://ubuntu.com/server/docs)
- [Docker Compose for Home Automation](https://www.docker.com/blog/)
- [Smart Home Security Best Practices](https://www.owasp.org/index.php/IoT_Security)

## 📞 Support

For questions or issues related to this project:

- Create an issue in the GitHub repository
- Check existing documentation and troubleshooting sections

---

**Last Updated:** November 08, 2025  
**Project Status:** Planning Phase  
**Next Milestone:** Hardware preparation and OS installation
