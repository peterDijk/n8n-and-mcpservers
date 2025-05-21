#!/bin/bash

set -euo pipefail

# Check if homebrew install
if ! command -v brew &> /dev/null; then
  echo "'brew' is not available. Please install Homebrew."
  exit 1
fi

# Check if mkcert is installed, if not install it with brew
if ! command -v mkcert &> /dev/null; then
  echo "'mkcert' is not available. Installing with Homebrew..."
  brew install mkcert
fi

# Run mkcert -install to create the local CA
echo "Creating local CA with mkcert..."
echo "You will be prompted for your laptop password to create and install the certificate locally"

mkcert -install

# Generate the certificate for n8n.local
echo "Generating certificate for n8n.local..."
mkcert -key-file ./nginx_data/certs/n8n.local.key -cert-file ./nginx_data/certs/n8n.local.crt n8n.local

HOST_ENTRY="127.0.0.1 n8n.local"
HOSTS_FILE="/etc/hosts"
BACKUP_FILE="/etc/hosts.backup"

# Check if entry already exists
if grep -q "n8n.local" "$HOSTS_FILE"; then
  echo "'n8n.local' is already present in $HOSTS_FILE"
  echo "Please run 'docker compose up -d' to start the nginx container."
  exit 0
fi

echo "'n8n.local' not found in $HOSTS_FILE."

# Confirm with user before making changes
read -rp "Do you want to add '$HOST_ENTRY' to $HOSTS_FILE? (y/n) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted by user."
  exit 1
fi


echo "Requesting sudo to make changes to /etc/hosts..."
sudo -v || { echo "Failed to gain sudo access."; exit 1; }

echo "Backing up $HOSTS_FILE to $BACKUP_FILE..."
sudo cp "$HOSTS_FILE" "$BACKUP_FILE"

echo "Adding '$HOST_ENTRY' to $HOSTS_FILE..."
echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE" > /dev/null

# All finished
echo "Please run 'docker compose up -d' to start the nginx container."
