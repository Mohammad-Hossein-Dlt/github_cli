#!/bin/bash
# This script installs the GitHub CLI and then authenticates using the CLI.

set -e

# Check if the 'gh' command exists
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Installing..."
    
    # Check if the apt package manager exists (for Ubuntu/Debian)
    if command -v apt &> /dev/null; then
        # Add the GitHub CLI GPG key and repository
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        
        sudo apt update
        sudo apt install gh -y
    else
        echo "apt package manager not found. Please install GitHub CLI manually."
        exit 1
    fi
else
    echo "GitHub CLI is already installed."
fi

# Start the authentication process
echo "Starting GitHub CLI authentication..."
gh auth login
