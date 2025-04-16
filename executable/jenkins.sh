#!/bin/bash

set -e

echo "🔧 Starting Jenkins installation..."

# Step 1: Detect OS and update system packages accordingly
if command -v yum &> /dev/null; then
  echo "📦 Using YUM (Amazon Linux/CentOS)"
  sudo yum update -y
elif command -v apt &> /dev/null; then
  echo "📦 Using APT (Ubuntu/Debian)"
  sudo apt update -y
  sudo apt upgrade -y
else
  echo "❌ Unsupported package manager. Exiting."
  exit 1
fi

# Step 2: Add Jenkins repository and import the key
if command -v yum &> /dev/null; then
  echo "📥 Adding Jenkins repository for YUM/DNF..."
  sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
elif command -v apt &> /dev/null; then
  echo "📥 Adding Jenkins repository for APT..."

  # Remove any old GPG key (optional cleanup)
  sudo apt-key del 5BA31D57EF5975CA 2>/dev/null || true

  # Download and store the 2023 Jenkins key securely
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

  # Configure the repository with the new signed key
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

  # Update after adding repo
  sudo apt update -y
fi

# Step 3: Install Java
if command -v yum &> /dev/null; then
  echo "☕ Installing Java 17 (Amazon Corretto)..."
  sudo yum install java-17-amazon-corretto -y
elif command -v apt &> /dev/null; then
  echo "☕ Installing OpenJDK 17..."
  sudo apt install -y openjdk-17-jdk
fi

# Step 4: Install Jenkins
if command -v yum &> /dev/null; then
  echo "📦 Installing Jenkins..."
  sudo yum install -y jenkins
elif command -v apt &> /dev/null; then
  echo "📦 Installing Jenkins..."
  sudo apt install -y jenkins
fi

# Step 5: Enable Jenkins to start at boot
echo "🚀 Enabling Jenkins service to start at boot..."
sudo systemctl enable jenkins

# Step 6: Start Jenkins service
echo "▶️ Starting Jenkins service..."
sudo systemctl start jenkins

# Step 7: Check Jenkins service status
echo "📊 Checking Jenkins service status..."
sudo systemctl status jenkins

echo "✅ Jenkins installation complete! Access it via your EC2 public IP on port 8080."
echo "🔗 URL: http://<your-ec2-public-ip>:8080"