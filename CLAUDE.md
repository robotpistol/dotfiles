# chezmoi dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). macOS-only.

## Key architecture

- **Machine types**: `personal` or `work`, set at `chezmoi init` time, stored in `~/.config/chezmoi/chezmoi.toml`. Templates use `{{ .machine_type }}` to branch.
- **Packages**: all Homebrew, cask, and MAS packages are declared in `.chezmoidata/packages.yaml`. The install script reads them via chezmoi templates and runs `brew bundle` inline — there is no `~/.Brewfile`.
- **Secrets/SSH**: no keys on disk. Everything goes through the 1Password SSH agent. The socket path is hardcoded in `private_dot_ssh/config`.

## Bootstrap flow

1. `.install-prerequisites.sh` runs as a `read-source-state` pre-hook — installs Xcode CLI, Homebrew, and 1Password before chezmoi reads source state.
2. Run scripts execute in filename order after attribute prefixes are stripped:
   - `run_onchange_00-xcode-cli.sh.tmpl` — ensures Xcode CLI tools are present
   - `run_onchange_01-install-packages.sh.tmpl` — installs all packages from `packages.yaml`
   - `run_02-configure-duti.sh.tmpl` — sets file type associations (runs every apply)
   - `run_onchange_03-krew.sh.tmpl` — installs kubectl krew plugins

## Common tasks

```bash
# Apply changes locally
chezmoi apply

# Edit a managed file
chezmoi edit ~/.zshrc

# Add a new package
# Edit .chezmoidata/packages.yaml, then:
chezmoi apply

# Add a new dotfile
chezmoi add ~/.config/some/config

# Preview what would change
chezmoi diff
```

## Templating conventions

- Use `{{ if eq .machine_type "work" }}` / `{{ if eq .machine_type "personal" }}` for machine-specific blocks.
- Use `{{ .chezmoi.os }}` guards (already present in run scripts) since everything assumes Darwin.
- `.chezmoidata/packages.yaml` supports top-level `brews`, `casks`, `mas` lists plus `work.mas` and `personal.mas` for machine-specific MAS apps.
