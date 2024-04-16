[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Installation et configuration automatique de Tenderduty pour le Monitoring

Contributeurs :
- [Taro](https://github.com/bobataro)

> :warning: Il n'est pas recommandé d'installer tout votre monitoring sur la même instance que votre validateur de nœud, car cela introduit un point de défaillance unique. Si l'instance tombe en panne ou rencontre des problèmes, votre validateur de nœud et vos services de surveillance pourraient être affectés simultanément, entraînant des temps d'arrêt potentiels et des risques opérationnels. Il est recommandé de répartir votre infrastructure de surveillance sur des instances ou des environnements distincts pour garantir la redondance et améliorer la fiabilité globale du système.


Ce script automatise le processus d'installation de [Tenderduty](https://github.com/blockpane/tenderduty) sur votre Galactica Node Validator, il préconfigurera automatiquement Tenderduty pour surveiller votre instance local du Galactica Node ainsi que saisir les informations de la chaîne.

[Tenderduty](https://github.com/blockpane/tenderduty/blob/main/docs/README.md) est un outil pour les validateurs qui ont des nœuds Tendermint. Il envoie des notifications lorsqu'il détecte des problèmes.

- Surveille les performances d'un validateur sur plusieurs chaînes :
     - Vérifie les blocs manqués en fonction des échecs consécutifs ou du pourcentage manqué dans la fenêtre oblique.
     - Alertes en cas d'emprisonnement, de désactivation ou d'inactivité.
     - Destinations d'alerte personnalisables pour chaque chaîne.
- Surveille la santé des nœuds :
     - Alertes facultatives en cas de problèmes de synchronisation ou de non-réponse.
     - Seuil configurable pour alerter en cas de temps d'arrêt.
     - Repli vers les nœuds RPC publics si tous les nœuds sont en panne.
     - Fournit un exportateur Prometheus pour l'intégration avec d'autres systèmes de visualisation.
     - Envoie des alertes à Pagerduty, Discord ou Telegram.
- Contient un tableau de bord pour afficher l'état des nœuds.

![Tenderduty Dashboard](./images/Tenderduty%20Dashboard.png)


## Travail En cours :
- Guide de configuration de Tenderduty plus approfondi
- Configuration des notifications Discord/Telegram/Slack
- Utilisation de Tenderduty sur une machine/instance séparée
- Configuration automatique du pare-feu



## Installation

Pré-Requis:
- Nœud Galactica installé
- Golang installé
---

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


### UFW déjà installé

> Les 2 chiffres de départ par défaut du `GALACTICA_PORT` sont `26` (port complet : `26656`)

 Si `ufw`` est déjà installé, veuillez exécuter uniquement ces commandes pour ajouter de nouvelles règles :

```bash
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw reload
```

### Nouvelle Installation (UFW pas installé)

> Les 2 chiffres de départ par défaut du `GALACTICA_PORT` sont `26` (port complet : `26656`)

Commande d'installation de `ufw` et de nouvelles règles:
```bash
sudo apt install ufw 
sudo ufw default allow outgoing 
sudo ufw default deny incoming 
sudo ufw allow ssh/tcp 
sudo ufw limit ssh/tcp 
sudo ufw allow ${GALACTICA_PORT}656,28686,8888/tcp
sudo ufw enable
```