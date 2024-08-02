#!/bin/bash

install_psiphon() {
    echo "Downloading Psiphon installer..."
    wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2

    echo "Installing Psiphon..."
    sudo sh plinstaller2

    echo "Creating Psiphon service..."
    sudo systemctl enable psiphon

    echo "Psiphon installed successfully."
}

remove_psiphon() {
    echo "Removing Psiphon..."
    sudo apt-get remove --purge psiphon -y
    sudo rm /usr/local/bin/psiphon_manager.sh

    echo "Psiphon removed successfully."
}

while true; do
    echo "Please choose an option:"
    echo "1. Install Psiphon"
    echo "2. Remove Psiphon"
    echo "3. Exit"
    read -p "Your choice: " choice

    case $choice in
        1) install_psiphon ;;
        2) remove_psiphon ;;
        3) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
