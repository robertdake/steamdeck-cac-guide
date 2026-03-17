#!/bin/bash

echo "========================================"
echo " Steam Deck CAC Auto Installer v2"
echo "========================================"
echo ""

# -----------------------------
# Detect SteamOS
# -----------------------------
if grep -qi steamos /etc/os-release; then
    echo "SteamOS detected."
else
    echo "WARNING: This script is optimized for SteamOS."
fi

echo ""

# -----------------------------
# Detect Flatpak Firefox
# -----------------------------
if flatpak list | grep -q org.mozilla.firefox; then
    echo "WARNING: Flatpak Firefox detected."
    echo ""
    echo "Flatpak Firefox cannot access CAC readers properly."
    echo "Install native Firefox instead:"
    echo ""
    echo "sudo pacman -S firefox"
    echo ""
fi

echo ""

# -----------------------------
# Disable SteamOS read-only
# -----------------------------
echo "Disabling SteamOS read-only filesystem..."
sudo steamos-readonly disable

echo ""

# -----------------------------
# Update Keyring
# -----------------------------
echo "Updating pacman keyring..."
sudo pacman-key --init
sudo pacman-key --populate archlinux

echo ""

# -----------------------------
# Install CAC packages
# -----------------------------
echo "Installing CAC middleware..."
sudo pacman -Sy --noconfirm pcsclite ccid opensc pcsc-tools firefox nss

echo ""

# -----------------------------
# Enable Smart Card Service
# -----------------------------
echo "Enabling smart card service..."
sudo systemctl enable pcscd

echo "Starting smart card service..."
sudo systemctl start pcscd

echo ""

# -----------------------------
# Install DoD Certificates
# -----------------------------
echo "Installing DoD Root Certificates..."

CERT_DIR="$HOME/dod-certs"

mkdir -p $CERT_DIR
cd $CERT_DIR

curl -O https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_DoD.zip

unzip -o unclass-certificates_pkcs7_DoD.zip

echo ""

# Import certificates into NSS database
echo "Importing DoD certificates into Firefox NSS database..."

mkdir -p ~/.pki/nssdb

certutil -N --empty-password -d sql:$HOME/.pki/nssdb 2>/dev/null

for cert in $(find . -name "*.cer"); do
    certutil -A -d sql:$HOME/.pki/nssdb -n "$(basename $cert)" -t "TC,C,C" -i $cert
done

echo "DoD certificates installed."

echo ""

# -----------------------------
# Configure Firefox PKCS11
# -----------------------------
echo "Configuring Firefox OpenSC module..."

PKCS11_PATH="/usr/lib/opensc-pkcs11.so"

modutil -dbdir sql:$HOME/.pki/nssdb -add "OpenSC" -libfile $PKCS11_PATH 2>/dev/null

echo "OpenSC module installed."

echo ""

# -----------------------------
# Reader Test
# -----------------------------
echo "Testing CAC reader..."

if command -v pcsc_scan >/dev/null; then
    echo "Insert your CAC card now."
    echo "Press CTRL+C after reader detection."
    pcsc_scan
else
    echo "pcsc_scan not installed."
fi

echo ""

echo "========================================"
echo " Installation Complete"
echo "========================================"

echo ""
echo "Next Steps:"
echo ""
echo "1. Insert CAC"
echo "2. Launch Firefox:"
echo ""
echo "firefox"
echo ""
echo "3. Visit:"
echo ""
echo "https://dod411.gds.disa.mil"
echo ""
echo "Your certificate selection prompt should appear."
echo ""
