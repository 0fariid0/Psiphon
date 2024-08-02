#!/bin/bash

# Function to install Psiphon
install_psiphon() {
    echo "Downloading and installing Psiphon..."
    wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2
    sudo sh plinstaller2
    
    echo "Creating service for Psiphon..."
    # Create a service file for systemd
    sudo bash -c 'cat > /etc/systemd/system/psiphon.service <<EOF
[Unit]
Description=Psiphon Service
After=network.target

[Service]
ExecStart=/usr/local/bin/psiphon
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF'
    
    # Reload service file and enable it
    sudo systemctl daemon-reload
    sudo systemctl enable psiphon
    sudo systemctl start psiphon
    
    echo "Psiphon has been successfully installed and started."
}

# Function to remove Psiphon
remove_psiphon() {
    echo "Removing Psiphon..."
    sudo systemctl stop psiphon
    sudo systemctl disable psiphon
    sudo rm /etc/systemd/system/psiphon.service
    sudo systemctl daemon-reload
    sudo rm /usr/local/bin/psiphon
    echo "Psiphon has been successfully removed."
}

# Function to display the menu and get user input
show_menu() {
    echo "Please choose an option:"
    echo "1. Install Psiphon"
    echo "2. Remove Psiphon"
    echo "3. Exit"
}

# Main menu loop
while true; do
    show_menu
    read -p "Your choice: " choice
    case $choice in
        1) install_psiphon ;;
        2) remove_psiphon ;;
        3) exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
