#!/bin/bash

# Source common functions
source utils/common.sh


# Function to install Tenderduty
install_tenderduty() {
    cd $HOME
    rm -rf tenderduty
    git clone https://github.com/blockpane/tenderduty
    cd tenderduty
    go install
}

# Display Taro Logo
echo "Preparing for installation..."
displayTaroLogo
sleep 5

# Update and install packages
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux pkg-config libssl-dev libleveldb-dev tar -y

source ~/.bash_profile 

# Check if Tenderduty is already installed
if command -v tenderduty &> /dev/null; then
    echo "Tenderduty is already installed. Skipping installation."
else
    # Attempt installation
    echo "Attempting to install Tenderduty..."
    sleep 2 
    install_tenderduty
    
    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Tenderduty installation successful."
        sleep 1 
        echo "Copying example configuration file..."
        cp example-config.yml config.yml
        echo "Configuration file copied successfully."
        sleep 1
    else
        echo "Tenderduty installation failed. Retrying once..."
        sleep 2 
        
        # Retry installation
        echo "Retrying installation..."
        install_tenderduty
        
        # Check if retry was successful
        if [ $? -eq 0 ]; then
            echo "Tenderduty installation successful after retry."
            sleep 1
            echo "Copying example configuration file..."
            cp example-config.yml config.yml
            echo "Configuration file copied successfully."
        else
            echo "Tenderduty installation failed. Exiting."
            exit 1
        fi
    fi
fi


# Configuration
# Check if GALACTICA_PORT variable is set
if [ -z "${GALACTICA_PORT}" ]; then
    echo "Error: GALACTICA_PORT variable is not set."
    read -p "Enter the first digits of (Default 26)your GALACTICA_PORT: " GALACTICA_PORT
fi

# Check if VALOPER_ADDRESS variable is set
if [ -z "${VALOPER_ADDRESS}" ]; then
    echo "Error: VALOPER_ADDRESS variable is not set."
    echo "Setting VALOPER_ADDRESS..."
    VALOPER_ADDRESS=$(galacticad keys show $WALLET --bech val -a)
    echo $VALOPER_ADDRESS
fi
# Make a backup of the original file
cp $HOME/tenderduty/config.yml $HOME/tenderduty/config.yml.bak

# Galactica Configuration
echo "Configuring Tenderduty..."
sed -i.bak "s|Osmosis|Galactica|g" $HOME/tenderduty/config.yml
sed -i.bak "s|osmosis-1|galactica_9302-1|g" $HOME/tenderduty/config.yml
sed -i.bak "s|tcp://localhost:26657|tcp://localhost:${GALACTICA_PORT}657|g" $HOME/tenderduty/config.yml
sed -i.bak "s|osmovaloper1xxxxxxx...|$VALOPER_ADDRESS|g" $HOME/tenderduty/config.yml
echo "Tenderduty Galactica configuration complete..."


# Remove unused lines
comment_to_remove="# repeat hosts for monitoring redundancy"
line_to_remove="- url: https://some-other-node:443"
next_line_to_remove="  alert_if_down: no"

# Configure Telegram alerts if exists

# Check if Discord notifications are enabled and webhook is set
if [[ "$GN_DISCORD_NOTIF" == "true" && -n "$GN_DISCORD_WEBHOOK" ]]; then
    # Modify Discord settings
    sed -i.bak '/^discord:/,/^[[:space:]]*$/ {/enabled:/ s/no/yes/}' config.yml
    sed -i.bak "s|webhook: https://discord.com/api/webhooks/999999999999999999/zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz|webhook: $GN_DISCORD_WEBHOOK|" config.yml
fi

# Check if Telegram notifications are enabled and bot token and chat ID are set
if [[ "$GN_TG_NOTIF" == "true" && -n "$GN_TG_BOT_TOKEN" && -n "$GN_TG_CHAT_ID" ]]; then
    # Modify Telegram settings
    sed -i.bak '/^telegram:/,/^[[:space:]]*$/ {/enabled:/ s/no/yes/}' config.yml
    sed -i.bak "s|api_key: \"5555555555:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\"|api_key: \"$GN_TG_BOT_TOKEN\"|" config.yml
    sed -i.bak "s|channel: \"-666666666\"|channel: \"$GN_TG_CHAT_ID\"|" config.yml
fi

# Remove the last entry from config.yml
sed -i.bak "s|$comment_to_remove.*$||" $HOME/tenderduty/config.yml
sed -i.bak "s|$line_to_remove.*$||" $HOME/tenderduty/config.yml
sed -i.bak "s|$next_line_to_remove.*$||" $HOME/tenderduty/config.yml


# Check if tenderdutyd.service exists
if [ -f /etc/systemd/system/tenderdutyd.service ]; then
    echo "Tenderduty service is already set up. Skipping."
else
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
fi

# Start Service
sudo systemctl daemon-reload
sudo systemctl enable tenderdutyd
sudo systemctl start tenderdutyd
sudo systemctl restart tenderdutyd

echo "Tenderduty installation complete..."
echo "Your Tenderduty instance is running on $(hostname -I | awk '{print $1}'):8888"
echo "If the instance is not accessible, please check your firewall rules, check the README for the ports"