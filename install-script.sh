
#!/bin/bash

echo "Steam Deck CAC Setup Script"

echo "Installing required packages..."
sudo pacman -S --noconfirm pcsclite ccid opensc firefox

echo "Enabling smart card service..."
sudo systemctl enable pcscd

echo "Starting smart card service..."
sudo systemctl start pcscd

echo ""
echo "Setup complete."
echo ""
echo "Next steps:"
echo "1. Insert CAC"
echo "2. Run pcsc_scan to verify reader"
echo "3. Configure Firefox with OpenSC module"
