[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Galactica helpers
>⚠️ **Community Repository**: Please note that the scripts in this repository are contributed by members of the Galactica community and may not be officially endorsed or supported by the Galactica development team. While efforts are made to ensure the quality and security of the scripts, users should exercise caution and review the code before running it in their node validators.

## Initialize

Before running any scripts you have to setup your configuration, run these commands.

```bash
# Download script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/init_config.sh"

# Add execute permissions
chmod +x init_config.sh

# Execute installation
./init_config.sh
```
This will set all the variables we need for the others scripts.

### Which variables must be set to run all the scripts ? 
Here are all the variables that should be set for running all the scripts. 
Your bashrc or bash_profile file should have theses variables.
```bash
export GN_DISCORD_NOTIF="false"
export GN_DISCORD_WEBHOOK="webhookurlfordiscord"
export GN_TG_NOTIF="true"
export GN_TG_BOT_TOKEN="your telegram token"
export GN_TG_CHAT_ID="your telegram chat"
export GN_URL_EXPLORER="https://testnet.itrocket.net/galactica/tx/"
export PASSPHRASE="your passphrase"
export GN_ETH_WALLET_ADDRESS="your 0x wallet address to get from the faucet"
```
And of course the one of the ITRocket scripts.

## Scripts

- [Auto Withdraw and Delegate](./auto-withdraw-delegate/)
- [Auto claim faucet](./galactica-faucet/)
- [Monitoring node](./monitoring-node/)

## License

The scripts in this repository are licensed under the GNU General Public License (GPL). See the [LICENSE](./LICENSE) file for more details.
