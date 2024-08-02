#!/bin/bash

# Download the Psiphon manager script
echo "Downloading Psiphon manager script..."
wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh -O /usr/local/bin/psiphon_manager.sh

# Make the script executable
chmod +x /usr/local/bin/psiphon_manager.sh

# Inform the user
echo "Psiphon manager script installed successfully."
echo "Running the Psiphon manager script..."

# Run the script
/usr/local/bin/psiphon_manager.sh
