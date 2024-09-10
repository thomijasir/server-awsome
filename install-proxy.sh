#!/bin/bash

# Function to check if a port is in use
is_port_in_use() {
    netstat -tuln | grep -q ":$1 "
}

# Function to check if danted is running
is_danted_running() {
    systemctl is-active --quiet danted
}

# Ask for username and password
read -p "Enter username for proxy (default: admin): " username
username=${username:-admin}

read -s -p "Enter password for proxy (default: admin): " password
echo
password=${password:-admin}

# Ask for port and check if it's in use
while true; do
    read -p "Enter port for proxy (default: 1080): " port
    port=${port:-1080}
    if is_port_in_use $port; then
        echo "Port $port is already in use. Please choose another port."
    else
        break
    fi
done

# Start installation
echo "Starting installation..."

# Update system
echo "Updating system..."
sudo apt update &>/dev/null && sudo apt upgrade -y &>/dev/null

# Install Dante server
echo "Installing proxy server..."
sudo apt install dante-server -y &>/dev/null

# Configure Dante
echo "Configuring proxy..."
# Backup original configuration
sudo mv /etc/dante.conf /etc/dante.conf.bak
# Create new configuration file
sudo tee /etc/dante.conf > /dev/null <<EOT
logoutput: /var/log/socks.log
internal: eth0 port = $port
external: eth0
clientmethod: none
socksmethod: username
user.privileged: root
user.notprivileged: nobody

client pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: error connect disconnect
}
client block {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: connect error
}
socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        command: bind connect udpassociate
        log: error connect disconnect
        socksmethod: username
}
socks block {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: connect error
}
EOT

# Create user for proxy access
echo "Creating user for proxy access..."
sudo useradd -r -s /bin/false $username &>/dev/null
echo "$username:$password" | sudo chpasswd &>/dev/null

# Restart and enable Dante service
echo "Configuring Dante service..."
sudo systemctl restart danted &>/dev/null
sudo systemctl enable danted &>/dev/null

# Configure firewall
echo "Configuring firewall..."
sudo ufw allow $port/tcp &>/dev/null
sudo ufw reload &>/dev/null

# Check if danted is running and display appropriate message
if is_danted_running; then
    echo
    echo "====================================="
    echo "SOCKS5 Proxy Setup Complete!"
    echo "Created by Thomi Jasir"
    echo "====================================="
    echo
    echo "Proxy Details:"
    echo "Username: $username"
    echo "Password: $password"
    echo "Port: $port"
    echo "IP Address: $(curl -s ifconfig.me)"
    echo
    echo "How to support?"
    echo "Please share this script and add star on GitHub."
    echo
else
    echo
    echo "====================================="
    echo "Error: SOCKS5 Proxy Setup Failed"
    echo "====================================="
    echo
    echo "The Dante server (danted) is not running."
    echo "Please check the logs at /var/log/socks.log for more information."
    echo "You can also try restarting the service manually with:"
    echo "sudo systemctl restart danted"
    echo
fi