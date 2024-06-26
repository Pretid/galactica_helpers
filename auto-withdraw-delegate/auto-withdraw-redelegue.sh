#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

loadConfig

#main program here

echo "Withdraw rewards and commissions"
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx distribution withdraw-rewards $VALOPER_ADDRESS --from $WALLET --commission --chain-id $GALACTICA_CHAIN_ID --gas 200000 --gas-prices 10agnet -y

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
len=${#AMOUNT}
if [ "$len" -le 3 ]; then
    AMOUNT=0
    notify "Amount to small"
    exit 0
else
    # Keep all but the last three digits, effectively truncating to thousands
    AMOUNT=${AMOUNT:0:$len-9}000000000
fi
#forcing amount here for test
#AMOUNT=100000
output_hash2=$(echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad tx staking delegate $VALOPER_ADDRESS "$AMOUNT"agnet --from $WALLET --chain-id $GALACTICA_CHAIN_ID --gas 200000 --gas-prices 10agnet -y | grep -oP 'txhash: \K\S+')
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
    sleep 30
done
notify "Cannot retrieve transaction, please check transaction $GN_URL_EXPLORER$output_hash2"
