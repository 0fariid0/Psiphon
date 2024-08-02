#!/bin/bash

# Define the path for the Psiphon manager script
MANAGER_SCRIPT_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/psiphon_manager.sh"
MANAGER_SCRIPT_PATH="/usr/local/bin/psiphon_manager.sh"

# Function to display the menu
display_menu() {
    clear
    echo "Please choose an option:"
    echo "1. Install Psiphon"
    echo "2. Remove Psiphon"
    echo "3. Exit"
    read -p "Your choice: " choice
}

# Function to install Psiphon
install_psiphon() {
    echo "Downloading Psiphon manager script..."
    wget -q "$MANAGER_SCRIPT_URL" -O "$MANAGER_SCRIPT_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Failed to download Psiphon manager script."
        exit 1
    fi

    sudo chmod +x "$MANAGER_SCRIPT_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Failed to set executable permissions for Psiphon manager script."
        exit 1
    fi
    
    echo "Psiphon manager script downloaded and permissions set."
    echo "Running the Psiphon manager script..."
    sudo "$MANAGER_SCRIPT_PATH"
}

# Function to remove Psiphon
remove_psiphon() {
    echo "Removing Psiphon..."
    sudo rm -f "$MANAGER_SCRIPT_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Failed to remove Psiphon manager script."
    else
        echo "Psiphon manager script removed successfully."
    fi
    
    # Optionally, remove other related files if needed
    sudo rm -f /etc/psiphon/* 2>/dev/null
    sudo rmdir /etc/psiphon 2>/dev/null
}

# Main script logic
while true; do
    display_menu

    case $choice in
        1)
            install_psiphon
            ;;
        2)
            remove_psiphon
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
