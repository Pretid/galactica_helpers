#!/bin/bash
# Update and install packages
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux pkg-config libssl-dev libleveldb-dev tar -y

# Install Tenderduty
cd $HOME
rm -rf tenderduty
git clone https://github.com/blockpane/tenderduty
cd tenderduty
go install
cp example-config.yml config.yml

# Configuration
# Check if GALACTICA_PORT variable is set
if [ -z "${GALACTICA_PORT}" ]; then
    echo "Error: GALACTICA_PORT variable is not set. Please set it before running this script."
    read -p "Enter your GALACTICA_PORT: " GALACTICA_PORT
    exit 1
fi

# Check if VALOPER_ADDRESS variable is set
if [ -z "${VALOPER_ADDRESS}" ]; then
    echo "Error: VALOPER_ADDRESS variable is not set."
    echo "Setting VALOPER_ADDRESS..."
    VALOPER_ADDRESS=$(galacticad keys show $WALLET --bech val -a)
    echo $VALOPER_ADDRESS
    exit 1
fi
# Make a backup of the original file
cp $HOME/tenderduty/config.yml $HOME/tenderduty/config.yml.bak

sed -i.bak 's|Osmosis|Galactica|g' $HOME/tenderduty/config.yml
sed -i.bak 's|osmosis-1|galactica_9302-1|g' $HOME/tenderduty/config.yml
sed -i.bak "s|tcp://localhost:26657|tcp://localhost:${GALACTICA_PORT}657|g" $HOME/tenderduty/config.yml
sed -i.bak "s|osmovaloper1xxxxxxx...|$VALOPER_ADDRESS|g" $HOME/tenderduty/config.yml


# Set tenderduty as a service
sudo tee /etc/systemd/system/tenderdutyd.service << EOF
[Unit]
Description=Tenderduty
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=5
TimeoutSec=180

User=$USER
WorkingDirectory=$HOME/tenderduty
ExecStart=$(which tenderduty)

# there may be a large number of network connections if a lot of chains
LimitNOFILE=infinity

# extra process isolation
NoNewPrivileges=true
ProtectSystem=strict
RestrictSUIDSGID=true
LockPersonality=true
PrivateUsers=true
PrivateDevices=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Start Service
sudo systemctl daemon-reload
sudo systemctl enable tenderdutyd
sudo systemctl start tenderdutyd
sudo systemctl restart tenderdutyd