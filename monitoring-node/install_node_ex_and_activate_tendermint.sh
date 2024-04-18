#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)
displayLogo

# Prompt user for input
read -p "Enter the version of node exporter (Current is 1.7.0): " VER
read -p "Enter the username you're logged to run the service (root): " USER
read -p "Enter the monitor IP : " MONITOR_IP
read -p "Enter the validator IP : " VALIDATOR_IP
read -p "Enter the Galactica service name (if installing with itrockets, galacticad.service) : " GALACTICA_SERVICE_NAME

# install node exporter
cd $HOME || exit
wget https://github.com/prometheus/node_exporter/releases/download/v$VER/node_exporter-$VER.linux-amd64.tar.gz
tar xvfz node_exporter-$VER.linux-amd64.tar.gz
sudo rm -f node_exporter-$VER.linux-amd64.tar.gz
mv node_exporter-$VER.linux-amd64/ node-exporter/
cd node-exporter/

sudo ln -s $HOME/node-exporter/node_exporter /usr/local/bin/

# create service to run node-exporter
sudo tee /etc/systemd/system/node-exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network-online.target
[Service]
User=$USER
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=node_exporter
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node-exporter.service
sudo systemctl start node-exporter.service

curl http://localhost:9100/metrics

sudo ufw allow from $MONITOR_IP to $VALIDATOR_IP port 9100

sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.galactica/config/config.toml
sed -i -e 's/namespace = "cometbft"/namespace = "tendermint"/' $HOME/.galactica/config/config.toml
sudo systemctl daemon-reload
sudo systemctl restart $GALACTICA_SERVICE_NAME
sudo ufw allow from $MONITOR_IP to $VALIDATOR_IP port 26660
curl http://localhost:26660/metrics

