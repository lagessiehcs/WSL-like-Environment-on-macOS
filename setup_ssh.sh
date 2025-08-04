#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

echo "Add the public key to the list of authorized keys..."
cat ~/.ssh/*.pub > ~/.ssh/authorized_keys

echo "Creating ~/.Xauthority if it doesn't exist..."
touch ~/.Xauthority

echo "Installing openssh-server..."
sudo apt update
sudo apt install -y openssh-server

echo "Creating ssh.socket.d directory for custom port configuration..."
sudo mkdir -p /etc/systemd/system/ssh.socket.d/

echo "Writing custom port (2222) to ssh socket configuration..."
echo "[Socket]
ListenStream=2222" | sudo tee /etc/systemd/system/ssh.socket.d/listen.conf

echo "Reloading systemd daemon to apply new socket configuration..."
sudo systemctl daemon-reload

echo "Restarting ssh socket to apply changes..."
sudo systemctl restart ssh.socket

echo "Enabling ssh.socket to start on boot..."
sudo systemctl enable ssh.socket

echo "Setup complete. SSH should now listen on port 2222."
