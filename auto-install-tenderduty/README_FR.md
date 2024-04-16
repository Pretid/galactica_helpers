[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Installation et configuration automatique de Tenderduty pour le Monitoring

Contributeurs :
- [Taro](https://github.com/bobataro)

> :warning: Il n'est pas recommandé d'installer tout votre monitoring sur la même instance que votre validateur de nœud, car cela introduit un point de défaillance unique. Si l'instance tombe en panne ou rencontre des problèmes, votre validateur de nœud et vos services de surveillance pourraient être affectés simultanément, entraînant des temps d'arrêt potentiels et des risques opérationnels. Il est recommandé de répartir votre infrastructure de surveillance sur des instances ou des environnements distincts pour garantir la redondance et améliorer la fiabilité globale du système.


Ce script automatise le processus d'installation de [Tenderduty](https://github.com/blockpane/tenderduty) sur votre Galactica Node Validator, il préconfigurera automatiquement Tenderduty pour surveiller votre instance local du Galactica Node ainsi que saisir les informations de la chaîne.

## En cours :
- Configuration des notifications Discord/Telegram/Slack
- Utilisation de Tenderduty sur une machine/instance séparée
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
## Conditions préalables:
- Nœud Galactica installé
- Allez installé

## Configuration du pare-feu
Cette configuration de pare-feu par défaut exposera:
- Tenderduty (port 8888)
- Prometheus Exporter (28686) 
- Votre node Galactica.

> :warning: Si `ufw` est déjà installé, veuillez exécuter uniquement ces commandes pour ajouter de nouvelles règles :

> The default 2 digits of the GALACTICA_PORT is `26` (full port: `26656`) 

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