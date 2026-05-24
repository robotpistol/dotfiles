#!/bin/bash
set -e

# Xcode CLI tools
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  read -p "Press enter after Xcode CLI tools finish installing..."
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 1Password
brew install --cask 1password
echo ""
echo "Open 1Password, sign in, and enable SSH agent:"
echo "  Settings → Developer → Use the SSH Agent"
open -a "1Password"
read -p "Press enter when done..."

# Everything else
brew install chezmoi
chezmoi init --apply USERNAME
