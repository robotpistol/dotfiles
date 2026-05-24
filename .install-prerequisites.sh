#!/bin/bash
set -e

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # Xcode CLI tools (required for Homebrew)
  if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode CLI tools..."
    xcode-select --install
    read -rp "Press enter after Xcode CLI tools finish installing..."
  fi

  # Homebrew
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # 1Password (check for op CLI as the signal it's ready)
  if ! command -v op &>/dev/null; then
    echo "Installing 1Password..."
    brew install --cask 1password 1password-cli
    echo ""
    echo "Open 1Password, sign in, and enable the SSH agent:"
    echo "  Settings → Developer → Use the SSH Agent"
    open -a "1Password"
    read -rp "Press enter when done..."
  fi
else
  echo "Unsupported OS: $OS — install prerequisites manually and re-run chezmoi init."
  exit 1
fi
