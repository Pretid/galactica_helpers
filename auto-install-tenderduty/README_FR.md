[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Installation et configuration automatique de Tenderduty pour le Monitoring

Contributeurs :
- [Taro](https://github.com/bobataro)

Ce script automatise le processus d'installation de [Tenderduty](https://github.com/blockpane/tenderduty) sur votre Galactica Node Validator, il préconfigurera automatiquement Tenderduty pour surveiller votre instance Galatica Node ainsi que saisir les informations de la chaîne.

En cours :
- Notifications Discord/Télégramme/Slack
- Configuration automatique du pare-feu

## Installation
Utilisez la commande suivante :

```bash
# Télécharger le script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/add-auto-tenderduty/auto-install-tenderduty/install_tenderduty.sh"

# Ajout des autorisations d'exécution
chmod +x install_tenderduty.sh

# Exécution de l'installation
./install_tenderduty.sh
```

## Configuration du pare-feu
Cette configuration de pare-feu par défaut exposera:
- Tenderduty (port 8888)
- Prometheus Exporter (28686) 
- Votre node Galactica.

> :warning: Si `ufw` est déjà installé, veuillez exécuter uniquement ces commandes pour ajouter de nouvelles règles :

```bash
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw reload
```

Installation de `ufw` et de nouvelles règles
```bash
sudo apt install ufw 
sudo ufw default allow outgoing 
sudo ufw default deny incoming 
sudo ufw allow ssh/tcp 
sudo ufw limit ssh/tcp 
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw enable
```