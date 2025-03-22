#!/bin/bash

# Script to install Apache Tomcat 9 on Linux

# Define the Tomcat version
TOMCAT_DIR_VER="10"
TOMCAT_VERSION="${TOMCAT_DIR_VER}.1.39"
#https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.39/bin/apache-tomcat-10.1.39.tar.gz
TOMCAT_TAR="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-${TOMCAT_DIR_VER}/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR}"

# Step 1: Update package list
echo "Updating package list..."
sudo apt update -y

# Step 2: Install required dependencies (Java and wget)
echo "Installing Java and wget..."
sudo apt install -y openjdk-17-jdk wget

# Step 3: Verify Java installation
java -version

# Step 4: Create tomcat user (optional but recommended for security reasons)
echo "Creating tomcat user..."
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

# Step 5: Create the /opt/tomcat directory
echo "Creating /opt/tomcat directory..."
sudo mkdir -p /opt/tomcat

# Step 6: Download Apache Tomcat
echo "Downloading Apache Tomcat ${TOMCAT_VERSION}..."
cd /tmp
wget ${TOMCAT_URL}

# Step 7: Extract the Tomcat tarball
echo "Extracting Tomcat..."
sudo tar -xzvf ${TOMCAT_TAR} -C /opt/tomcat --strip-components=1

# Step 8: Set proper permissions
echo "Setting permissions..."
sudo chown -R tomcat:tomcat /opt/tomcat

# Step 9: Create a systemd service file for Tomcat
echo "Creating systemd service for Tomcat..."
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_TMPDIR=/opt/tomcat/temp"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Step 10: Reload systemd and start Tomcat
echo "Reloading systemd and starting Tomcat..."
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Step 11: Check Tomcat status
echo "Checking Tomcat status..."
sudo systemctl status tomcat

# Step 12: Open firewall port (if needed)
echo "Opening firewall port 8080..."
sudo ufw allow 8080/tcp

# Completion message
echo "Apache Tomcat 9 has been installed and started successfully. You can access it at http://<your-server-ip>:8080/"
