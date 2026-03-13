#!/bin/bash

# Matrix Green Colors
GREEN='\e[32m'
BOLD='\e[1;32m'
NC='\e[0m' # No Color

clear
echo -e "${BOLD}====================================================${NC}"
echo -e "${BOLD}   ⚡ PI-DROP // TAILSCALE SECURE NODE DEPLOYMENT   ${NC}"
echo -e "${BOLD}====================================================${NC}"
echo ""
echo -e "${GREEN}[*] Initializing security protocols...${NC}"
sleep 1

# Check if Tailscale is already installed
if command -v tailscale &> /dev/null; then
    echo -e "${GREEN}[*] Tailscale is already installed on this node.${NC}"
else
    echo -e "${GREEN}[*] Downloading Tailscale packages...${NC}"
    curl -fsSL https://tailscale.com/install.sh | sh
    echo -e "${GREEN}[*] Installation complete.${NC}"
fi

echo -e "${GREEN}[*] Ensuring Tailscale service is active...${NC}"
sudo systemctl enable --now tailscaled

echo ""
echo -e "${BOLD}[!] ACTION REQUIRED:${NC}"
echo -e "${GREEN}Please authenticate this node with your Tailscale network:${NC}"
echo -e "${GREEN}Run the command below if it does not automatically prompt you:${NC}"
echo ""

# Bring Tailscale up
sudo tailscale up

echo ""
echo -e "${BOLD}====================================================${NC}"
echo -e "${BOLD}  NODE SECURED. TAILSCALE IP ASSIGNED.              ${NC}"
echo -e "${BOLD}====================================================${NC}"
