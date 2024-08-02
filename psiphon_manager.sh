#!/bin/bash

PSIPHON_SERVICE_PATH="/etc/systemd/system/psiphon.service"

# Function to install Psiphon
install_psiphon() {
    echo "Starting Psiphon installation..."
    sudo bash -c "$(wget -O - https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/install.sh)"
}

# Function to remove Psiphon
remove_psiphon() {
    echo "Removing Psiphon..."
    sudo systemctl stop psiphon.service
    sudo systemctl disable psiphon.service
    sudo rm -f /usr/local/bin/psiphon
    sudo rm -f $PSIPHON_SERVICE_PATH
    sudo rm -rf /etc/psiphon
    sudo systemctl daemon-reload
    echo "Psiphon removed."
}

# Function to show menu
show_menu() {
    clear
    echo "Please choose an option:"
    echo "1. Install Psiphon"
    echo "2. Remove Psiphon"
    echo "3. Exit"
}

# Main script loop
while true; do
    show_menu
    read -p "Your choice: " choice
    case $choice in
        1) install_psiphon ;;
        2) remove_psiphon ;;
        3) exit 0 ;;
        *) echo "Invalid choice. Please enter 1, 2, or 3." ;;
    esac
done
