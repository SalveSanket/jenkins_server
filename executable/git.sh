#!/bin/bash

echo "🔧 Installing Git..."

# Detect package manager and install Git accordingly
if command -v apt &> /dev/null; then
  echo "📦 Using APT (Debian/Ubuntu)"
  sudo apt update -y
  sudo apt install -y git
elif command -v yum &> /dev/null; then
  echo "📦 Using YUM (Amazon Linux/CentOS)"
  sudo yum update -y
  sudo yum install -y git
elif command -v dnf &> /dev/null; then
  echo "📦 Using DNF (Fedora/CentOS 8+)"
  sudo dnf update -y
  sudo dnf install -y git
else
  echo "❌ No supported package manager found. Please install Git manually."
  exit 1
fi

echo "✅ Git installation complete!"
git --version
