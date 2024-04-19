#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

cd $HOME
loadConfig

#===================================================================#
WALLET_FAUCET=(
    "$GN_ETH_WALLET_ADDRESS"
)
URL_FAUCET="https://faucet-reticulum.galactica.com/api/claim" #Url for FAUCET
#===================================================================#

faucet_galactica() {
    echo "call faucet for $1"
    curl --location $URL_FAUCET \
    --header 'Content-Transfer-Encoding: application/json' \
    --header 'Content-Type: application/json' \
    --data '{
        "address":"'"$1"'"
    }'
}

check_rate_limit() {
    if echo "$1" | grep -q "You have exceeded the rate limit"; then
        echo "No transaction"       
    else    
	echo "Transaction done"
        notify "$1"
    fi
}


for address in "${WALLET_FAUCET[@]}"; do
    output=$(faucet_galactica "$address")
    check_rate_limit "$output"
done

