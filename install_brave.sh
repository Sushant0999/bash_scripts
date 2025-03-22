#!/bin/bash

# Update the package list and install curl if not already installed
echo "Installing curl..."
sudo apt update
sudo apt install -y curl

# Download and add the Brave GPG key
echo "Adding Brave GPG key..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Add Brave repository to APT sources list
echo "Adding Brave repository..."
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Update package list again after adding Brave repository
echo "Updating package list..."
sudo apt update

# Install Brave browser
echo "Installing Brave browser..."
sudo apt install -y brave-browser

# Confirm installation
echo "Brave browser has been installed successfully."
