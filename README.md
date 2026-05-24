# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Fresh Mac Setup

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply https://github.com/USERNAME/dotfiles.git
```

This will:

1. Install all packages and apps via Homebrew
2. Set file associations (code files → VS Code, video → VLC) via duti
3. Apply shell, git, Hammerspoon, and Karabiner configs

## How It Works

chezmoi manages dotfiles from a source directory (`~/.local/share/chezmoi/`) and applies them to the home directory. Files are copied, not symlinked.

### Managed Configs

| Config | Source |
|---|---|
| zsh | `dot_zshrc` |
| git | `dot_gitconfig` |
| Hammerspoon | `dot_hammerspoon/` |
| Karabiner | `dot_config/karabiner/` |
| Brewfile | `dot_Brewfile` |

### Run Scripts

Scripts run in alphabetical order after attribute prefixes are stripped.

| Script | Type | Purpose |
|---|---|---|
| `run_onchange_01-brew-bundle.sh.tmpl` | on change | Installs Homebrew packages and casks |
| `run_02-configure-duti.sh.tmpl` | every apply | Sets file type associations |

## Day-to-Day Usage

```bash
# Edit a managed file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Add a new file to chezmoi
chezmoi add ~/.config/some/config

# Pull latest from remote and apply
chezmoi update
```

### Managing Brew Packages

```bash
# Installed something new? Capture it
brew bundle dump --file=~/.Brewfile --force
chezmoi re-add ~/.Brewfile

# Find packages installed but not in Brewfile
brew bundle cleanup --file=~/.Brewfile

# Add something deliberately
chezmoi edit ~/.Brewfile
chezmoi apply
```

### Editing Dotfiles Directly

If you edit a file directly (e.g. `~/.zshrc` instead of going through chezmoi), sync it back:

```bash
chezmoi re-add ~/.zshrc
```
