#!/bin/bash

# Automated Tool Installer for ReconIn1Command
# Author: Your Name
# GitHub: Your GitHub Profile

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Update the system
apt update && apt upgrade -y

# Install prerequisites
apt install -y git curl wget python3 python3-pip golang

# Ensure Go binaries are in the PATH
echo "export PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bashrc
source ~/.bashrc

# Function to install a tool and verify its installation
install_tool() {
  local tool_name=$1
  local install_command=$2
  local verify_command=$3

  echo "[*] Installing $tool_name..."
  eval "$install_command"

  if eval "$verify_command" &>/dev/null; then
    echo "[+] $tool_name installed successfully!"
  else
    echo "[-] Failed to install $tool_name. Please check manually."
  fi
}

# Tools and their installation commands
install_tool "Subfinder" "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" "subfinder -h"
install_tool "Assetfinder" "go install github.com/tomnomnom/assetfinder@latest" "assetfinder -h"
install_tool "Amass" "apt install -y amass" "amass -h"
install_tool "HTTPX" "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest" "httpx -h"
install_tool "Nmap" "apt install -y nmap" "nmap --version"
install_tool "Nuclei" "go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && nuclei -update-templates" "nuclei -h"
install_tool "WhatWeb" "apt install -y whatweb" "whatweb --version"
install_tool "Waybackurls" "go install github.com/tomnomnom/waybackurls@latest" "waybackurls -h"
install_tool "Gau" "go install github.com/lc/gau/v2/cmd/gau@latest" "gau -h"

# Install SecretFinder
echo "[*] Installing SecretFinder..."
git clone https://github.com/m4ll0k/SecretFinder.git /opt/SecretFinder
pip3 install -r /opt/SecretFinder/requirements.txt
if [ -f /opt/SecretFinder/SecretFinder.py ]; then
  echo "[+] SecretFinder installed successfully!"
else
  echo "[-] Failed to install SecretFinder. Please check manually."
fi

# Final message
echo "\nAll tools have been installed! Ensure Go binaries are in your PATH."
echo "If you encounter any issues, check the logs or install tools manually."
