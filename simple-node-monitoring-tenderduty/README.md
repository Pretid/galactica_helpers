[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Automatic Install and Configuration of Tenderduty for monitoring

Contributors:
- [Taro](https://github.com/bobataro)

> [!WARNING] 
> It is not recommended to install all of your monitoring stack onto the same instance as your node validator, as it introduces a single point of failure. If the instance goes down or experiences issues, both your node validator and monitoring services could be affected simultaneously, leading to potential downtime and operational risks. It's best practice to distribute your monitoring infrastructure across separate instances or environments to ensure redundancy and improve overall system reliability.

This script automates the process of installing [Tenderduty](https://github.com/blockpane/tenderduty) onto your Galactica Node Validator, it will automatically pre-configure Tenderduty to monitor your local Galatica Node instance as well as input the Chain information.

[Tenderduty](https://github.com/blockpane/tenderduty/blob/main/docs/README.md) is a tool for validators running tendermint nodes. It sends notifications when it detects problems.

- Monitors a validator's performance across multiple chains:
    - Checks for missed blocks based on consecutive misses or percentage missed within the slashing window.
    - Alerts for being jailed, tombstoned, or inactive.
    - Customizable alert destinations for each chain.
- Monitors node health:
    - Optional alerts for syncing issues or unresponsiveness.
    - Configurable threshold for alerting on downtime.
    - Fallback to public RPC nodes if all nodes are down.
    - Provides a Prometheus exporter for integration with other visualization systems.
    - Sends alerts to Pagerduty, Discord, or Telegram.
- Includes a dashboard for displaying status.


![Tenderduty Dashboard](./images/Tenderduty%20Dashboard.png)

## Work in Progress:
- Guide to Configuring Tenderduty more in-depth 
- ~~Configuring Discord/Telegram/ notifications~~ - **Done**
- Using Tenderduty on a separate machine
- ~~Automatic Firewall Setup~~ Too many variables to manage, manually setting up the rules is safer.



## Installation
Pre-requisites:
- Galactica Node installed

Use the following command:

```bash
# Remove previous script
rm install_tenderduty.sh

# Download script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/simple-node-monitoring-tenderduty/install_tenderduty.sh"

# Add execute permissions
chmod +x install_tenderduty.sh

# Execute installation
./install_tenderduty.sh
```

Upon completing the installation process, you will receive a message containing the IP Address and Port necessary for accessing Tenderduty. 
```bash
"Your Tenderduty instance is running on <YOUR-IP-ADDRESS>:8888"
```

If accessibility issues arise, please review your firewall rules or configure them accordingly as outlined below.

## Firewall Setup
This default firewall setup will expose:
- Tenderduty (port 8888), 
- Prometheus Exporter (port 26660) 
- Your Galactica Server.

### UFW (Uncompicated Firewall) Example

>[!NOTE]
> UFW (uncomplicated firewall) is a firewall configuration tool that runs on top of iptables, included by default within Ubuntu distributions. It provides a streamlined interface for configuring common firewall use cases via the command line.

#### UFW already installed

> The default starting 2 digits of the `GALACTICA_PORT` is `26` (full port: `26656`) 

If you already have `ufw` installed, please only run these commands to add new rules:

```bash
sudo ufw allow ${GALACTICA_PORT}656,26660,8888/tcp
sudo ufw reload
```

#### New Installation (UFW not installed)

> The default starting 2 digits of the `GALACTICA_PORT` is `26` (full port: `26656`) 

Installation of `ufw` and new rules
```bash
sudo apt install ufw 
sudo ufw default allow outgoing 
sudo ufw default deny incoming 
sudo ufw allow ssh/tcp 
sudo ufw limit ssh/tcp 
sudo ufw allow ${GALACTICA_PORT}656,26660,8888/tcp
sudo ufw enable
```

