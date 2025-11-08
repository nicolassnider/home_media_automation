# Quick Reference Diagrams


## Project Structure Overview


```mermaid
mindmap
  root((Home Media &<br/>Automation Center))
    Hardware
      Core 2 Computer
      4GB RAM
      500GB SSD
      Gigabit Network
      UPS Backup
    Software
      Ubuntu Server 22.04
      Docker Engine
      Plex Media Server
      Home Assistant
      Node-RED
      MQTT Broker
    Network
      Main VLAN 192.168.1.x
      IoT VLAN 192.168.2.x
      Reverse Proxy
      VPN Access
    Devices
      Smart Lights
      Thermostats
      Cameras
      Sensors
      Voice Assistants
    Features
      Media Streaming
      Home Automation
      Security Monitoring
      Energy Management
      Remote Access
```


## Technology Stack


```mermaid
graph LR
    subgraph "Frontend"
        WEB[Web Interfaces]
        MOBILE[Mobile Apps]
        TV_APP[TV Apps]
    end
   
    subgraph "Application Layer"
        PLEX[Plex<br/>Media Server]
        HA[Home Assistant<br/>Automation Platform]
        NR[Node-RED<br/>Visual Flows]
    end
   
    subgraph "Integration Layer"
        MQTT[MQTT Broker<br/>Message Queue]
        NGINX[Nginx<br/>Reverse Proxy]
        API[REST APIs]
    end
   
    subgraph "Infrastructure"
        DOCKER[Docker<br/>Containers]
        LINUX[Linux OS<br/>Ubuntu 22.04]
        STORAGE[Storage<br/>File System]
    end
   
    subgraph "Hardware"
        CPU[Core 2<br/>Processor]
        RAM[4GB<br/>Memory]
        DISK[500GB<br/>SSD]
    end
   
    WEB --> NGINX
    MOBILE --> NGINX
    TV_APP --> PLEX
   
    NGINX --> PLEX
    NGINX --> HA
    NGINX --> NR
   
    PLEX --> DOCKER
    HA --> DOCKER
    NR --> DOCKER
   
    HA <--> MQTT
    NR <--> MQTT
   
    DOCKER --> LINUX
    LINUX --> CPU
    LINUX --> RAM
    LINUX --> DISK
    STORAGE --> DISK
   
    style PLEX fill:#e6a23c
    style HA fill:#f56c6c
    style NR fill:#9c27b0,color:#fff
    style DOCKER fill:#2196f3,color:#fff
    style LINUX fill:#4caf50,color:#fff
```


## Service Port Map


```mermaid
graph TB
    subgraph "External Ports"
        EXT_443[443 HTTPS]
        EXT_VPN[51820 WireGuard]
    end
   
    subgraph "Internal Services"
        NGINX_80[80 HTTP]
        NGINX_443[443 HTTPS]
        PLEX_32400[32400 Plex]
        HA_8123[8123 Home Assistant]
        NR_1880[1880 Node-RED]
        MQTT_1883[1883 MQTT]
        MQTT_9001[9001 MQTT WebSocket]
        PORT_9000[9000 Portainer]
        SAMBA_445[445 Samba]
        SSH_22[22 SSH]
    end
   
    EXT_443 --> NGINX_443
    EXT_VPN -.-> SSH_22
   
    NGINX_443 --> PLEX_32400
    NGINX_443 --> HA_8123
    NGINX_443 --> NR_1880
   
    style EXT_443 fill:#f44336,color:#fff
    style EXT_VPN fill:#ff9800
    style NGINX_443 fill:#4caf50,color:#fff
```


## Automation Flow Summary


