#!/bin/bash
set -euo pipefail

echo "→ Applying macOS defaults..."

# ── Sound ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# ── Keyboard ───────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.mitchellh.ghostty ApplePressAndHoldEnabled -bool false
defaults write com.googlecode.iterm2 ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# ── Dock ───────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 62
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
killall Dock

# ── Finder ─────────────────────────────────────────────────────────────────
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
killall Finder

# ── UI ─────────────────────────────────────────────────────────────────────
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ── Crash Reporter ─────────────────────────────────────────────────────────
defaults write com.apple.CrashReporter DialogType -string "none"

echo "✓ Done. Some changes (keyboard, press-and-hold) require logout to take effect."
