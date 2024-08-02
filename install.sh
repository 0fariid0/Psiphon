#!/bin/bash

# Define the path for the Psiphon manager script
MANAGER_SCRIPT_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh"
MANAGER_SCRIPT_PATH="/usr/local/bin/psiphon_manager.sh"

# Download the Psiphon manager script
echo "Downloading Psiphon manager script..."
wget -q "$MANAGER_SCRIPT_URL" -O "$MANAGER_SCRIPT_PATH"

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

# Execute the Psiphon manager script
echo "Running the Psiphon manager script..."
sudo "$MANAGER_SCRIPT_PATH"
