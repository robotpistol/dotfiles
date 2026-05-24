# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Fresh Mac Setup

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" && chezmoi init --apply robotpistol
```

When prompted, enter `personal` or `work` for machine type. chezmoi will automatically install Xcode CLI tools, Homebrew, and 1Password before applying dotfiles. You'll be prompted to sign in to 1Password and enable the SSH agent during setup.

### Post-setup manual steps

- Grant Accessibility permissions for: Hammerspoon, Karabiner, Alfred, 1Password
- Enter Alfred license key (stored in 1Password)

## How It Works

chezmoi manages dotfiles from a source directory (`~/.local/share/chezmoi/`) and applies them to the home directory. Files are copied, not symlinked. Templates (`.tmpl` files) support conditionals for work vs personal machine differences.

### Managed Configs

| Config | Source |
|---|---|
| zsh | `dot_zshrc` |
| git | `dot_gitconfig` |
| SSH | `dot_ssh/` |
| Hammerspoon | `dot_hammerspoon/` |
| Karabiner | `dot_config/karabiner/` |
| Ghostty | `dot_config/ghostty/` |
| Starship | `dot_config/starship.toml` |
| Brewfile | `dot_Brewfile` |

### Run Scripts

Scripts run in alphabetical order after attribute prefixes are stripped.

| Script | Type | Purpose |
|---|---|---|
| `.install-prerequisites.sh` | init hook | Installs Xcode CLI, Homebrew, and 1Password before source state is read |
| `run_onchange_00-xcode-cli.sh.tmpl` | on change | Ensures Xcode CLI tools are present |
| `run_onchange_01-install-packages.sh.tmpl` | on change | Installs Homebrew packages, casks, and App Store apps |
| `run_02-configure-duti.sh.tmpl` | every apply | Sets file type associations |
| `run_onchange_03-krew.sh.tmpl` | on change | Installs kubectl krew plugins |

### SSH & Secrets

SSH keys are managed through the 1Password SSH agent. No private keys are stored on disk or in this repo. The SSH config points at the 1Password agent socket:

```
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

Keys sync via 1Password's cloud. The SSH agent toggle is per-device and must be enabled manually during setup.

### Work vs Personal

Machine type is set during `chezmoi init` and stored in `~/.config/chezmoi/chezmoi.toml`. Templates use `{{ .machine_type }}` to conditionally apply configs (git email, brew packages, etc.).

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
