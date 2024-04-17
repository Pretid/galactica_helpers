#!/bin/bash

cd $HOME
source ~/.bashrc
source $HOME/.bash_profile


#helper functions

send_telegram_message() {
    if [ "$GN_TG_NOTIF" = true ]; then
        local message="$1"
        curl -s -X POST "https://api.telegram.org/bot$GN_TG_BOT_TOKEN/sendMessage" -d "chat_id=$GN_TG_CHAT_ID&text=$message" > /dev/null
    fi
}

notify() {
    echo "$1"
    send_telegram_message "$1"
    send_discord_message "$1"
}

send_discord_message() {
    if [ "$GN_DISCORD_NOTIF" = true ]; then
     local message="$1"
      curl -X POST \
        -H "Content-Type: application/json" \
        --data "{\"content\":\"$message\"}" \
        "$GN_DISCORD_WEBHOOK"
    fi
}

#main program here

echo "Withdraw rewards and commissions"
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx distribution withdraw-rewards $VALOPER_ADDRESS --from $WALLET --commission --chain-id $CHAIN_ID --gas 200000 --gas-prices 10agnet -y

sleep 5

export AMOUNT=$(galacticad query bank balances $WALLET_ADDRESS | awk '/amount/{print substr($3, 2, length($3)-2)}')

# Ensure AMOUNT is not empty and is numeric using regex
if [ -z "$AMOUNT" ] || ! echo "$AMOUNT" | grep -qE '^[0-9]+$'; then
    echo "Invalid or empty AMOUNT: $AMOUNT"
    notify "Invalid or empty AMOUNT: $AMOUNT"
    exit 1
fi

# Use bc to handle large numbers for comparison
if [ ${#AMOUNT} -le 9 ]; then
    echo "Not enough for delegation : $AMOUNT"
    notify "Not enough for delegation : $AMOUNT"
    exit 1
fi

# let a little bit for fee or whatever
AMOUNT=$(($AMOUNT / 1000 * 1000))
#forcing amount here for test
AMOUNT=100000
output_hash2=$(echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad tx staking delegate $VALOPER_ADDRESS "$AMOUNT"agnet --from $WALLET --chain-id $CHAIN_ID --gas 200000 --gas-prices 10agnet -y | grep -oP 'txhash: \K\S+')
echo "Delegation done"

attempts=3

for ((i=1; i<=attempts; i++))
do
    echo "Attempt $i of $attempts..."

    # Query the transaction and extract the "code" value
    code_value=$(galacticad query tx $output_hash2 | grep "code:" | awk '{print $2}')

    # Check if the code value was successfully retrieved and is equal to 0
    if [ "$code_value" -eq 0 ]; then
        notify "Delegation successful, amount $AMOUNT. Transaction $GN_URL_EXPLORER$output_hash2"
        exit 0
    elif [ "$code_value" -eq 5 ]; then
        echo "Delegation not working, please check transaction $GN_URL_EXPLORER$output_hash2"
        notify "Delegation not working, please check transaction $GN_URL_EXPLORER$output_hash2"
        exit 0
    fi

    # Wait for 10 seconds before the next attempt
    sleep 10
done
notify "Cannot retrieve transaction, please check transaction $GN_URL_EXPLORER$output_hash2"
