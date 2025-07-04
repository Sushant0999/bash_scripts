#!/bin/bash

# Set variables for file paths and passwords
DOMAIN="missmartz.netsmartz.us"
CERT_PATH="/etc/letsencrypt/live/$DOMAIN"
SSL_CERT_PATH="/etc/ssl/certs"
P12_PASSWORD="Groot@222"
JKS_PASSWORD="Groot@222"
P12_NAME="netsmartz"
CERT_P12="$CERT_PATH/certificate.p12"
JKS_FILE="$CERT_PATH/newkeystore.jks"
FINAL_JKS_FILE="/opt/certficate/newcert.jks" 
#FINAL_JKS_FILE="$SSL_CERT_PATH/cert.jks"
LOG_FILE="/var/log/cert_script.log"


# Function to log errors
log_error() {
    echo "[ERROR] $(date) - $1" | tee -a "$LOG_FILE"
}

# Trap errors and log them
trap 'log_error "An error occurred on line $LINENO. Exiting..."; exit 1' ERR

# Enable exit on error
set -e


echo "STEP 1"

# Run Certbot to get a certificate (assuming Apache)
echo "Running Certbot to get certificates..."
{
    #sudo certbot --apache -d "$DOMAIN" --force-renewal
    sudo certbot --apache -d "$DOMAIN" --agree-tos --force-renewal --redirect

} || {
    log_error "Certbot failed to obtain certificates for $DOMAIN"
    exit 1
}

echo "STEP 2"

# Export the certificate to a PKCS#12 file (.p12)
echo "Exporting certificate to PKCS#12 format..."
{
    sudo openssl pkcs12 -export -in "$CERT_PATH/fullchain.pem" -inkey "$CERT_PATH/privkey.pem" -out "$CERT_P12" -name "$P12_NAME" -passout pass:$P12_PASSWORD

} || {
    log_error "Failed to export certificate to PKCS#12 format"
    exit 1
}

echo "STEP 3"

# Convert PKCS#12 to JKS (Java KeyStore)
echo "Converting PKCS#12 to Java KeyStore (.jks)..."
{
    sudo keytool -importkeystore -srckeystore "$CERT_P12" -srcstoretype PKCS12 -destkeystore "$JKS_FILE" -deststoretype JKS -srcstorepass "$P12_PASSWORD" -deststorepass "$JKS_PASSWORD" -noprompt

} || {
    log_error "Failed to convert PKCS#12 to Java KeyStore (.jks)"
    exit 1
}

echo "STEP 4"

# Export certificate and key to another PKCS#12 format in SSL cert path
echo "Exporting certificate to $SSL_CERT_PATH as PKCS#12..."
{
    sudo openssl pkcs12 -export -in "$CERT_PATH/fullchain.pem" -inkey "$CERT_PATH/privkey.pem" -out "$SSL_CERT_PATH/cert.p12" -name "$P12_NAME" -passout pass:$P12_PASSWORD
} || {
    log_error "Failed to export certificate to $SSL_CERT_PATH as PKCS#12"
    exit 1
}

echo "STEP 5"

# Convert the new PKCS#12 to JKS
echo "Converting $SSL_CERT_PATH/cert.p12 to Java KeyStore (.jks)..."
{
    sudo keytool -importkeystore -srckeystore "$SSL_CERT_PATH/cert.p12" -srcstoretype PKCS12 -destkeystore "$FINAL_JKS_FILE" -deststoretype JKS -srcstorepass "$P12_PASSWORD" -deststorepass "$JKS_PASSWORD" -noprompt
} || {
    log_error "Failed to convert $SSL_CERT_PATH/cert.p12 to Java KeyStore (.jks)"
    exit 1
}

echo "STEP 6"

# List the contents of the final Java KeyStore
echo "Listing contents of the final Java KeyStore..."
{
    sudo keytool -list -v -keystore "$FINAL_JKS_FILE" -storepass "$JKS_PASSWORD"
} || {
    log_error "Failed to list contents of the Java KeyStore"
    exit 1
}

echo "Process completed successfully."

