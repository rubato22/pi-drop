#!/bin/bash

# Matrix Green Colors
GREEN='\e[32m'
BOLD='\e[1;32m'
CYAN='\e[36m'
RED='\e[31m'
NC='\e[0m' # No Color

clear
echo -e "${BOLD}====================================================${NC}"
echo -e "${BOLD}   ⚡ PI-DROP // TAILSCALE AUTO-RECEIVE DAEMON      ${NC}"
echo -e "${BOLD}====================================================${NC}"
echo ""

# 1. Check if Tailscale is installed
if ! command -v tailscale &> /dev/null; then
    echo -e "${RED}[!] Tailscale is not installed! Please run install_tailscale.sh first.${NC}"
    exit 1
fi

# Determine the real user (in case they ran the script with sudo)
REAL_USER=${SUDO_USER:-$(whoami)}

echo -e "${GREEN}[*] Scanning attached storage devices...${NC}"
echo -e "${CYAN}"
# Show a clean list of drives (NVMe, SD, USB)
lsblk -o NAME,SIZE,MOUNTPOINT,MODEL -e 7
echo -e "${NC}"

# 2. Ask the user where to save the files
echo -e "${BOLD}Where should incoming Taildrop files be saved?${NC}"
echo -e "${GREEN}(Example: /home/${REAL_USER}/Downloads OR /mnt/nvme/photos)${NC}"
read -p "> " TAILDROP_DIR

# 3. Create the directory and fix permissions
echo -e "${GREEN}[*] Creating directory and setting permissions...${NC}"
sudo mkdir -p "$TAILDROP_DIR"
sudo chown -R $REAL_USER:$REAL_USER "$TAILDROP_DIR"

# 4. Create the Systemd Daemon
echo -e "${GREEN}[*] Writing systemd background service...${NC}"
SERVICE_FILE="/etc/systemd/system/taildrop-automator.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Taildrop Auto-Receive Service
After=network.target tailscaled.service
Requires=tailscaled.service

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c "while true; do /usr/bin/tailscale file get \"$TAILDROP_DIR\"; chown -R $REAL_USER:$REAL_USER \"$TAILDROP_DIR\"; chmod -R 755 \"$TAILDROP_DIR\"; sleep 5; done"
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

# 5. Enable and start the Daemon
echo -e "${GREEN}[*] Activating Pi-Drop Daemon...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable taildrop-automator
sudo systemctl restart taildrop-automator

echo ""
echo -e "${BOLD}====================================================${NC}"
echo -e "${BOLD}  SUCCESS! PI-DROP IS NOW ACTIVE.                   ${NC}"
echo -e "${BOLD}====================================================${NC}"
echo -e "${GREEN}Any files sent to this Pi via Taildrop will instantly${NC}"
echo -e "${GREEN}appear in: ${CYAN}$TAILDROP_DIR${NC}"
echo ""
