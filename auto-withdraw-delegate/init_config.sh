#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Display "CRAMPON" where each letter has a different color
echo -e "${RED}C${GREEN}R${YELLOW}A${BLUE}M${MAGENTA}P${CYAN}O${WHITE}N${NC}"

# Path to the bashrc file
BASHRC="$HOME/.bash_profile"

echo "This script will initialize variables that are used by the other scripts. The variables will be stores in $BASHRC"

# Prompt for each variable and append to bashrc
echo "Please enter the value for GN_DISCORD_NOTIF activate or not discord notification (true or false):"
read GN_DISCORD_NOTIF

echo "Please enter the value for GN_DISCORD_WEBHOOK:"
read GN_DISCORD_WEBHOOK

echo "Please enter the value for GN_TG_NOTIF activate or not telegram notification(true or false):"
read GN_TG_NOTIF

echo "Please enter the value for GN_TG_BOT_TOKEN:"
read GN_TG_BOT_TOKEN

echo "Please enter the value for GN_TG_CHAT_ID:"
read GN_TG_CHAT_ID

echo "Enter your PASSPHRASE : "
read PASSPHRASE
#hardcoding this but you can change it in bash file
GN_URL_EXPLORER="https://testnet.itrocket.net/galactica/tx/"

# Display the values
echo "You have entered the following values:"
echo "GN_DISCORD_NOTIF: $GN_DISCORD_NOTIF"
echo "GN_DISCORD_WEBHOOK: $GN_DISCORD_WEBHOOK"
echo "GN_TG_NOTIF: $GN_TG_NOTIF"
echo "GN_TG_BOT_TOKEN: $GN_TG_BOT_TOKEN"
echo "GN_TG_CHAT_ID: $GN_TG_CHAT_ID"
echo "GN_URL_EXPLORER: $GN_URL_EXPLORER"
echo "PASSPHRASE: $PASSPHRASE"

# Ask for confirmation
echo "Are all values correct? (y/n)"
read answer

# Check the response
if [[ $answer == "y" || $answer == "yes" ]]; then
    echo "export GN_URL_EXPLORER=\"$GN_URL_EXPLORER\"" >> "$BASHRC"
    echo "export GN_DISCORD_NOTIF=\"$GN_DISCORD_NOTIF\"" >> "$BASHRC"
    echo "export GN_DISCORD_WEBHOOK=\"$GN_DISCORD_WEBHOOK\"" >> "$BASHRC"
    echo "export GN_TG_NOTIF=\"$GN_TG_NOTIF\"" >> "$BASHRC"
    echo "export GN_TG_BOT_TOKEN=\"$GN_TG_BOT_TOKEN\"" >> "$BASHRC"
    echo "export GN_TG_CHAT_ID=\"$GN_TG_CHAT_ID\"" >> "$BASHRC"
    echo "export GN_URL_EXPLORER=\"$GN_URL_EXPLORER\"" >> "$BASHRC"
    echo "export PASSPHRASE=\"$PASSPHRASE\"" >> "$BASHRC"
    echo "All variables set, let's run scripts now ! "
    source $BASHRC
fi
