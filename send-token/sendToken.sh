#!/bin/bash
clear

source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

loadConfig

# Fonction pour afficher le solde du compte par défaut
afficher_solde() {
    adresse=$1
    solde=$(galacticad q bank balances "$adresse" --output=json | jq -r '.balances[].amount')
    echo "Solde du compte $adresse : $solde tokens ($(convertir_gnet "$solde" D) gnet)" 
    
}


# Afficher le solde par défaut
afficher_solde "$(echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad keys show "$WALLET" -a)"



# Fonction pour envoyer des tokens
envoyer_tokens() {
    read -p "Adresse de destination : " adresse_dest
    read -p "Montant à envoyer : " montant
    # Commande pour envoyer des tokens
      echo -e "$PASSPHRASE\n$PASSPHRASE" | galacticad tx bank send "$WALLET_ADDRESS" "$adresse_dest" "$montant"agnet --gas 200000 --gas-prices 10agnet --dry-run
}

# Menu pour envoyer des tokens
echo "=== MENU ==="
echo "1. Envoyer des tokens"
echo "2. Quitter"
read -p "Choix : " choix

case $choix in
    1)
        envoyer_tokens
        ;;
    2)
        echo "Au revoir !"
        exit
        ;;
    *)
        echo "Choix invalide. Veuillez choisir une option valide."
        ;;
esac

