[:uk:EN](./README.md) [:fr:FR](./README_FR.md)
# Commission and Reward Auto-Withdraw and Delegate Script
Special thanks to Niko for the main script ! 

This script automates the process of withdrawing commission and rewards from a node validator and self-delegating them back to the node. It simplifies the management of your node's earnings, ensuring that you maximize your rewards without manual intervention.

--- 
>:warning: **This script stores your passphrase in clear text**: Be very careful here. </br>


This script requires the user to input their passphrase, which is then stored in clear text in the `.bashrc` file. Storing passwords or passphrases in clear text poses a security risk as it could be accessed by unauthorized users who gain access to your system.

It's recommended to avoid storing sensitive information such as passwords in clear text. Consider using secure methods such as environment variables, password managers, or encryption techniques to handle sensitive data securely.

Please proceed with caution and ensure that you understand the implications of storing passwords in clear text before using this script.

## Configuration
Before using this command run th init_config.sh file on the root of the repository.

## Installation
Use the following command:

```bash
# Download script
wget "https://raw.githubusercontent.com/Pretid/galactica_helpers/main/auto-withdraw-delegate/install_auto_delegator.sh"

# Add execute permissions
chmod +x install_auto_delegator.sh

# Execute installation
./install_auto_delegator.sh
```

