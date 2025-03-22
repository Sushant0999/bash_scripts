#!/bin/bash

# Define variables
INSTALL_DIR="/opt/Postman"  # Where Postman will be installed
TEMP_DIR="/tmp/Postman_install"  # Temporary directory for extraction
LAUNCHER_PATH="/usr/local/bin/postman"  # The path for the launcher script
DESKTOP_FILE="$HOME/Desktop/Postman.desktop"  # Path to the desktop shortcut

# Step 0: Ask the user if they want to uninstall an old version of Postman if it exists

# Check if Postman is already installed
if [ -d "$INSTALL_DIR" ]; then
    echo "Postman is already installed at $INSTALL_DIR."
    read -p "Do you want to uninstall the old version before proceeding? (y/n): " uninstall_old
    if [[ "$uninstall_old" == "y" || "$uninstall_old" == "Y" ]]; then
        echo "Uninstalling old Postman..."
        sudo rm -rf "$INSTALL_DIR"
        echo "Old Postman version uninstalled."
    else
        echo "Proceeding with the installation without uninstalling the old version."
    fi
else
    echo "No old Postman installation found. Proceeding with the installation."
fi

# Step 1: Ask for the file path for the new Postman tar file
echo "Enter File Path With File Name"
read file_path
echo "Provided Path [$file_path]"

TAR_FILE="$file_path"  # The file path to the tar file

# Step 2: Check if the tar file exists
if [ ! -f "$TAR_FILE" ]; then
    echo "Error: $TAR_FILE not found!"
    exit 1
fi

# Step 3: Create temporary directory for extraction
echo "Creating temporary directory for extraction..."
mkdir -p "$TEMP_DIR"

# Step 4: Extract the .tar.gz file
echo "Extracting $TAR_FILE..."
tar -xvzf "$TAR_FILE" -C "$TEMP_DIR"

# Step 5: Move extracted files to the installation directory
echo "Moving Postman files to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo mv "$TEMP_DIR/Postman"/* "$INSTALL_DIR/"

# Step 6: Create a launcher script
echo "Creating a launcher script in $LAUNCHER_PATH..."
sudo bash -c "echo '#!/bin/bash' > $LAUNCHER_PATH"
sudo bash -c "echo '$INSTALL_DIR/Postman/Postman' >> $LAUNCHER_PATH"
sudo chmod +x $LAUNCHER_PATH

# Step 7: Create a desktop shortcut
echo "Creating desktop shortcut at $DESKTOP_FILE..."
cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Name=Postman
Comment=Postman API Client
Exec=$INSTALL_DIR/Postman/Postman
Icon=$INSTALL_DIR/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;IDE;
EOF

# Make the desktop shortcut executable
chmod +x "$DESKTOP_FILE"

# Step 8: Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Step 9: Verify installation
if [ -d "$INSTALL_DIR" ]; then
    echo "Installation completed successfully!"
    echo "You can launch Postman by typing 'postman' in the terminal or using the desktop shortcut."
else
    echo "Installation failed."
    exit 1
fi
