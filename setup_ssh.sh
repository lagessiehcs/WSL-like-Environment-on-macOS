#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

echo "Add the public key to the list of authorized keys..."
cat ~/.ssh/*.pub > ~/.ssh/authorized_keys
echo "Done"

echo "Creating ~/.Xauthority if it doesn't exist..."
touch ~/.Xauthority
echo "Done"

echo "Installing openssh-server..."
sudo apt update
sudo apt install -y openssh-server
echo "Done"

echo "Installing git..."
sudo apt install git -y
echo "Done"

echo "Creating ssh.socket.d directory for custom port configuration..."
sudo mkdir -p /etc/systemd/system/ssh.socket.d/
echo "Done"

echo "Writing custom port (2222) to ssh socket configuration..."
echo "[Socket]
ListenStream=2222" | sudo tee /etc/systemd/system/ssh.socket.d/listen.conf
echo "Done"

echo "Reloading systemd daemon to apply new socket configuration..."
sudo systemctl daemon-reload
echo "Done"

echo "Restarting ssh socket to apply changes..."
sudo systemctl restart ssh.socket
echo "Done"

echo "Enabling ssh.socket to start on boot..."
sudo systemctl enable ssh.socket
echo "Done"

echo "Intalling nano..."
sudo apt install nano -y
echo "Done"

read -p "Install Desktop? [Y/n]" choice
case "$choice" in
    [Yy] )
        echo "Continuing..."
        ;;
    [Nn] )
        echo "Exiting..."
        exit 1
        ;;
    * )
        echo "Continuing..."
        ;;
esac

echo "Installing xfce4 and tigervnc"
sudo apt install tigervnc-standalone-server xfce4 dbus-x11 -y
echo "Done"

echo "Intalling gedit..."
sudo apt install gedit -y
echo "Done"

echo "Add startup command to the xstartup file..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
# Start the XFCE desktop inside the VNC session
startxfce4
EOF
chmod +x ~/.vnc/xstartup
echo "Done"

echo "Add security type..."
echo SecurityTypes=TLSVnc > ~/.vnc/config
echo "Done"

echo "Setting password..."
echo "" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
echo "Done"

echo "Setup complete. SSH should now listen on port 2222."
