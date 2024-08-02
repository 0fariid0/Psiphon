#!/bin/bash

# Download the Psiphon manager script
echo "Downloading Psiphon manager script..."
wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh -O /usr/local/bin/psiphon_manager.sh

# Make the script executable
chmod +x /usr/local/bin/psiphon_manager.sh

# Inform the user
echo "Psiphon manager script installed successfully."
echo "You can run it using the command: psiphon_manager.sh"