```mermaid
stateDiagram-v2
    [*] --> Idle
   
    Idle --> EventDetected: Trigger (Time/Sensor/User)
   
    EventDetected --> ConditionCheck: Evaluate Rules
   
    ConditionCheck --> Execute: Conditions Met
    ConditionCheck --> Idle: Conditions Not Met
   
    Execute --> PublishMQTT: Send Commands
    PublishMQTT --> DeviceAction: Control Devices
    DeviceAction --> LogEvent: Record Activity
    LogEvent --> Notify: Send Notification (if needed)
    Notify --> Idle: Complete
   
    DeviceAction --> Error: Failed
    Error --> Retry: Attempt Again
    Retry --> DeviceAction: Retry
    Retry --> Idle: Max Retries
```


## Weekly Maintenance Checklist


```mermaid
gantt
    title Weekly Maintenance Tasks
    dateFormat HH:mm
    axisFormat %H:%M
   
    section Monday
    Check System Updates       :00:00, 15m
    Review Error Logs         :00:15, 15m
   
    section Wednesday
    Backup Configurations     :00:00, 30m
    Test Automations         :00:30, 20m
   
    section Friday
    Monitor Resource Usage    :00:00, 15m
    Update Docker Images      :00:15, 30m
   
    section Sunday
    Full System Backup        :00:00, 1h
    Security Audit           :01:00, 30m
```


## Resource Usage Guidelines


```mermaid
pie title Recommended Resource Allocation
    "Plex Media Server" : 30
    "Home Assistant" : 25
    "Node-RED" : 10
    "MQTT Broker" : 5
    "Nginx Proxy" : 5
    "Monitoring" : 10
    "System Reserve" : 15
```


## Decision Tree: Choosing Technologies


```mermaid
flowchart TD
    START([Start Project]) --> Q1{Need Media<br/>Streaming?}
   
    Q1 -->|Yes| PLEX_YES[Install Plex]
    Q1 -->|No| Q2
   
    PLEX_YES --> Q2{Need Home<br/>Automation?}
   
    Q2 -->|Yes| Q3{Prefer GUI<br/>or Code?}
    Q2 -->|No| END1([Setup Complete])
   
    Q3 -->|GUI| HA_CHOICE[Choose Home Assistant]
    Q3 -->|Code| LANG{Prefer Which<br/>Language?}
   
    LANG -->|JavaScript| NODE_CHOICE[Node-RED + Homebridge]
    LANG -->|C#| DOTNET_CHOICE[.NET + Custom Services]
    LANG -->|Python| HA_CHOICE
   
    HA_CHOICE --> Q4{Need Visual<br/>Workflows?}
    NODE_CHOICE --> Q4
    DOTNET_CHOICE --> Q4
   
    Q4 -->|Yes| ADD_NR[Add Node-RED]
    Q4 -->|No| Q5
   
    ADD_NR --> Q5{Need MQTT?}
   
    Q5 -->|Yes| ADD_MQTT[Install Mosquitto]
    Q5 -->|No| Q6
   
    ADD_MQTT --> Q6{Need Remote<br/>Access?}
   
    Q6 -->|Yes| ADD_PROXY[Setup Nginx + SSL]
    Q6 -->|No| END2([Setup Complete])
   
    ADD_PROXY --> END2
   
    style START fill:#4caf50,color:#fff
    style HA_CHOICE fill:#f56c6c
    style NODE_CHOICE fill:#9c27b0,color:#fff
    style DOTNET_CHOICE fill:#2196f3,color:#fff
    style END2 fill:#4caf50,color:#fff
```


## Cost vs Performance Matrix


```mermaid
quadrantChart
    title Hardware Upgrade Options
    x-axis Low Cost --> High Cost
    y-axis Low Performance --> High Performance
    quadrant-1 Premium Options
    quadrant-2 Best Value
    quadrant-3 Budget Friendly
    quadrant-4 Questionable Value
   
    Use Existing Core 2: [0.2, 0.4]
    Add 4GB RAM: [0.3, 0.6]
    Add SSD 500GB: [0.4, 0.7]
    RAM + SSD: [0.5, 0.8]
    New i3 System: [0.7, 0.85]
    New i5 System: [0.85, 0.95]
```
