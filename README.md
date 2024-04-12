# galactica_helpers
Scripts and help to run a galactica validator node

# install auto delegator
Special thanks to Niko for the main script ! 
## Warning: Storing Password in Clear Text

**Attention:** This script requires the user to input a password, which is then stored in clear text in the `.bashrc` file. Storing passwords in clear text poses a security risk as it could be accessed by unauthorized users who gain access to your system.

It's recommended to avoid storing sensitive information such as passwords in clear text. Consider using secure methods such as environment variables, password managers, or encryption techniques to handle sensitive data securely.

Please proceed with caution and ensure that you understand the implications of storing passwords in clear text before using this script.

## Installation
Use the following command
```
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/install_auto_delegator.sh"
chmod +x install_auto_delegator.sh
./install_auto_delegator.sh
```
## Telegram notification
If you want to get telegram notification you can use the following code. 
Edit your auto-withdraw-redelegue.sh file and add this function at the beginning
```
send_telegram_message() {
    local bot_token="votretoken"
    local chat_id="votre id"
    local message="$1"

    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" -d "chat_id=$chat_id&text=$message" > /dev/null
}
```

Then add at the end of the file the following
```
send_telegram_message "Delegation done. Amount delegated: $AMOUNT"
```

