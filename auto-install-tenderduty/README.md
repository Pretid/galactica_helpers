[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Automatic Install and Configuration of Tenderduty for monitoring

Contributors:
- [Taro](https://github.com/bobataro)

This script automates the process of installing [Tenderduty](https://github.com/blockpane/tenderduty) onto your Galactica Node Validator, it will automatically pre-configure Tenderduty to monitor your Galatica Node instance as well as input the Chain information.

Work in Progress:
- Discord/Telegram/Slack notifications
- Automatic Firewall Setup

## Installation
Use the following command:

```bash
# Download script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/add-auto-tenderduty/auto-install-tenderduty/install_tenderduty.sh"

# Add execute permissions
chmod +x install_tenderduty.sh

# Execute installation
./install_tenderduty.sh
```

## Firewall Setup
This default firewall setup will expose Tenderduty (port 8888), Prometheus Exporter (28686) and your Galactica Server.

If you already have `ufw` installed, please only run these commands to add new rules:

```bash
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw reload
```

Installation of `ufw` and new rules
```bash
sudo apt install ufw 
sudo ufw default allow outgoing 
sudo ufw default deny incoming 
sudo ufw allow ssh/tcp 
sudo ufw limit ssh/tcp 
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw enable
```

