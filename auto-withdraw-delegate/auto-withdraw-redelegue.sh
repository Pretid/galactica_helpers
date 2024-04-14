#!/bin/bash

source ~/.bash_profile


DISCORD=false # changer par true s'il faut utiliser la fonction
TG=false # changer par true s'il faut utiliser la fonction

URL_EXPLORER="https://testnet.itrocket.net/galactica/tx/"
CHAIN_ID="galactica_9302-1"


#Discord WEBHOOK URL
WEBHOOK_URL="METTRE L URL DE VOTRE WEBHOOK" # /!\ A config /!\
send_discord_message() {
    local webhook_url="$1"
    local message="$2"
    curl -X POST \
        -H "Content-Type: application/json" \
        --data "{\"content\":\"$message\"}" \
        "$webhook_url"
}

send_telegram_message() {
    local bot_token="votretoken" # /!\ A config /!\
    local chat_id="votre id" # /!\ A config /!\
    local message="$1"

    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" -d "chat_id=$chat_id&text=$message" > /dev/null
}
#===================================================================#
#On récupère la balance
BALANCE=$(galacticad query bank balances $WALLET_ADDRESS | awk '/amount/{print substr($3, 2, length($3)-2)}')
#===================================================================#


#===================================================================#
                        #WITHDRAW
echo "On withdraw"
output_hash1=$(echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad tx distribution withdraw-rewards $VALOPER_ADDRESS --from $WALLET --commission --chain-id $CHAIN_ID --gas 200000 --gas-prices 10agnet -y | grep -oP 'txhash: \K\S+')
txhash1=$output_hash1
echo "txhash1: $txhash1"

if [ "$DISCORD" = true ]; then
#Discord Notification
send_discord_message "$WEBHOOK_URL" "Withdrawal tx: $URL_EXPLORER$txhash1"
elif [ "$TG" = true ]; then
#Telegram Notification
send_telegram_message "$WEBHOOK_URL" "Withdrawal tx: $URL_EXPLORER$txhash1"
fi
#===================================================================#

sleep 3

#===================================================================#
                        #DELEGATE
# Sometimes, the amount of the balance is lower than the delegate value.
# so, we want to reduce the amount to delegate
# Check the balance, and  if the amount is greater than 1 GNET, delegate 1 GNET less than Wallet amount, else, delegate zero.

echo "Delegate"

LENGTH=${#BALANCE}
echo "Lenght : $LENGTH" 

if [ ${#BALANCE} -gt 10 ]; then
    # Get the length of BALANCE
    LENGTH=${#BALANCE}
    echo "Lenght : $LENGTH" 

    # Calculate the index of the 10th and 9th characters from the right
    INDEX=$((LENGTH - 9))
    echo "Index : $INDEX"
    # Replace the characters at the calculated index with zeros
    AMOUNT="${BALANCE:0:INDEX-1}00${BALANCE:INDEX+1}"

    echo "AMOUNT: $AMOUNT"



output_hash2=$(echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad tx staking delegate $VALOPER_ADDRESS "$AMOUNT"agnet --from $WALLET --chain-id $CHAIN_ID --gas 200000 --gas-prices 10agnet -y | grep -oP 'txhash: \K\S+')
txhash2=$output_hash2
echo "txhash2: $txhash2"
sleep 1
    if [ "$DISCORD" = true ]; then
        # Notification Discord
        send_discord_message "$WEBHOOK_URL" "Delegate tx: $URL_EXPLORER$txhash2"
    elif [ "$TG" = true ]; then
        # Notification Telegram
        send_telegram_message "$WEBHOOK_URL" "Delegate tx: $URL_EXPLORER$txhash2"
    fi

else
        # Discord Notification
        if [ "$DISCORD" = true ]; then
            send_discord_message "$WEBHOOK_URL" "Balance insuffisante $AMOUNT"

        # Telegram Notification
        elif [ "$TG" = true ]; then
             send_telegram_message "Balance insuffisante $AMOUNT"            
        fi
fi