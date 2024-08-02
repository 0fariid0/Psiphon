#!/bin/bash

# Display menu
echo "Please choose an option:"
echo "1. Install Psiphon"
echo "2. Uninstall Psiphon"
echo "3. Exit"

# Read user choice
read -p "Your choice (1/2/3): " choice

case "$choice" in 
  1 )
    echo "You have chosen to install Psiphon."
    read -p "Do you want to continue with the installation? (y/n): " confirm
    if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
      echo "Installing Psiphon..."
      
      # Download the installation script
      wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2
      
      # Run the installation script with root privileges
      sudo sh plinstaller2
      
      # Remove the installation script
      sudo rm -rf plinstaller2
      
      echo "Psiphon has been successfully installed."
      
      # Create the systemd service file
      sudo bash -c 'cat << EOF > /etc/systemd/system/psiphon.service
[Unit]
Description=Psiphon Service
After=network.target

[Service]
ExecStart=/usr/bin/psiphon
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF'
      
      # Reload systemd, enable and start the Psiphon service
      sudo systemctl daemon-reload
      sudo systemctl enable psiphon
      sudo systemctl start psiphon
      
      echo "Psiphon service has been successfully created and started."
    else
      echo "Installation aborted."
    fi
    ;;
  2 )
    echo "You have chosen to uninstall Psiphon."
    read -p "Do you want to continue with the uninstallation? (y/n): " confirm
    if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
      echo "Uninstalling Psiphon..."
      
      # Stop and disable the service
      sudo systemctl stop psiphon
      sudo systemctl disable psiphon
      
      # Remove the service file
      sudo rm -rf /etc/systemd/system/psiphon.service
      
      # Remove the Psiphon executable
      sudo rm -rf /usr/bin/psiphon
      
      echo "Psiphon has been successfully uninstalled."
    else
      echo "Uninstallation aborted."
    fi
    ;;
  3 )
    echo "Exiting the script."
    exit 0
    ;;
  * )
    echo "Invalid input. Please choose a valid option."
    exit 1
    ;;
esac
