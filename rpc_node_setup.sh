#!/bin/sh

# Ensure the script is run with superuser privileges
if [ "$(id -u)" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ensure password is passed as argument
if [ -z "$1" ]
  then echo "Missing password argument. Usage: ./signer_setup.sh <PASSWORD>"
  exit
fi

PASSWORD=$1

TEMP_DIR=$(mktemp -d)
tar -xvf geth-alltools-linux-amd64-1.11.5-a38f4108.tar.gz -C $TEMP_DIR
mv $TEMP_DIR/geth-alltools-linux-amd64-1.11.5-a38f4108/geth /usr/local/bin
rm -r $TEMP_DIR

echo "$PASSWORD" > password.txt

# Create new geth account
geth account new --datadir data --password password.txt > account.txt

# Initialize geth with genesis.json
geth init --datadir data genesis.json

WORKDIR=$(pwd)

# Define service configuration
CONFIG="[Unit]
Description=RPCNode

[Service]
WorkingDirectory=$WORKDIR
ExecStart=geth --syncmode full --gcmode archive --datadir $WORKDIR/data --bootnodes enode://8e516c7bf3e27606256d01119fa303c37cf632756d824ecf33ded99322e483022c12603a8e7dbac9785045ff9e2cee04941ee7c3a8eed56c91913234154f7743@16.62.223.91:30309 --http.port 8545 --networkid=94 --port 30308 --http --http.api eth,net,web3,txpool,debug --ws --ws.origins '*' --ws.port 8546 --ws.addr 127.0.0.1 --ws.api eth,net,web3,network,debug,txpool  --http.addr 127.0.0.1 --http.corsdomain '*'
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

LOG_ROTATE_CONFIG="/var/log/geth/geth.log {
    daily
    rotate 3
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
    size 100M
}"

echo "$LOG_ROTATE_CONFIG" > /etc/logrotate.d/geth

# Create a cron job to execute `journalctl --vacuum-size=100M` every Sunday at 12:00
(crontab -l 2>/dev/null; echo "0 12 * * 0 journalctl --vacuum-size=100M") | crontab -
