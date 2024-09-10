#!/bin/bash

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y curl

# Install Redis
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install -y redis

# Configure Redis to listen on all interfaces
#sudo sed -i 's/bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf

# Disable protected mode since we're not using a password
#sudo sed -i 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf

# Restart Redis service
sudo systemctl restart redis-server
sudo systemctl enable redis-server

# Print summary
echo "Redis installation complete!"
echo "Summary:"
echo "Redis is installed without password protection and is accessible from any IP."
echo ""
echo "Credits:"
echo "This script was created by Thomi Jasir"
echo "Redis version: $(redis-server --version | cut -d ' ' -f 3)"
echo "Date of installation: $(date)"

# Test Redis connection
if redis-cli ping | grep -q 'PONG'; then
    echo "Redis is working correctly."
else
    echo "There might be an issue with the Redis installation. Please check the logs."
fi