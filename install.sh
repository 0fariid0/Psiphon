#!/bin/bash

# Define the path for the Psiphon files
PSIPHON_BINARY_PATH="/usr/local/bin/psiphon"
PSIPHON_SERVICE_PATH="/etc/systemd/system/psiphon.service"
PSIPHON_INSTALLER_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2"

# Create directory for Psiphon if it does not exist
echo "Creating Psiphon directory..."
sudo mkdir -p /etc/psiphon

# Download the Psiphon installer
echo "Downloading Psiphon installer..."
wget $PSIPHON_INSTALLER_URL -O /tmp/plinstaller2

# Run the installer
echo "Running the Psiphon installer..."
sudo bash /tmp/plinstaller2

# Create the Psiphon service file
echo "Creating Psiphon service..."
sudo bash -c "cat > $PSIPHON_SERVICE_PATH <<EOL
[Unit]
Description=Psiphon Service

[Service]
ExecStart=$PSIPHON_BINARY_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL"

# Reload systemd to recognize the new service
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable and start the Psiphon service
echo "Enabling and starting Psiphon service..."
sudo systemctl enable psiphon.service
sudo systemctl start psiphon.service

echo "Psiphon installation and service setup completed."
