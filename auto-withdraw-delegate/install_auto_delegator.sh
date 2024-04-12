#!/bin/bash
apt-get install cron
# Ask user for phassphrase
read -sp "Enter your PASSPHRASE : " PASSPHRASE
echo

# save Passphrase in .bashrc
echo "export PASSPHRASE=\"$PASSPHRASE\"" >> "$HOME/.bashrc"
source $HOME/.bashrc

# Contenu du script à créer
script_content='#!/bin/bash

cd $HOME
source ~/.bashrc

echo "On withdraw"
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx distribution withdraw-rewards $VALOPER_ADDRESS --from $WALLET --commission --chain-id galactica_9302-1 --gas 200000 --gas-prices 10agnet -y
sleep 5


export AMOUNT=$(galacticad query bank balances $WALLET_ADDRESS | awk '\''/amount/{print substr($3, 2, length($3)-2)}'\'')

echo "Delegate"
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx staking delegate $VALOPER_ADDRESS "$AMOUNT"agnet --from $WALLET --chain-id galactica_9302-1 --gas 200000 --gas-prices 10agnet -y'

file_path="$HOME/auto-withdraw-redelegue.sh"

echo "$script_content" > "$file_path"

chmod +x "$file_path"

echo "Script file created with success"

cron_job="0 * * * * $HOME/auto-withdraw-redelegue.sh"

# Add cron task
(crontab -l ; echo "$cron_job") | crontab -

echo "Cron task create and will be executed every hour"
