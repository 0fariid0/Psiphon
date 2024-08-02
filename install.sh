#!/bin/bash

# Define the URL for the Psiphon manager script
MANAGER_SCRIPT_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh"
MANAGER_SCRIPT_PATH="/usr/local/bin/psiphon_manager.sh"

# Download the Psiphon manager script
echo "Downloading Psiphon manager script..."
wget -q "$MANAGER_SCRIPT_URL" -O "$MANAGER_SCRIPT_PATH"

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download Psiphon manager script."
  exit 1
fi

# Set executable permissions
sudo chmod +x "$MANAGER_SCRIPT_PATH"
if [ $? -ne 0 ]; then
  echo "Failed to set executable permissions for Psiphon manager script."
  exit 1
fi

# Display a message and run the Psiphon manager script
echo "Psiphon manager script downloaded and permissions set."
echo "To manage Psiphon, run the following command:"
echo "sudo /usr/local/bin/psiphon_manager.sh"

# Optionally, you could run the script automatically, but it will prompt the user
# sudo /usr/local/bin/psiphon_manager.sh
