#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with root privileges (using sudo)."
  exit 1
fi

# Name of the installation script
SERVICE_FILE="/etc/systemd/system/psiphon.service"
PLINSTALLER_FILE="plinstaller2"

# Function to install Psiphon
install_psiphon() {
  echo "Downloading plinstaller2 file..."
  wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O $PLINSTALLER_FILE

  # Check if the download was successful
  if [ $? -ne 0 ]; then
    echo "Failed to download the plinstaller2 file."
    exit 1
  fi

  # Grant execute permissions to plinstaller2
  chmod +x $PLINSTALLER_FILE

  # Run plinstaller2
  echo "Running plinstaller2..."
  sudo ./$PLINSTALLER_FILE

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

  echo "Installation completed successfully!"
}

# Function to clean up Psiphon
cleanup_psiphon() {
  echo "Stopping Psiphon service..."
  sudo systemctl stop psiphon.service

  echo "Disabling Psiphon service..."
  sudo systemctl disable psiphon.service

  if [ -f "$SERVICE_FILE" ]; then
    echo "Removing service file..."
    sudo rm "$SERVICE_FILE"
  else
    echo "Service file not found."
  fi

  echo "Reloading systemd..."
  sudo systemctl daemon-reload

  if [ -f "$PLINSTALLER_FILE" ]; then
    echo "Removing plinstaller2 file..."
    rm "$PLINSTALLER_FILE"
  else
    echo "plinstaller2 file not found."
  fi

  echo "Cleanup completed successfully!"
}

# Menu selection
echo "Choose an option:"
echo "1) Install Psiphon"
echo "2) Remove Psiphon"
read -p "Enter your choice [1 or 2]: " choice

case $choice in
  1)
    install_psiphon
    ;;
  2)
    cleanup_psiphon
    ;;
  *)
    echo "Invalid choice. Please enter 1 or 2."
    ;;
esac
