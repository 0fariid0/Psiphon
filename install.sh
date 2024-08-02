#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 {install|uninstall}"
    exit 1
}

# Check if wget is installed
check_wget() {
    if ! command -v wget &> /dev/null; then
        echo "wget not found. Please install wget according to your Linux distribution's installation guide."
        exit 1
    fi
}

# Install Psiphon
install() {
    check_wget

    # Default directory for script storage
    DESTINATION_DIR="$HOME/Downloads"
    SCRIPT_URL="https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2"

    # Change to the destination directory
    cd "$DESTINATION_DIR" || { echo "Failed to change directory to $DESTINATION_DIR"; exit 1; }

    # Download the script
    echo "Downloading the installation script..."
    wget "$SCRIPT_URL" -O plinstaller2 || { echo "Failed to download the script."; exit 1; }

    # Run the script
    echo "Running the installation script..."
    sudo sh plinstaller2 || { echo "Failed to run the installation script."; exit 1; }

    # Remove the script after installation
    echo "Removing the installation script..."
    sudo rm -rf plinstaller2 || { echo "Failed to remove the installation script."; exit 1; }

    echo "Installation completed successfully."

    # Create systemd service file for Psiphon
    SERVICE_FILE="/etc/systemd/system/psiphon.service"

    echo "Creating systemd service file for Psiphon..."

    sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=Psiphon Service
After=network.target

[Service]
ExecStart=/usr/bin/psiphon
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF"

    # Reload and enable the service
    echo "Enabling and starting the Psiphon service..."
    sudo systemctl daemon-reload
    sudo systemctl enable psiphon.service
    sudo systemctl start psiphon.service

    echo "Psiphon service is now running."
}

# Uninstall Psiphon
uninstall() {
    echo "Stopping and disabling the Psiphon service..."
    sudo systemctl stop psiphon.service
    sudo systemctl disable psiphon.service

    echo "Removing the Psiphon service file..."
    sudo rm -f /etc/systemd/system/psiphon.service

    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload

    echo "Removing Psiphon binaries..."
    sudo rm -f /usr/bin/psiphon

    echo "Uninstallation completed successfully."
}

# Check for input argument
if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        usage
        ;;
esac
