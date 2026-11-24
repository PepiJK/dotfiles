---
title: Pepi's Dotfiles
description: Cross-platform dotfiles and setup instructions for Arch Linux and Windows 11.
---

# Pepi's Dotfiles

Cross-platform dotfiles for Arch Linux and Windows 11.

## Setup

- **Linux:** Run `bash setup.sh`.
- **Windows:** Run `.\setup.ps1 -UserName <username>` in PowerShell 7 as Administrator. The script validates that Scoop and these environment variables are set and point to existing paths:
    - `SCOOP`: Scoop's installation directory.
    - `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME`, `XDG_BIN_HOME`, `XDG_RUNTIME_DIR`: XDG base directories.
    - `NUGET_PACKAGES`, `GH_CONFIG_DIR`, `AZURE_CONFIG_DIR`, `COPILOT_HOME`: CLI and SDK config/data directories.
    - `NPM_CONFIG_CACHE`, `NPM_CONFIG_PREFIX`, `NPM_CONFIG_USERCONFIG`, `NPM_CONFIG_GLOBALCONFIG`: npm cache, global prefix, and config files.
    - `VSCODE_EXTENSIONS`, `VSCODE_AGENT_FOLDER`, `VSCODE_CLI_DATA_DIR`: VS Code extensions and remote/CLI data directories.
    - `TEMP`, `TMP`: temporary directories.

The setup scripts link configurations from this repository, so changes here take effect immediately.
