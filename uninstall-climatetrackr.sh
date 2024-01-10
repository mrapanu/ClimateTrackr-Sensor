#!/bin/bash

# Define variables
INSTALL_DIR="/opt/climateTrackr"
CONFIG_DIR="/etc/climateTrackr"
SERVICE_NAME="climatetrackr"

# Stop and disable the systemd service
systemctl stop $SERVICE_NAME
systemctl disable $SERVICE_NAME

# Remove the systemd service file
rm -f /etc/systemd/system/$SERVICE_NAME.service

# Remove the symbolic link for the main script
rm -f /usr/local/bin/$SERVICE_NAME

# Remove the installed directory
rm -rf $INSTALL_DIR

# Remove the config directory
rm -rf $CONFIG_DIR

rm -f /usr/local/bin/uninstall-climatetrackr.sh

echo "Uninstallation complete."
