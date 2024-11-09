#!/bin/bash

# Directory where the certificates will be stored
CERT_DIR="/opt/tomcat/ssl"

# CA files
CA_CERT="$CERT_DIR/ca-cert.pem"
CA_KEY="$CERT_DIR/ca-key.pem"
TOMCAT_KEY="$CERT_DIR/tomcat.key"
TOMCAT_CSR="$CERT_DIR/tomcat.csr"
TOMCAT_CERT="$CERT_DIR/tomcat.crt"
TOMCAT_P12="$CERT_DIR/tomcat.p12"
PASSWORD="changeit"

# Create directories for storing certificates if they do not exist
mkdir -p $CERT_DIR  # Create the directory for certificates

# 1. Generate the private key for the CA (RSA)
echo "Generating the private key for the CA..."
openssl genpkey -algorithm RSA -out $CA_KEY -pass pass:$PASSWORD

# 2. Generate the public certificate for the CA
echo "Generating the public certificate for the CA..."
openssl req -x509 -new -key $CA_KEY -days 3650 -out $CA_CERT -subj "/CN=MyCustomCA" -passin pass:$PASSWORD

# 3. Generate the private key for Tomcat (RSA)
echo "Generating the private key for Tomcat..."
openssl genpkey -algorithm RSA -out $TOMCAT_KEY -pass pass:$PASSWORD

# 4. Generate the CSR (Certificate Signing Request) for Tomcat
echo "Generating the CSR for Tomcat..."
openssl req -new -key $TOMCAT_KEY -out $TOMCAT_CSR -passin pass:$PASSWORD -subj "/CN=localhost"

# 5. Sign the CSR with the CA's key to generate the signed Tomcat certificate
echo "Signing the CSR with the CA's key..."
openssl x509 -req -in $TOMCAT_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $TOMCAT_CERT -days 365 -passin pass:$PASSWORD

# 6. Create the PKCS12 Keystore for Tomcat with the signed certificate and private key
echo "Creating the PKCS12 Keystore..."
openssl pkcs12 -export -in $TOMCAT_CERT -inkey $TOMCAT_KEY -out $TOMCAT_P12 -name tomcat -password pass:$PASSWORD

# Clean up temporary files (CSR and intermediate certificates)
rm -f $TOMCAT_CSR

# Set permissions so that Tomcat can access the files
chmod 700 $CERT_DIR  # Restrict access to the certificate directory to the owner (Tomcat)
chmod 600 $TOMCAT_P12  # Restrict access to the keystore file (only readable by the owner)
chown -R tomcat:tomcat $CERT_DIR  # Ensure Tomcat owns the directory and files