#!/bin/bash

echo "Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing GitHub CLI..."
sudo apt-get install -y gh

echo "Enter your GitHub username:"
read username

echo "Enter your GitHub password (it will be hidden):"
read -s password

echo "Authenticating with GitHub..."
gh auth login --with-token <<EOF
$username:$password
EOF

if gh auth status; then
  echo "Successfully authenticated with GitHub!"
else
  echo "Authentication failed. Please check your credentials."
  exit 1
fi