#!/usr/bin/env bash
set -euo pipefail

# 1. Install Docker using official script (unattended)
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
fi

# 2. Create Home Assistant configuration directory
CONFIG_DIR="/opt/homeassistant/config"
mkdir -p "$CONFIG_DIR"

# 3. Create a docker-compose.yml file
cat <<EOF > /opt/homeassistant/docker-compose.yml
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - $CONFIG_DIR:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
EOF

# 4. Pull and launch Home Assistant unattended
cd /opt/homeassistant
docker compose up -d

echo "Home Assistant deployment complete."
