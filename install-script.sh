#!/bin/bash

echo "========================================"
echo " Steam Deck CAC Setup Installer"
echo "========================================"
echo ""

# Check if running on SteamOS
if ! grep -qi steamos /etc/os-release; then
    echo "WARNING: This script is designed for SteamOS."
    echo ""
fi

echo "Step 1: Disabling SteamOS read-only filesystem..."
sudo steamos-readonly disable

echo ""
echo "Step 2: Updating keyring..."
sudo pacman-key --init
sudo pacman-key --populate archlinux

echo ""
echo "Step 3: Installing CAC middleware packages..."
sudo pacman -Sy --noconfirm pcsclite ccid opensc pcsc-tools firefox

echo ""
echo "Step 4: Enabling smart card service..."
sudo systemctl enable pcscd

echo ""
echo "Step 5: Starting smart card service..."
sudo systemctl start pcscd

echo ""
echo "Step 6: Verifying CAC reader..."

if command -v pcsc_scan >/dev/null; then
    echo ""
    echo "Running reader scan (press Ctrl+C after reader is detected)..."
    pcsc_scan
else
    echo "pcsc_scan not found."
fi

echo ""
echo "========================================"
echo " Installation Complete"
echo "========================================"

echo ""
echo "Next Steps:"
echo "1. Insert your CAC card"
echo "2. Launch Firefox using:"
echo ""
echo "firefox"
echo ""
echo "3. Open about:config"
echo ""
echo "Enable these settings:"
echo "security.osclientcerts.autoload"
echo "security.enterprise_roots.enabled"
echo ""
echo "4. Visit a CAC site like:"
echo "https://dod411.gds.disa.mil"
echo ""

echo "Your CAC reader should now activate."
