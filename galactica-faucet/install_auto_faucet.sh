#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

initScript

# Ask for confirmation
echo "Are all values correct? (y/n)"
read answer

# Check the response
if [[ $answer == "y" || $answer == "yes" ]]; then

   echo "Retrieve and install auto-faucet"

    wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/galactica-faucet/galactica_ubi.sh"
    chmod +x galactica_ubi.sh


    cron_job="0 * * * * $HOME/galactica_ubi.sh >> $HOME/galactica_ubi.log 2>&1"
    (crontab -l ; echo "$cron_job") | crontab -

    echo "Cron task create and will be executed every 5 minutes."

    if [ -f "install_auto_faucet.sh" ]; then
        echo "File install_auto_faucet.sh exists. Removing it..."
        rm install_auto_faucet.sh
        echo "File install_auto_faucet.sh removed successfully."
    else
        echo "File install_auto_faucet.sh does not exist."
    fi

else
    echo "Operation aborted. Please restart the script and enter correct values. You can run init_config.sh from repository"
    exit 1
fi
