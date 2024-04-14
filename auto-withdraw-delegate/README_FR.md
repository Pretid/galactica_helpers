[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Commission and Reward Auto-Withdraw and Delegate Script
Merci à ces members pour leur contribution à ce script:
- Niko
-
-
-

Ce script automatise le processus du retrait des commissions et des récompenses d'un nœud validateur et puis de leur auto-délégation au nœud.
Il simplifie la gestion des revenus de votre nœud, garantissant que vous maximisez vos récompenses sans intervention manuelle.

--- 
>:warning: **Ce script stocke votre `PASSPHRASE` en texte non encrypté**: Soyez prudent! </br>

Ce script nécessite que l'utilisateur entre sa `PASSPHRASE`, qui est ensuite stockée en texte non encrypté dans le fichier `.bashrc`. Le stockage de passphrase ou de mots de passe en texte non encrypté présente un risque de sécurité, car des utilisateurs non autorisés qui accèdent à votre système pourraient y accéder.

Il est recommandé d'éviter de stocker des informations sensibles telles que des mots de passe et les `PASSPHRASE`s en texte non encrypté. Pensez à utiliser des méthodes sécurisées telles que des variables d'environnement, des gestionnaires de mots de passe ou des techniques d'encryption pour gérer les données sensibles en toute sécurité.

Veuillez procéder avec prudence et assurez-vous de bien comprendre les implications du stockage des mots de passe en texte non encrypté avant d'utiliser ce script.

## Installation
Utilisez la commande suivante:
```bash
# Télécharge le script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/auto-withdraw-delegate/install_auto_delegator.sh"

# Ajout des autorisations d'éxécution
chmod +x install_auto_delegator.sh

# Exécute l'installation
./install_auto_delegator.sh
```
## Telegram notifications and alerts

Cette section est un travail en cours.

If you want to get telegram notification you can use the following code. 

Edit your auto-withdraw-redelegue.sh file and add this function at the beginning
```bash
send_telegram_message() {
    local bot_token="votretoken"
    local chat_id="votre id"
    local message="$1"

    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" -d "chat_id=$chat_id&text=$message" > /dev/null
}
```

Then add at the end of the file the following
```bash
send_telegram_message "Delegation done. Amount delegated: $AMOUNT"
```

