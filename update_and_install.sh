#!/bin/bash

#!/bin/bash

# Check if an update or upgrade is in progress
if pgrep -x apt &> /dev/null || pgrep -x dpkg &> /dev/null
then
    echo "An update or upgrade is in progress. Skipping further checks."
else
    # Check if the system is up to date
    if [[ $(sudo apt update 2>&1 | grep -c 'All packages are up to date') -gt 0 ]]
    then
        echo "The system is already up to date. Exiting without further updates."
    else
        # Perform system update and upgrade
        echo "Performing system update and upgrade..."
        sudo apt update
        sudo apt upgrade -y
        echo "System update and upgrade completed."
        # Perform autoremove

        echo "Performing autoremove..."

        sudo apt autoremove -y

        echo "Autoremove completed."
    fi
fi

# Install commonly useful packages
sudo apt install -y git curl wget htop net-tools

# Check for the latest updates and store the report
sudo apt list --upgradable > /usr/local/backups/updates_report.txt

# Check if Docker is already installed
if command -v docker &> /dev/null
then
    echo "Docker is already installed."
else
    # Install Docker
    echo "Installing Docker..."
    sudo apt update
    sudo apt install -y curl gnupg2 software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Check if Docker installation was successful
    if command -v docker &> /dev/null
    then
        echo "Docker has been successfully installed."
    else
        echo "Failed to install Docker."
    fi
fi
