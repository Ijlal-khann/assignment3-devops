#!/bin/bash

# ============================================
# Jenkins Installation Script for Amazon Linux 2023
# Run this script on your EC2 instance
# ============================================

echo "=========================================="
echo "Starting Jenkins Setup..."
echo "=========================================="

# Update system packages
echo "[1/7] Updating system packages..."
sudo yum update -y

# Install Java 17 (Jenkins requirement - changed from Java 11)
echo "[2/7] Installing Java 17..."
sudo yum install java-17-amazon-corretto -y

# Verify Java installation
echo "Java version:"
java -version

# Add Jenkins repository
echo "[3/7] Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
echo "[4/7] Installing Jenkins..."
sudo yum install jenkins -y

# Install Docker
echo "[5/7] Installing Docker..."
sudo yum install docker -y

# Install Python 3 and pip
echo "[6/7] Installing Python 3..."
sudo yum install python3 python3-pip -y

# Configure user permissions
echo "Configuring user permissions..."
sudo usermod -aG docker jenkins
sudo usermod -aG docker ec2-user

# Start and enable services
echo "[7/7] Starting services..."
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl start docker
sudo systemctl enable docker

# Wait for Jenkins to fully start
echo "Waiting 30 seconds for Jenkins to start..."
sleep 30

# Check service status
echo ""
echo "=========================================="
echo "Service Status:"
echo "=========================================="
sudo systemctl status jenkins --no-pager | head -3
sudo systemctl status docker --no-pager | head -3

# Get Jenkins initial password
echo ""
echo "=========================================="
echo "JENKINS INITIAL PASSWORD:"
echo "=========================================="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo "=========================================="

# Display completion message
echo ""
echo "✓ Installation Complete!"
echo ""
echo "Next Steps:"
echo "1. Copy the password above"
echo "2. Open browser: http://13.53.125.107:8080"
echo "3. Paste the password"
echo "4. Install suggested plugins"
echo "5. Create admin user"
echo ""
echo "=========================================="