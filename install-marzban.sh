#!/bin/bash

echo "=== Update system ==="
apt-get update
apt-get upgrade -y
apt-get install curl socat git -y

echo "=== Install Docker ==="
curl -fsSL https://get.docker.com | sh

echo "=== Clone Marzban-node ==="
cd ~
git clone https://github.com/Gozargah/Marzban-node

echo "=== Create marzban directory ==="
mkdir -p /var/lib/marzban-node

echo "=== Go to Marzban-node directory ==="
cd ~/Marzban-node

echo "=== Replace docker-compose.yml ==="
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

echo "=== Prepare certificate file ==="
touch /var/lib/marzban-node/ssl_client_cert.pem

echo "=== Paste your certificate, then save and exit ==="
nano /var/lib/marzban-node/ssl_client_cert.pem

echo "=== Starting Marzban Node ==="
cd ~/Marzban-node
docker compose up -d

echo "=== Done ✅ Marzban Node is running ==="