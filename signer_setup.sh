#!/bin/sh

# Ensure the script is run with superuser privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ensure password is passed as argument
if [ -z "$1" ]
  then echo "Missing password argument. Usage: ./signer_setup.sh <PASSWORD>"
  exit
fi

PASSWORD=$1

# Update and install ethereum
sudo apt-get update
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get install ethereum

# Save password to file
echo "$PASSWORD" > password.txt

# Create new geth account
geth account new --datadir data --password password.txt > account.txt

# Initialize geth with genesis.json
geth init --datadir data genesis.json

ACCOUNT_ADDRESS=$(grep -o -E '0x[a-fA-F0-9]{40}' account.txt)
echo $ACCOUNT_ADDRESS

WORKDIR=$(pwd)

# Define service configuration
CONFIG="[Unit]
Description=SignerNode

[Service]
WorkingDirectory=$WORKDIR
ExecStart=geth --syncmode full --mine --miner.etherbase $ACCOUNT_ADDRESS --datadir $WORKDIR/data --bootnodes enode://8e516c7bf3e27606256d01119fa303c37cf632756d824ecf33ded99322e483022c12603a8e7dbac9785045ff9e2cee04941ee7c3a8eed56c91913234154f7743@16.62.223.91:30309 --networkid=94 --port 30308 --unlock $ACCOUNT_ADDRESS --password password.txt
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target"

mkdir -p ~/.config/systemd/user

# Save service configuration to file
echo "$CONFIG" > /etc/systemd/system/geth.service

# Reload the systemd manager configuration
systemctl daemon-reload

# Enable and start service
systemctl enable geth
systemctl start geth