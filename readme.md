# Server Installation Scripts

This repository contains three installation scripts for setting up various servers on a Debian-based system:

1. MongoDB Installer
2. Redis Installer
3. SOCKS5 Proxy Installer

## General Requirements

- A Debian-based system (e.g., Debian, Ubuntu)
- Root or sudo access
- Internet connection

## Tested Platforms

- Ubuntu 20.04 LTS
- Ubuntu 18.04 LTS

## 1. MongoDB Installer

This script installs and configures MongoDB on your system.

### Features

- Installs the latest version of MongoDB
- Prompts for MongoDB username and password (with random default values)
- Configures MongoDB with authentication enabled
- Displays installation summary and credentials

### Usage

```bash
chmod +x install_mongodb.sh
sudo ./install_mongodb.sh
```

### Notes

- The script installs MongoDB 7.0. Modify the script if you need a different version.
- Ensure you secure your MongoDB installation further by setting up proper firewall rules and following best practices.

## 2. Redis Installer

This script installs and configures Redis on your system without password protection.

### Features

- Installs the latest stable version of Redis
- Configures Redis to listen on all network interfaces
- Disables protected mode (no password required)
- Displays installation summary

### Usage

```bash
chmod +x install_redis.sh
sudo ./install_redis.sh
```

### Notes

- This configuration allows Redis to accept connections from any IP address without authentication. Use this only in trusted network environments or for development purposes.
- For production use, consider implementing additional security measures such as firewall rules or VPN access.

## 3. SOCKS5 Proxy Installer

This script installs and configures a SOCKS5 proxy server using Dante.

### Features

- Installs Dante server
- Prompts for proxy username, password, and port
- Configures the proxy server
- Sets up a firewall rule for the proxy port
- Checks if the proxy is running after installation
- Displays installation summary and credentials

### Usage

```bash
chmod +x install_socks5_proxy.sh
sudo ./install_socks5_proxy.sh
```

### Notes

- Running a proxy server can have security implications. Ensure you understand the risks and implement appropriate security measures.
- The script will display an error message if the Dante server fails to start after installation.

## Security Considerations

These scripts are provided for convenience and may not be suitable for all production environments without additional configuration. Always follow best practices for server security, including:

- Keeping your system updated
- Using strong, unique passwords
- Configuring firewalls properly
- Disabling root SSH access
- Using key-based SSH authentication
- Regularly monitoring your systems for unusual activity

## Disclaimer

These scripts are provided as-is, without warranty of any kind. Use them at your own risk. Always test in a safe environment before using in production.

## Supports

If you find these scripts helpful, please consider:

- Sharing them with others who might benefit
- Contributing to the improvement of the scripts
- Reporting any issues or suggesting enhancements

Buy me coffee if you like these scripts! ☕️

- [paypal.me/thomijasir](paypal.me/thomijasir)
