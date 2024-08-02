#!/bin/bash

# Define paths and URLs
INSTALLER_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2"
INSTALLER_PATH="/tmp/plinstaller2"
SERVICE_FILE="/etc/systemd/system/psiphon.service"
PSIPHON_BINARY_PATH="/usr/bin/psiphon"
PSIPHON_DIR="/etc/psiphon"

# Function to install Psiphon
install_psiphon() {
  echo "Installing Psiphon..."

  # Create directory if it doesn't exist
  if [ ! -d "$PSIPHON_DIR" ]; then
    sudo mkdir -p "$PSIPHON_DIR"
    if [ $? -ne 0 ]; then
      echo "Failed to create directory $PSIPHON_DIR"
      exit 1
    fi
  else
    echo "Directory $PSIPHON_DIR already exists."
  fi

  # Download and run the Psiphon installer
  wget -q "$INSTALLER_URL" -O "$INSTALLER_PATH"
  if [ $? -ne 0 ]; then
    echo "Failed to download Psiphon installer."
    exit 1
  fi

  sudo chmod +x "$INSTALLER_PATH"
  sudo "$INSTALLER_PATH"
  if [ $? -ne 0 ]; then
    echo "Psiphon installation failed."
    exit 1
  fi

  # Set appropriate permissions for the Psiphon binary and directory
  sudo chmod 755 "$PSIPHON_BINARY_PATH"
  sudo chown root:root "$PSIPHON_BINARY_PATH"

  echo "Psiphon installed successfully."

  create_service
}

# Function to remove Psiphon
remove_psiphon() {
  echo "Removing Psiphon..."

  # Stop and disable the Psiphon service
  if [ -f "$SERVICE_FILE" ]; then
    sudo systemctl stop psiphon.service
    sudo systemctl disable psiphon.service
    sudo rm "$SERVICE_FILE"
    if [ $? -ne 0 ]; then
      echo "Failed to remove Psiphon service."
      exit 1
    fi
    echo "Psiphon service removed."
  else
    echo "Psiphon service does not exist."
  fi

  # Remove Psiphon binary and configuration
  if [ -x "$PSIPHON_BINARY_PATH" ]; then
    sudo rm "$PSIPHON_BINARY_PATH"
    if [ $? -ne 0 ]; then
      echo "Failed to remove Psiphon binary."
      exit 1
    fi
    echo "Psiphon binary removed."
  else
    echo "Psiphon binary does not exist."
  fi

  if [ -d "$PSIPHON_DIR" ]; then
    sudo rm -r "$PSIPHON_DIR"
    if [ $? -ne 0 ]; then
      echo "Failed to remove Psiphon directory."
      exit 1
    fi
    echo "Psiphon directory removed."
  else
    echo "Psiphon directory does not exist."
  fi

  echo "Psiphon removed successfully."
}

# Function to create and enable the Psiphon service
create_service() {
  echo "Creating Psiphon service..."

  # Create the service file if it doesn't exist
  if [ ! -f "$SERVICE_FILE" ]; then
    sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Psiphon Service
After=network.target

[Service]
ExecStart=$PSIPHON_BINARY_PATH
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
    if [ $? -ne 0 ]; then
      echo "Failed to create Psiphon service file."
      exit 1
    fi
    echo "Psiphon service file created."
  else
    echo "Psiphon service file already exists."
  fi

  # Set appropriate permissions for the service file
  sudo chmod 644 "$SERVICE_FILE"
  sudo chown root:root "$SERVICE_FILE"

  # Reload systemd, enable and start the service
  sudo systemctl daemon-reload
  sudo systemctl enable psiphon.service
  sudo systemctl start psiphon.service

  if [ $? -ne 0 ]; then
    echo "Failed to start Psiphon service."
    exit 1
  fi

  echo "Psiphon service created and started successfully."
}

# Main menu
while true; do
  echo "Please choose an option:"
  echo "1. Install Psiphon"
  echo "2. Remove Psiphon"
  echo "3. Exit"
  read -rp "Your choice: " choice

  case $choice in
    1) install_psiphon ;;
    2) remove_psiphon ;;
    3) exit 0 ;;
    *) echo "Invalid option. Please try again." ;;
  esac
done
