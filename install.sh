#!/bin/bash

# Define variables
INSTALL_DIR="/opt/climateTrackr"
CONFIG_DIR="/etc/climateTrackr"
REPO_URL="https://github.com/mrapanu/ClimateTrackr-Sensor.git"
SERVICE_NAME="climatetrackr"

# Install dependencies
apt install -y python3 python3-dev python3-pip git
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install pika --upgrade
pip3 install adafruit-circuitpython-dht
pip3 install --install-option="--force-pi" Adafruit_DHT

# Clone the repository
git clone $REPO_URL $INSTALL_DIR

# Create config directory and copy the config file
mkdir -p $CONFIG_DIR
cp $INSTALL_DIR/config/config.ini $CONFIG_DIR

# Create a symbolic link for the main script
ln -s $INSTALL_DIR/main.py /usr/local/bin/climatetrackr

# Create a systemd service file
cat <<EOF > /etc/systemd/system/climatetrackr.service
[Unit]
Description=ClimateTrackr Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/climatetrackr
WorkingDirectory=$INSTALL_DIR
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start the service
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

#Remove install.sh from /opt/climateTrackr
rm -f $INSTALL_DIR/install.sh

#Move uninstall-climatetrackr.sh from /opt/climateTrackr to /usr/local/bin
mv $INSTALL_DIR/uninstall-climatetrackr.sh /usr/local/bin/

echo "Installation complete. Use the following commands for service management:"
echo "systemctl status $SERVICE_NAME"
echo "systemctl start $SERVICE_NAME"
echo "systemctl stop $SERVICE_NAME"
echo "To uninstall, run the script located at: /usr/local/bin/uninstall-climatetrackr.sh"