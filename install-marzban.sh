#!/bin/bash
set -e

echo "Updating system..."
apt-get update -qq > /dev/null 2>&1
apt-get upgrade -y -qq > /dev/null 2>&1
apt-get install -y -qq curl socat git > /dev/null 2>&1

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sh > /dev/null 2>&1

echo "Preparing Marzban Node..."

cd ~

if [ ! -d "Marzban-node" ]; then
  git clone https://github.com/Gozargah/Marzban-node > /dev/null 2>&1
fi

mkdir -p /var/lib/marzban-node
cd ~/Marzban-node

cat > docker-compose.yml <<EOF
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOF

touch /var/lib/marzban-node/ssl_client_cert.pem

echo "Paste your certificate, then save and exit."
nano /var/lib/marzban-node/ssl_client_cert.pem

echo "Starting Marzban Node..."
docker compose up -d > /dev/null 2>&1

echo "Done ✅ Marzban Node is running."
