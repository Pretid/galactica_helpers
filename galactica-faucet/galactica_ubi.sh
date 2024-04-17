#!/bin/bash
#Crontab exemple, toutes les 5mn
#*/5 * * * *  /home/Nicolas/faucet/galactica_ubi.sh > /home/Nicolas/faucet_ubi.log 2>&1

#===================================================================#
                    #DISCORD NOTIFICATION
DISCORD=false
WEBHOOK_URL="URL_OF_WEBHOOK"
#===================================================================#
WALLET_FAUCET="YOUR_WALLET" #Your Wallet
URL_FAUCET="https://faucet-reticulum.galactica.com/api/claim" #Url for FAUCET
#===================================================================#

send_discord_message() {
    local webhook_url="$1"
    local message="$2"    
    message=$(echo "$message" | sed 's/"/\\"/g')
    curl -X POST \
        -H "Content-Type: application/json" \
        --data "{\"content\":\"$message\"}" \
        "$webhook_url"
}


faucet_galactica() {
    curl --location $URL_FAUCET \
    --header 'Content-Transfer-Encoding: application/json' \
    --header 'Content-Type: application/json' \
    --data '{
        "address":"'"$1"'"
    }'
}

check_rate_limit() {
    if echo "$1" | grep -q "You have exceeded the rate limit"; then
        echo "Aucune transaction"       
	    #send_discord_message "$WEBHOOK_URL" "$1"
	
    else    
	echo "Transaction effectu e"
        if [ "$DISCORD" = true ]; then
        send_discord_message "$WEBHOOK_URL" "$1"
        fi
    fi
}

# Adresses   traiter
addresses=(
    # Ajoutez ici les adresses que vous souhaitez traiter
    "$WALLET_FAUCET"
)


for address in "${addresses[@]}"; do
    output=$(faucet_galactica "$address")
    check_rate_limit "$output"
done