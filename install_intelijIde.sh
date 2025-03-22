#!/bin/bash

# Define variables
INSTALL_DIR="/opt/ideaIC"  # Where IntelliJ IDEA will be installed
TEMP_DIR="/tmp/ideaIC_install"  # Temporary directory for extraction
LAUNCHER_PATH="/usr/local/bin/idea"  # The path for the launcher script
DESKTOP_FILE="$HOME/Desktop/IntelliJ_IDEA.desktop"  # Path to the desktop shortcut

# Step 0: Check if IntelliJ IDEA is already installed and ask to uninstall if present
if [ -d "$INSTALL_DIR" ]; then
    echo "IntelliJ IDEA is already installed at $INSTALL_DIR."
    read -p "Do you want to uninstall the old version before proceeding? (y/n): " uninstall_old
    if [[ "$uninstall_old" == "y" || "$uninstall_old" == "Y" ]]; then
        echo "Uninstalling old IntelliJ IDEA version..."
        sudo rm -rf "$INSTALL_DIR"
        echo "Old IntelliJ IDEA version uninstalled."
    else
        echo "Proceeding with the installation without uninstalling the old version."
    fi
else
    echo "No old IntelliJ IDEA installation found. Proceeding with the installation."
fi

# Step 1: Ask for the file path for the new IntelliJ IDEA tar file
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
echo "Moving IntelliJ IDEA files to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo mv "$TEMP_DIR"/* "$INSTALL_DIR/"

# Step 6: Create a launcher script
echo "Creating a launcher script in $LAUNCHER_PATH..."
sudo bash -c "echo '#!/bin/bash' > $LAUNCHER_PATH"
sudo bash -c "echo '$INSTALL_DIR/idea-IC-*/bin/idea.sh' >> $LAUNCHER_PATH"
sudo chmod +x $LAUNCHER_PATH

# Step 7: Create a desktop shortcut
echo "Creating desktop shortcut at $DESKTOP_FILE..."
cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Name=IntelliJ IDEA
Comment=IntelliJ IDEA IDE
Exec=$INSTALL_DIR/idea-IC-*/bin/idea.sh
Icon=$INSTALL_DIR/idea-IC-*/bin/idea.png
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
    echo "You can launch IntelliJ IDEA by typing 'idea' in the terminal or using the desktop shortcut."
else
    echo "Installation failed."
    exit 1
fi
