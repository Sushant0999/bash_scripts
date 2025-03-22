#!/bin/bash

# Define variables
echo "Enter File Path With File Name"
read file_path
echo "Provided Path [$file_path]"

TAR_FILE="$file_path"  # Adjust to your download path
INSTALL_DIR="/opt/ideaIC"  # Where IntelliJ IDEA will be installed
TEMP_DIR="/tmp/ideaIC_install"  # Temporary directory for extraction
LAUNCHER_PATH="/usr/local/bin/idea"  # The path for the launcher script
DESKTOP_FILE="$HOME/Desktop/IntelliJ_IDEA.desktop"  # Path to the desktop shortcut

# Step 1: Check if the tar file exists
if [ ! -f "$TAR_FILE" ]; then
    echo "Error: $TAR_FILE not found!"
    exit 1
fi

# Step 2: Create temporary directory for extraction
echo "Creating temporary directory for extraction..."
mkdir -p "$TEMP_DIR"

# Step 3: Extract the .tar.gz file
echo "Extracting $TAR_FILE..."
tar -xvzf "$TAR_FILE" -C "$TEMP_DIR"

# Step 4: Move extracted files to the installation directory
echo "Moving IntelliJ IDEA files to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo mv "$TEMP_DIR"/* "$INSTALL_DIR/"

# Step 5: Create a launcher script
echo "Creating a launcher script in $LAUNCHER_PATH..."
sudo bash -c "echo '#!/bin/bash' > $LAUNCHER_PATH"
sudo bash -c "echo '$INSTALL_DIR/idea-IC-*/bin/idea.sh' >> $LAUNCHER_PATH"
sudo chmod +x $LAUNCHER_PATH

# Step 6: Create a desktop shortcut
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

# Step 7: Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Step 8: Verify installation
if [ -d "$INSTALL_DIR" ]; then
    echo "Installation completed successfully!"
    echo "You can launch IntelliJ IDEA by typing 'idea' in the terminal or using the desktop shortcut."
else
    echo "Installation failed."
    exit 1
fi

'
