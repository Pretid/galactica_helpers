#!/bin/bash

echo " .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .-----------------.";
echo "| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |";
echo "| |     ______   | || |  _______     | || |      __      | || | ____    ____ | || |   ______     | || |     ____     | || | ____  _____  | |";
echo "| |   .' ___  |  | || | |_   __ \    | || |     /  \     | || ||_   \  /   _|| || |  |_   __ \   | || |   .'    \`.   | || ||_   \|_   _| | |";
echo "| |  / .'   \_|  | || |   | |__) |   | || |    / /\ \    | || |  |   \/   |  | || |    | |__) |  | || |  /  .--.  \  | || |  |   \ | |   | |";
echo "| |  | |         | || |   |  __ /    | || |   / ____ \   | || |  | |\  /| |  | || |    |  ___/   | || |  | |    | |  | || |  | |\ \| |   | |";
echo "| |  \ \`.___.'\  | || |  _| |  \ \_  | || | _/ /    \ \_ | || | _| |_\/_| |_ | || |   _| |_      | || |  \  \`--'  /  | || | _| |_\   |_  | |";
echo "| |   \`._____.'  | || | |____| |___| | || ||____|  |____|| || ||_____||_____|| || |  |_____|     | || |   \`.____.'   | || ||_____|\____| | |";
echo "| |              | || |              | || |              | || |              | || |              | || |              | || |              | |";
echo "| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |";
echo " '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' ";


# Path to the bashrc file
BASHRC="$HOME/.bash_profile"

# Prompt for each variable and append to bashrc
echo "Please enter the value for GN_DISCORD_NOTIF (true or false):"
read GN_DISCORD_NOTIF

echo "Please enter the value for GN_DISCORD_WEBHOOK:"
read GN_DISCORD_WEBHOOK

echo "Please enter the value for GN_TG_NOTIF(true or false):"
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

    wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/auto-withdraw-delegate/auto-withdraw-redelegue.sh"
    chmod +x auto-withdraw-redelegue.sh


    cron_job="0 * * * * $HOME/auto-withdraw-redelegue.sh >> $HOME/auto-withdraw-redelegue.log 2>&1"
    (crontab -l ; echo "$cron_job") | crontab -

    echo "Cron task create and will be executed every hour"

    if [ -f "install_auto_delegator.sh" ]; then
        echo "File install_auto_delegator.sh exists. Removing it..."
        rm install_auto_delegator.sh
        echo "File install_auto_delegator.sh removed successfully."
    else
        echo "File install_auto_delegator.sh does not exist."
    fi

else
    echo "Operation aborted. Please restart the script and enter correct values."
    exit 1
fi

