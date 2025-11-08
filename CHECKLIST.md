# Home Media and Automation Center - Quick Start Checklist


Use this checklist to track your progress through the project implementation.


## ✅ Pre-Installation


- [ ] Old computer cleaned and inspected
- [ ] RAM upgraded to 4GB (if needed)
- [ ] SSD installed (if needed)
- [ ] Ubuntu Server 22.04 LTS ISO downloaded
- [ ] Bootable USB drive created
- [ ] Static IP address planned (e.g., 192.168.1.100)
- [ ] Repository cloned or files copied to server


## ✅ Phase 1: System Setup


- [ ] Ubuntu Server installed
- [ ] System fully updated (`sudo apt update && sudo apt upgrade`)
- [ ] Static IP configured
- [ ] SSH tested from another computer
- [ ] Script files made executable (`chmod +x scripts/*.sh`)
- [ ] Run `01-system-prep.sh` completed
- [ ] Firewall configured and enabled
- [ ] Fail2ban running


## ✅ Phase 2: Docker Installation


- [ ] Run `02-install-docker.sh` completed
- [ ] Logged out and back in (Docker group applied)
- [ ] Docker working without sudo (`docker ps`)
- [ ] Docker Compose verified (`docker compose version`)


## ✅ Phase 3: Services Configuration


- [ ] `.env` file created from `.env.example`
- [ ] Plex claim token obtained from plex.tv/claim
- [ ] `.env` file configured with your values
- [ ] MQTT username/password chosen
- [ ] Run `03-setup-services.sh` completed
- [ ] All containers running (`docker ps`)


## ✅ Phase 4: Service Setup


### Plex
- [ ] Plex web interface accessible
- [ ] Plex account signed in
- [ ] Server claimed
- [ ] Media libraries created
- [ ] Test media added via Samba
- [ ] Playback tested


### Home Assistant
- [ ] Home Assistant accessible (port 8123)
- [ ] Owner account created
- [ ] Location and timezone set
- [ ] MQTT integration added
- [ ] First device integrated


### Node-RED
- [ ] Node-RED accessible (port 1880)
- [ ] Admin password configured
- [ ] Home Assistant nodes installed
- [ ] Test flow created


### Monitoring
- [ ] Portainer accessible (port 9000)
- [ ] Admin account created
- [ ] Grafana accessible (port 3000)
- [ ] Default password changed
- [ ] Prometheus data source added


## ✅ Phase 5: Network & Security


- [ ] Firewall rules verified (`sudo ufw status`)
- [ ] All required ports opened
- [ ] SSL certificate obtained (if using domain)
- [ ] Nginx reverse proxy configured
- [ ] HTTPS working (if configured)
- [ ] Remote access tested (if needed)


## ✅ Phase 6: Automations


- [ ] Morning routine automation created
- [ ] Security mode automation configured
- [ ] Movie night scene tested
- [ ] Energy saving automation added
- [ ] Notifications working


## ✅ Phase 7: Backup & Maintenance


- [ ] Manual backup tested (`./scripts/backup.sh`)
- [ ] Backup file verified in `/backup/`
- [ ] Cron job for daily backup created
- [ ] External backup drive configured (optional)
- [ ] Restore procedure tested


## ✅ Phase 8: Finalization


- [ ] All services tested end-to-end
- [ ] Performance acceptable
- [ ] UPS connected and configured
- [ ] Server physically installed
- [ ] Cables managed and labeled
- [ ] Documentation updated
- [ ] Family members trained
- [ ] Emergency procedures documented


## 📋 Weekly Maintenance Checklist


Copy this for your regular maintenance:


```
Date: __________


□ Check system logs for errors
□ Verify all Docker containers running
□ Check disk space (df -h)
□ Review Home Assistant logs
□ Test automations
□ Verify backup completed
□ Check for system updates
□ Monitor CPU/memory usage
```


## 🆘 Emergency Contacts & Info


```
Server IP:           __________________
Router IP:           __________________
Server Location:     __________________
UPS Model:           __________________
MQTT Password:       (stored securely)
Grafana Password:    (stored securely)
Backup Location:     __________________
```


## 📝 Notes & Customizations


Use this space for your specific setup notes:


```
_____________________________________________________________


_____________________________________________________________


_____________________________________________________________


_____________________________________________________________


_____________________________________________________________
```


---


**Installation Started:**  ____/____/________


**Installation Completed:** ____/____/________


**Project Status:** [ ] Planning  [ ] In Progress  [ ] Complete  [ ] Operational