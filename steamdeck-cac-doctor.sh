#!/bin/bash

echo "============================="
echo " SteamDeck CAC Doctor"
echo "============================="
echo ""

# OS CHECK
echo "Checking OS..."
if grep -qi steamos /etc/os-release; then
    echo "✔ SteamOS detected"
else
    echo "⚠ Non-SteamOS Linux system"
fi

echo ""

# PCSC SERVICE
echo "Checking smart card service..."
if systemctl is-active --quiet pcscd; then
    echo "✔ pcscd running"
else
    echo "✖ pcscd NOT running"
    echo "Fix: sudo systemctl start pcscd"
fi

echo ""

# READER CHECK
echo "Checking CAC reader..."

if pcsc_scan -n 2>/dev/null | grep -q "Reader"; then
    echo "✔ CAC reader detected"
else
    echo "✖ No reader detected"
fi

echo ""

# CAC TOKEN CHECK
echo "Checking CAC token..."

if pkcs11-tool --module /usr/lib/pkcs11/opensc-pkcs11.so -L 2>/dev/null | grep -q "token label"; then
    echo "✔ CAC card detected"
else
    echo "✖ CAC not detected"
    echo "Insert card into reader"
fi

echo ""

# OPENSC CHECK
echo "Checking OpenSC..."

if command -v pkcs11-tool >/dev/null; then
    echo "✔ OpenSC installed"
else
    echo "✖ OpenSC not installed"
fi

echo ""

# FIREFOX CHECK
echo "Checking Firefox..."

if command -v firefox >/dev/null; then
    echo "✔ Native Firefox installed"
else
    echo "✖ Native Firefox missing"
fi

echo ""

# FLATPAK CHECK
echo "Checking for Flatpak Firefox..."

if flatpak list | grep -q org.mozilla.firefox; then
    echo "⚠ Flatpak Firefox detected"
    echo "Flatpak cannot access CAC readers properly."
fi

echo ""

# CERT CHECK
echo "Checking DoD certificates..."

if [ -d "$HOME/dod-certs" ]; then
    echo "✔ DoD certificates directory found"
else
    echo "⚠ DoD certificates not installed"
fi

echo ""

echo "============================="
echo " CAC Diagnostic Complete"
echo "============================="
