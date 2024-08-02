#!/bin/bash

# Define URLs and paths
PSIPHON_INSTALLER_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2"
PSIPHON_INSTALLER_PATH="/tmp/plinstaller2"
SERVICE_FILE="/etc/systemd/system/psiphon.service"
PSIPHON_BINARY_PATH="/usr/bin/psiphon"

# Function to download a file
download_file() {
  local url=$1
  local path=$2
  echo "Downloading from $url..."
  wget -q "$url" -O "$path"
  if [ $? -ne 0 ]; then
    echo "Failed to download $url."
    exit 1
  fi
}

# Function to install Psiphon
install_psiphon() {
  echo "Installing Psiphon..."

  # Check and create directory if it doesn't exist
  if [ ! -d "/etc/psiphon/" ]; then
    sudo mkdir -p /etc/psiphon/
    if [ $? -ne 0 ]; then
      echo "Failed to create directory /etc/psiphon/"
      exit 1
    fi
  else
    echo "Directory /etc/psiphon/ already exists."
  fi

  # Download and run Psiphon installer
  download_file $PSIPHON_INSTALLER_URL $PSIPHON_INSTALLER_PATH
  sudo chmod +x $PSIPHON_INSTALLER_PATH
  sudo $PSIPHON_INSTALLER_PATH

  # Check for installation success
  if [ -x $PSIPHON_BINARY_PATH ]; then
    echo "Psiphon installed successfully."
  else
    echo "Psiphon installation failed."
    exit 1
  fi
}

# Function to create and enable the Psiphon service
create_service() {
  echo "Creating Psiphon service..."

  # Create service file if it doesn't exist
  if [ ! -f $SERVICE_FILE ]; then
    sudo tee $SERVICE_FILE <<EOF
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
      echo "Failed to create service file."
      exit 1
    fi
  else
    echo "Service file $SERVICE_FILE already exists."
  fi

  # Reload systemd and start the service
  sudo systemctl daemon-reload
  sudo systemctl enable psiphon.service
  sudo systemctl start psiphon.service

  if [ $? -ne 0 ]; then
    echo "Failed to start Psiphon service."
    exit 1
  fi

  echo "Psiphon service created and started successfully."
}

# Main script execution
install_psiphon
create_service
