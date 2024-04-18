# Install Monitoring on your node

## Install exporter and activate tendermint
On you validator node, execute the following commands. 
This script will :
- download and install node exporter
- create a service to run node exporter
- activate prometheus on galactica configuration
- open port on ufw to access the exporters

```bash
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/monitoring-node/install_node_ex_and_activate_tendermint.sh"
chmod +x install_node_ex_and_activate_tendermint.sh
./install_node_ex_and_activate_tendermint.sh
```

### Check installation
To check if it's working you can run 

```bash
sudo journalctl -u node-exporter.service -f --output cat
#CTRL+C to quit
```
or

```bash
curl http://localhost:9100/metrics
```

## Install prometheus
On you monitoring machine (you can use the same as the validator, but it's not recommended), execute the following commands. 
This script will :
- download and install prometheus
- create a service to run prometheus
- update configuration file to monitor your node
- open port on ufw to access prometheus

```bash
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/monitoring-node/install_prometheus_setup_monitoring.sh"
chmod +x install_prometheus_setup_monitoring.sh
./install_prometheus_setup_monitoring.sh
```


### Check installation
To check if it's working you can run 

```bash
sudo journalctl -u prometheus.service -f --output cat
#CTRL+C to quit
```
or

```bash
curl http://localhost:9090/metrics
```