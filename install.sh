#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with root privileges (using sudo)."
  exit 1
fi

# Name of the installation script
INSTALL_SCRIPT="install_psiphon.sh"
SERVICE_FILE="/etc/systemd/system/psiphon.service"

# Download the plinstaller2 file
echo "Downloading plinstaller2 file..."
wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download the plinstaller2 file."
  exit 1
fi

# Grant execute permissions to plinstaller2
chmod +x plinstaller2

# Run plinstaller2
echo "Running plinstaller2..."
sudo ./plinstaller2

# Start Psiphon
echo "Starting Psiphon..."
sudo psiphon

# Create the service file
echo "Creating service file..."
cat > $SERVICE_FILE <<EOL
[Unit]
Description=Psiphon Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/psiphon
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd
echo "Reloading systemd..."
systemctl daemon-reload

# Enable and start the service
echo "Enabling Psiphon service..."
systemctl enable psiphon.service
systemctl start psiphon.service

echo "All steps completed successfully!"
