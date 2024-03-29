#!/bin/bash

# Define variables
INSTALL_DIR="/opt/climateTrackr"
CONFIG_DIR="/etc/climateTrackr"
REPO_URL="https://github.com/mrapanu/ClimateTrackr-Sensor.git"
SERVICE_NAME="climatetrackr"
OS_VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
# Install dependencies

if [ "$OS_VERSION_CODENAME" == "jammy" ]; then
    apt install -y python3-libgpiod python3 python3-dev python3-pip git || { echo "Error installing dependencies. Exiting."; exit 1; }
    pip install --upgrade pip setuptools wheel || { echo "Error upgrading pip, setuptools, and wheel. Exiting."; exit 1; }
    pip install pika --upgrade || { echo "Error installing pika. Exiting."; exit 1; }
    pip install adafruit-circuitpython-dht || { echo "Error installing adafruit dht. Exiting."; exit 1; }
    pip install RPi.GPIO || { echo "Error installing adafruit RPi.GPIO. Exiting."; exit 1; }

elif [ "$OS_VERSION_CODENAME" == "mantic" ] || [ "$OS_VERSION_CODENAME" == "bullseye" ]; then
    apt install -y python3-libgpiod python3 python3-dev python3-pip git || { echo "Error installing dependencies. Exiting."; exit 1; }
    pip install --upgrade pip setuptools wheel --break-system-packages || { echo "Error upgrading pip, setuptools, and wheel. Exiting."; exit 1; }
    pip install pika --upgrade --break-system-packages || { echo "Error installing pika. Exiting."; exit 1; }
    pip install adafruit-circuitpython-dht --break-system-packages || { echo "Error installing adafruit dht. Exiting."; exit 1; }
    pip install RPi.GPIO --break-system-packages || { echo "Error installing adafruit RPi.GPIO. Exiting."; exit 1; }

else
#Not tested. Try to install python dependencies with pip3
    apt install -y python3-libgpiod python3 python3-dev python3-pip git || { echo "Error installing dependencies. Exiting."; exit 1; }
    pip3 install --upgrade pip setuptools wheel || { echo "Error upgrading pip, setuptools, and wheel. Exiting."; exit 1; }
    pip3 install pika --upgrade || { echo "Error installing pika. Exiting."; exit 1; }
    pip3 install adafruit-circuitpython-dht || { echo "Error installing adafruit dht. Exiting."; exit 1; }
    pip3 install RPi.GPIO || { echo "Error installing adafruit RPi.GPIO. Exiting."; exit 1; }

fi

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

# Clean up INSTALL_DIR
rm -f $INSTALL_DIR/install.sh
rm -rf $INSTALL_DIR/config
rm -f $INSTALL_DIR/README.md
rm -rf $INSTALL_DIR/.git
rm -rf $INSTALL_DIR/images
# Move uninstall-climatetrackr.sh from /opt/climateTrackr to /usr/local/bin
mv $INSTALL_DIR/uninstall-climatetrackr.sh /usr/local/bin/

# Make uninstall-climatetrackr.sh executable
chmod +x /usr/local/bin/uninstall-climatetrackr.sh

echo "Installation complete. Use the following commands for service management:"
echo "systemctl status $SERVICE_NAME"
echo "systemctl start $SERVICE_NAME"
echo "systemctl stop $SERVICE_NAME"
echo "To uninstall, run the script located at: /usr/local/bin/uninstall-climatetrackr.sh"
