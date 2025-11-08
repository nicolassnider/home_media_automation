# Deployment Architecture

## Container Deployment

```mermaid
graph TB
    subgraph "Host OS - Ubuntu Server 22.04"
        KERNEL[Linux Kernel]
        DOCKER_ENGINE[Docker Engine]

        subgraph "Docker Containers"
            subgraph "Media Stack"
                PLEX_C[Plex Container<br/>linuxserver/plex<br/>Ports: 32400]
                PLEX_V1[(Media Storage<br/>/media)]
                PLEX_V2[(Config<br/>/config)]
            end

            subgraph "Automation Stack"
                HA_C[Home Assistant<br/>homeassistant/home-assistant<br/>Ports: 8123]
                HA_V1[(Config<br/>/config)]

                NR_C[Node-RED<br/>nodered/node-red<br/>Ports: 1880]
                NR_V1[(Data<br/>/data)]

                MQTT_C[Mosquitto MQTT<br/>eclipse-mosquitto<br/>Ports: 1883, 9001]
                MQTT_V1[(Config<br/>/mosquitto)]
            end

            subgraph "Infrastructure"
                NGINX_C[Nginx Proxy<br/>nginx<br/>Ports: 80, 443]
                NGINX_V1[(SSL Certs<br/>/etc/nginx/ssl)]

                PORTAINER_C[Portainer<br/>portainer/portainer-ce<br/>Ports: 9000]
                PORTAINER_V1[(Data<br/>/data)]

                GRAFANA_C[Grafana<br/>grafana/grafana<br/>Ports: 3000]
                PROM_C[Prometheus<br/>prom/prometheus<br/>Ports: 9090]
            end
        end

        subgraph "Persistent Storage"
            VOLUME_MEDIA[/media/movies<br/>/media/tv<br/>/media/music]
            VOLUME_CONFIG[/docker/configs]
            VOLUME_BACKUP[/backup]
        end
    end

    KERNEL --> DOCKER_ENGINE
    DOCKER_ENGINE --> PLEX_C
    DOCKER_ENGINE --> HA_C
    DOCKER_ENGINE --> NR_C
    DOCKER_ENGINE --> MQTT_C
    DOCKER_ENGINE --> NGINX_C
    DOCKER_ENGINE --> PORTAINER_C
    DOCKER_ENGINE --> GRAFANA_C
    DOCKER_ENGINE --> PROM_C

    PLEX_C --> PLEX_V1
    PLEX_C --> PLEX_V2
    HA_C --> HA_V1
    NR_C --> NR_V1
    MQTT_C --> MQTT_V1
    NGINX_C --> NGINX_V1
    PORTAINER_C --> PORTAINER_V1

    PLEX_V1 -.-> VOLUME_MEDIA
    PLEX_V2 -.-> VOLUME_CONFIG
    HA_V1 -.-> VOLUME_CONFIG
    NR_V1 -.-> VOLUME_CONFIG

    HA_C -.->|API| MQTT_C
    NR_C -.->|Subscribe| MQTT_C

    NGINX_C -.->|Proxy| PLEX_C
    NGINX_C -.->|Proxy| HA_C
    NGINX_C -.->|Proxy| NR_C

    PROM_C -.->|Metrics| HA_C
    PROM_C -.->|Metrics| PLEX_C
    GRAFANA_C -.->|Queries| PROM_C

    style KERNEL fill:#4caf50,color:#fff
    style DOCKER_ENGINE fill:#2196f3,color:#fff
    style PLEX_C fill:#e6a23c
    style HA_C fill:#f56c6c
    style NR_C fill:#9c27b0,color:#fff
    style MQTT_C fill:#00bcd4
```

## Docker Compose Structure

```mermaid
graph LR
    subgraph "docker-compose.yml"
        DC[Docker Compose File]
    end

    subgraph "Service Definitions"
        DC --> S1[plex:<br/>image, ports,<br/>volumes, env]
        DC --> S2[homeassistant:<br/>image, ports,<br/>volumes, network]
        DC --> S3[nodered:<br/>image, ports,<br/>volumes, env]
        DC --> S4[mosquitto:<br/>image, ports,<br/>volumes, config]
        DC --> S5[nginx:<br/>image, ports,<br/>volumes, depends_on]
        DC --> S6[portainer:<br/>image, ports,<br/>volumes]
    end

    subgraph "Networks"
        S1 --> NET1[bridge network]
        S2 --> NET1
        S3 --> NET1
        S4 --> NET1
        S5 --> NET1
    end

    subgraph "Volumes"
        S1 --> V1[media-data]
        S2 --> V2[ha-config]
        S3 --> V3[nodered-data]
        S4 --> V4[mqtt-config]
        S5 --> V5[nginx-ssl]
    end

    style DC fill:#4caf50,color:#fff
    style NET1 fill:#2196f3,color:#fff
```

## Service Dependencies

```mermaid
graph TD
    START([System Boot]) --> DOCKER[Docker Engine Starts]

    DOCKER --> MQTT[Mosquitto MQTT<br/>Priority: 1]
    MQTT --> HA[Home Assistant<br/>Priority: 2<br/>depends_on: mqtt]
    MQTT --> NR[Node-RED<br/>Priority: 2<br/>depends_on: mqtt]

    DOCKER --> PLEX[Plex Media Server<br/>Priority: 1<br/>Independent]

    HA --> NGINX[Nginx Reverse Proxy<br/>Priority: 3<br/>depends_on: ha, plex]
    NR --> NGINX
    PLEX --> NGINX

    DOCKER --> PORT[Portainer<br/>Priority: 1<br/>Management UI]

    NGINX --> READY([All Services Ready])
    PORT --> READY

    style START fill:#4caf50,color:#fff
    style DOCKER fill:#2196f3,color:#fff
    style MQTT fill:#00bcd4
    style HA fill:#f56c6c
    style NR fill:#9c27b0,color:#fff
    style PLEX fill:#e6a23c
    style NGINX fill:#4caf50,color:#fff
    style READY fill:#4caf50,color:#fff
```
