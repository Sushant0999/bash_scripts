#!/bin/bash

#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Install MySQL server
echo "Installing MySQL server..."
sudo apt install -y mysql-server

# Ensure MySQL service is started
echo "Starting MySQL service..."
sudo systemctl start mysql

# Ensure MySQL service is enabled on boot
echo "Enabling MySQL service to start on boot..."
sudo systemctl enable mysql

# Check MySQL service status
echo "Checking MySQL service status..."
sudo systemctl status mysql

# Ask user if they want to set a custom user and password
read -p "Do you want to set a custom MySQL user and password? (y/n): " set_custom_user

if [[ "$set_custom_user" == "y" || "$set_custom_user" == "Y" ]]; then
    # Ask for custom username and password
    read -p "Enter MySQL username: " mysql_user
    read -sp "Enter MySQL password: " mysql_password
    echo

    # Run MySQL commands to create user and set password
    sudo mysql -e "CREATE USER '${mysql_user}'@'localhost' IDENTIFIED BY '${mysql_password}';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${mysql_user}'@'localhost' WITH GRANT OPTION;"
    sudo mysql -e "FLUSH PRIVILEGES;"

    echo "MySQL user '${mysql_user}' created with the password you provided."

else
    # Default to root user and password root
    mysql_user="root"
    mysql_password="root"

    # Set root password if needed
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${mysql_password}';"
    echo "MySQL root user password set to '${mysql_password}'."
fi

# Run MySQL secure installation (optional but recommended)
echo "Running MySQL secure installation..."
sudo mysql_secure_installation

echo "MySQL installation completed successfully!"


