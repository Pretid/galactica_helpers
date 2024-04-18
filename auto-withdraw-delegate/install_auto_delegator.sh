#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

initScript

# Ask for confirmation
echo "Are all values correct? (y/n)"
read answer

# Check the response
if [[ $answer == "y" || $answer == "yes" ]]; then

    echo "Retrieve and install auto-withdraw-redelegue"

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
    echo "Operation aborted. Please restart the script and enter correct values. You can run init_config.sh from repository"
    exit 1
fi

