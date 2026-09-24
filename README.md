# Pepi's Dotfiles

Cross-platform dotfiles for Arch Linux and Windows 11.

## Setup

- **Linux:** Run `bash setup.sh`.
- **Windows:** Run `.\setup.ps1 -UserName <username>` in PowerShell 7 as Administrator. Scoop and these environment variables must be set:
    - `SCOOP`: Scoop's installation directory.
    - `XDG_CONFIG_HOME`: base directory for application configs.
    - `XDG_DATA_HOME`: base directory for application data.
    - `XDG_CACHE_HOME`: base directory for application caches.

The setup scripts link configurations from this repository, so changes here take effect immediately.
