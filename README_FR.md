[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Galactica helpers

>[!WARNING]
>**Dépot Communautaire**: Veuillez noter que les scripts de ce dépot sont fournis par des membres de la communauté Galactica et ne sont pas officiellement approuvés ou pris en charge par l'équipe de développement de Galactica. Des efforts ont été pris pour garantir la qualité et la sécurité des scripts, mais, les utilisateurs doivent faire preuve de prudence et examiner le code avant de l'exécuter dans leurs validateurs de nœuds.

## Initialiser

Avant d'exécuter des scripts, vous devez configurer votre configuration, exécutez ces commandes pour configurer votre configuration.

```bash
# Download script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/init_config.sh"

# Add execute permissions
chmod +x init_config.sh

# Execute installation
./init_config.sh
```
Cela définira toutes les variables dont nous avons besoin pour les autres scripts.

### Which variables must be set to run all the scripts ? 
Voici toutes les variables qui doivent être définies pour exécuter tous les scripts.
Votre fichier `bashrc`` ou `bash_profile` doit avoir ces variables.
```bash
export GN_URL_EXPLORER="https://testnet.itrocket.net/galactica/tx/"
export GN_DISCORD_NOTIF="false"
export GN_DISCORD_WEBHOOK="webhookurlfordiscord"
export GN_TG_NOTIF="true"
export GN_TG_BOT_TOKEN="your telegram token"
export GN_TG_CHAT_ID="your telegram chat"
export GN_URL_EXPLORER="https://testnet.itrocket.net/galactica/tx/"
export PASSPHRASE="your passphrase"
export GN_ETH_WALLET_ADDRESS="your 0x wallet address to get from the faucet"
```
Et ceux des scripts ITRocket.

## Scripts
- [Auto Withdraw and Delegate - Retrait automatique de délégation](./auto-withdraw-delegate/)
- [Réclamation automatique du faucet](./galactica-facuet/)
- [Monitoring node](./monitoring-node/)
- [Simple Node Monitoring](./simple-node-monitoring-tenderduty/) - Tenderduty

## License

Les scripts de ce dépot sont sous licence GNU General Public License (GPL). Voir le fichier [LICENSE](./LICENSE) pour plus de détails.