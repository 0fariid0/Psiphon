#!/bin/bash

# Define script paths
SCRIPT_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh"
SCRIPT_PATH="/usr/local/bin/psiphon_manager.sh"

# Download the Psiphon manager script
echo "Downloading Psiphon manager script..."
wget $SCRIPT_URL -O $SCRIPT_PATH

# Make the script executable
echo "Setting executable permissions..."
chmod +x $SCRIPT_PATH

# Inform the user
echo "Psiphon manager script installed successfully."
echo "Running the Psiphon manager script..."

# Run the script and redirect any errors to a log file
$SCRIPT_PATH > /var/log/psiphon_manager.log 2>&1
