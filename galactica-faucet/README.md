# Galactica Faucet
>⚠️ **Community Repository**: Please note that the scripts in this repository are contributed by members of the Galactica community and may not be officially endorsed or supported by the Galactica development team. While efforts are made to ensure the quality and security of the scripts, users should exercise caution and review the code before running it in their node validators.

Configuration:
    - Pour l'utilisation d'un WEBHOOK pour DISCORD : 
        - DISCORD=false # true pour l'utiliser
        - WEBHOOK_URL # L'adresse du webhook généré sur votre channel discord
    - WALLET_FAUCET="YOUR_WALLET" # Remplacer YOUR_WALLET par le votre 

Placer dans le répertoire de votre choix
    -Créer un CRON
        - Exemple toutes les 5 minutes: `#*/5 * * * *  /home/Nicolas/faucet/galactica_ubi.sh > /home/Nicolas/faucet_ubi.log 2>&1`
        - Créer un fichier log pour garder une trace des éxécutions.

## License

The scripts in this repository are licensed under the GNU General Public License (GPL). See the [LICENSE](./LICENSE) file for more details.