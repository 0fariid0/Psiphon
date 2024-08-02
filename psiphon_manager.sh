#!/bin/bash

# Define the URL for the Psiphon installer script
INSTALLER_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2"
INSTALLER_PATH="/tmp/plinstaller2"

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
    echo "Downloading Psiphon installer script..."
    wget -q "$INSTALLER_URL" -O "$INSTALLER_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Failed to download Psiphon installer script."
        exit 1
    fi
    
    sudo chmod +x "$INSTALLER_PATH"
    
    echo "Installing Psiphon..."
    sudo "$INSTALLER_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Failed to install Psiphon."
        exit 1
    fi
    
    echo "Psiphon installed successfully."
    echo "Creating Psiphon service..."
    
    # Create and enable the service
    sudo bash -c 'cat << EOF > /etc/systemd/system/psiphon.service
[Unit]
Description=Psiphon Service

[Service]
ExecStart=/usr/local/bin/psiphon
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF'

    sudo systemctl daemon-reload
    sudo systemctl start psiphon.service
    sudo systemctl enable psiphon.service
}

# Function to remove Psiphon
remove_psiphon() {
    echo "Removing Psiphon..."
    
    sudo systemctl stop psiphon.service
    sudo systemctl disable psiphon.service
    sudo rm -f /etc/systemd/system/psiphon.service
    sudo systemctl daemon-reload
    
    echo "Psiphon removed successfully."
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
