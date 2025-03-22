#!/bin/bash

# Configuration
MYSQL_USER="USERNAME"
MYSQL_PASSWORD="PASSSWORD"
MYSQL_HOST="HOST"
MYSQL_PORT="PORT"  # default MySQL port
BACKUP_DIR="DIR_TO_BACKUP"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql"
CERT_DIR="$home/CERTIFICATE_DIR"

# Create backup for certs directory
mkdir -p $CERT_DIR

# SSL Certificates (update with actual paths if needed)
SSL_CA_CERT=$CERT_DIR"/ca.pem"
SSL_CLIENT_CERT="/path/to/client-cert.pem"
SSL_CLIENT_KEY="/path/to/client-key.pem"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Perform the backup without SSL
mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --ssl-mode=DISABLED notes_db > $BACKUP_FILE 2> $BACKUP_DIR/backup_error.log


# Perform the backup
#echo "Starting backup of all databases..."
#mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --all-databases \
#   --ssl-ca=$SSL_CA_CERT > $BACKUP_FILE 2> $BACKUP_DIR/backup_error.log

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed. Check $BACKUP_DIR/backup_error.log for details."
fi
