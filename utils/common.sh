
# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

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
function printLine {
  echo "------------------------------------------------------------------------------------"
}
function loadConfig {
    cd $HOME
    source ~/.bashrc
    source $HOME/.bash_profile
}

function displayLogo {
    echo -e "${RED}C${GREEN}R${YELLOW}A${BLUE}M${MAGENTA}P${CYAN}O${WHITE}N${NC}"
}

function displayConfig {
    echo "You have entered the following values:"
    echo "GN_DISCORD_NOTIF: $GN_DISCORD_NOTIF"
    echo "GN_DISCORD_WEBHOOK: $GN_DISCORD_WEBHOOK"
    echo "GN_TG_NOTIF: $GN_TG_NOTIF"
    echo "GN_TG_BOT_TOKEN: $GN_TG_BOT_TOKEN"
    echo "GN_TG_CHAT_ID: $GN_TG_CHAT_ID"
    echo "GN_URL_EXPLORER: $GN_URL_EXPLORER"
    echo "GN_ETH_WALLET_ADDRESS: $GN_ETH_WALLET_ADDRESS"
    echo "PASSPHRASE: $PASSPHRASE"
}

function initScript {
    displayLogo
    loadConfig
    displayConfig
}