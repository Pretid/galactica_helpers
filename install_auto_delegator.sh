#!/bin/bash
apt-get install cron
# Demande à l'utilisateur de saisir la variable PASSPHRASE
read -sp "Veuillez entrer votre PASSPHRASE : " PASSPHRASE
echo

# Stocke la variable PASSPHRASE dans le fichier .bashrc
echo "export PASSPHRASE=\"$PASSPHRASE\"" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Contenu du script à créer
script_content="#!/bin/bash

echo 'On withdraw'
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx distribution withdraw-all-rewards --from $WALLET --chain-id galactica_9302-1 --gas 200000 --gas-prices 10agnet -y

sleep 5

echo 'On met le solde en variable'
export AMOUNT=$(galacticad query bank balances $WALLET_ADDRESS | awk '/amount/{print substr($3, 2, length($3)-2)}')

echo 'On redelegue'
{
echo "$PASSPHRASE"
echo "$PASSPHRASE"
} |
galacticad tx staking delegate $VALOPER_ADDRESS "$AMOUNT"agnet --from $WALLET --chain-id galactica_9302-1 --gas 200000 --gas-prices 10agnet -y"

# Chemin et nom du fichier à créer
file_path="$HOME/auto-withdraw-redelegue.sh"

# Création du fichier avec le contenu
echo "$script_content" > "$file_path"

# Rendre le fichier exécutable
chmod +x "$file_path"

echo "Le fichier auto-withdraw-redelegue.sh a été créé avec succès."

# Configuration de la tâche cron
cron_job="0 * * * * $HOME/auto-withdraw-redelegue.sh"

# Ajouter la tâche cron
(crontab -l ; echo "$cron_job") | crontab -

echo "La tâche cron a été configurée pour exécuter le script toutes les heures."
