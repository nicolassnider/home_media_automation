# Project Diagrams Index


This folder contains comprehensive visual diagrams for the Home Media and Automation Center project. All diagrams use Mermaid syntax for easy viewing on GitHub and other Mermaid-compatible platforms.


## 📐 Architecture & Design Diagrams


### [System Architecture](system-architecture.md)


Complete system architecture showing:
- Hardware layer (Core 2 computer, network, UPS)
- Operating system (Ubuntu Server 22.04 LTS)
- Container layer (Docker, Portainer)
- Core services (Plex, Home Assistant, Node-RED, MQTT)
- Supporting services (Nginx, Samba, Monitoring)
- Smart home devices and client connections


### [Network Topology](network-topology.md)


Network infrastructure including:
- Internet edge and router configuration
- Main network (192.168.1.0/24)
- IoT VLAN (192.168.2.0/24) for device isolation
- Port forwarding and reverse proxy setup
- Service port mappings
- Security zones


### [Deployment Architecture](deployment-diagram.md)


Container deployment details:
- Docker container structure
- Volume mounts and persistent storage
- Service dependencies
- Docker Compose configuration
- Container networking
- Startup sequence


## 🚀 Implementation & Workflow Diagrams


### [Implementation Timeline](implementation-timeline.md)


Project schedule showing:
- 5-week implementation plan (Gantt chart)
- Phase breakdown:
  - Week 1: Hardware preparation and OS installation
  - Week 2: Media center setup
  - Week 3: Home automation platform
  - Week 4: Automation development and testing
  - Week 5: Security hardening and deployment
- Weekly milestone view


### [Data Flow Diagrams](data-flow.md)


System workflows including:
- **Media Streaming Flow** - User request to video playback sequence
- **Home Automation Flow** - Mobile app command to device control
- **Automation Trigger Flow** - Event detection to action execution
- **Security Flow** - Remote access authentication and authorization


### [Automation Examples](automation-examples.md)


Real-world automation scenarios:
- **Morning Routine** - Wake-up automation with gradual lighting, coffee maker, thermostat
- **Security Mode** - Away mode with motion detection and camera recording
- **Movie Night Scene** - Optimized lighting, temperature, and device settings
- **Energy Saving** - Nighttime power optimization and daily reports


## 📖 How to View the Diagrams


### On GitHub
Simply click on any diagram file above - GitHub renders Mermaid diagrams automatically.


### In VS Code
Install the "Markdown Preview Mermaid Support" extension:
```bash
code --install-extension bierner.markdown-mermaid
```


### Online Mermaid Editor
Copy diagram code and paste into: https://mermaid.live/


### Export as Images
Use the Mermaid CLI to export diagrams:
```bash
npm install -g @mermaid-js/mermaid-cli
mmdc -i system-architecture.md -o system-architecture.png
```


## 🎨 Diagram Color Legend


The diagrams use consistent color coding:


- 🟢 **Green** - Starting points, completed states, core infrastructure
- 🔵 **Blue** - Network components, Docker/containers
- 🔴 **Red** - Security components, alerts, critical paths
- 🟠 **Orange** - Decision points, monitoring, warnings
- 🟣 **Purple** - Automation services (Node-RED)
- 🟡 **Yellow** - Media services (Plex)
- 🌸 **Pink** - Home automation (Home Assistant)


## 📝 Updating Diagrams


When making changes to the project:


1. Update the relevant diagram file
2. Test rendering on GitHub or Mermaid Live
3. Update this index if adding new diagrams
4. Commit with descriptive message


## 🔗 Related Documentation


- [Main README](../README.md) - Project overview and setup instructions
- [LICENSE](../LICENSE) - Project license


---


**Note:** All diagrams are in Mermaid format (.md files with code blocks). They are editable as plain text and render automatically on GitHub.
