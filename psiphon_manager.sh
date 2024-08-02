#!/bin/bash

# Function to install Psiphon
install_psiphon() {
    echo "Downloading Psiphon installer..."
    wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2

    echo "Installing Psiphon..."
    sudo sh plinstaller2

    echo "Creating Psiphon service..."
    sudo systemctl enable psiphon

    echo "Psiphon installed successfully."
}

# Function to remove Psiphon
remove_psiphon() {
    echo "Removing Psiphon..."
    sudo systemctl stop psiphon
    sudo systemctl disable psiphon
    sudo apt-get remove --purge psiphon -y
    sudo rm /usr/local/bin/psiphon_manager.sh

    echo "Psiphon removed successfully."
}

# Function to exit the script
exit_script() {
    echo "Exiting..."
    exit 0
}

# Main menu loop
while true; do
    echo "Please choose an option:"
    echo "1. Install Psiphon"
    echo "2. Remove Psiphon"
    echo "3. Exit"
    read -p "Your choice: " choice

    case $choice in
        1) install_psiphon ;;
        2) remove_psiphon ;;
        3) exit_script ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
