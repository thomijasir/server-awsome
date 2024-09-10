#!/bin/bash

# Function to generate a random string
generate_random_string() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

# Default values
DEFAULT_USERNAME=$(generate_random_string)
DEFAULT_PASSWORD=$(generate_random_string)

# Prompt for username and password
read -p "Enter MongoDB username (default: $DEFAULT_USERNAME): " MONGO_USERNAME
MONGO_USERNAME=${MONGO_USERNAME:-$DEFAULT_USERNAME}

read -p "Enter MongoDB password (default: $DEFAULT_PASSWORD): " MONGO_PASSWORD
MONGO_PASSWORD=${MONGO_PASSWORD:-$DEFAULT_PASSWORD}

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y gnupg curl wget

# Add MongoDB GPG key
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# Add MongoDB repository
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package list and install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Create admin user
mongosh admin --eval "db.createUser({user: '$MONGO_USERNAME', pwd: '$MONGO_PASSWORD', roles: ['root']})"

# Enable authentication
sudo sed -i 's/#security:/security:\n  authorization: enabled/' /etc/mongod.conf

# Restart MongoDB service
sudo systemctl restart mongod

# Print summary
echo "MongoDB installation complete!"
echo "Summary:"
echo "Username: $MONGO_USERNAME"
echo "Password: $MONGO_PASSWORD"
echo ""
echo "Credits:"
echo "This script was created by a professional shell programmer."
echo "MongoDB version: $(mongod --version | grep 'db version' | cut -d ' ' -f 3)"
echo "Date of installation: $(date)"