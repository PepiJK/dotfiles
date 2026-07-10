# Dotfiles

Cross-platform dotfiles for Arch Linux (bash) and Windows 11 (PowerShell 7).

## Setup

**Linux:** `bash setup.sh` (no arguments; requires only standard tools: `ln`, `mkdir`)
**Windows:** `.\setup.ps1 -UserName <username>` (run as Administrator; requires [Scoop](https://scoop.sh) with `$env:SCOOP` set)

Both scripts create symlinks (or junctions on Windows) from the target locations into this repo, so edits here are live immediately.

## Structure

| Folder | Config | Linked to |
|---|---|---|
| `bash/` | `.bashrc` | `~/.bashrc` |
| `ghostty/` | `config` | `~/.config/ghostty/config` |
| `lazygit/` | `config.yml` | `~/.config/lazygit/config.yml` (Linux) / `$XDG_CONFIG_HOME\lazygit\config.yml` (Windows) |
| `nvim/` | `init.lua` | `~/.config/nvim/init.lua` (Linux) / `$XDG_CONFIG_HOME\nvim\init.lua` (Windows) |
| `oh-my-posh/` | `*.omp.json` | `~/.config/oh-my-posh/` (Linux) / `$XDG_CONFIG_HOME\oh-my-posh\` (Windows) |
| `pi/` | `AGENTS.md` | `~/.pi/agent/AGENTS.md` |
| `powershell/` | `Microsoft.PowerShell_profile.ps1` | `~\Documents\PowerShell\` (Windows only) |
| `tmux/` | `.tmux.conf` | `~/.tmux.conf` |
| `vscode/` | `settings.json`, `keybindings.json` | `~/.config/Code/User/` (Linux) / `$SCOOP\persist\vscode\data\user-data\User\` (Windows, Scoop install) |
| `windows-terminal/` | `settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal*\LocalState\` (Windows only, MS Store) |
| `zed/` | `settings.json` | `~/.config/zed/settings.json` (Linux) / `$UserAppData\Zed\settings.json` (Windows) |

## Platform notes

- **tmux:** shared config, Windows-only settings guarded with `if-shell '[ "$OS" = "Windows_NT" ]'`. On Windows, psmux is used instead of native tmux.
- **oh-my-posh:** two themes — `star-ghostty.omp.json` for Ghostty (Linux), `star-win-term.omp.json` for Windows Terminal.
- **Windows setup** requires Scoop (`$env:SCOOP` must be set), `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME` to be set, and must run as Administrator to create symlinks.
- **PowerShell profile** and **Windows Terminal** are Windows-only; no Linux equivalents in this repo.
- **VS Code** is linked on both platforms, but to different paths: `~/.config/Code/User/` on Linux, `$SCOOP\persist\vscode\data\user-data\User\` on Windows (assumes Scoop-managed VS Code).
- **Zed** on Windows: `%APPDATA%\Zed` is already a directory junction to a Scoop persist folder (created by `EnsureScoopAppDataJunctions`, alongside `themes/` and `AGENTS.md` unrelated to this repo). Since NTFS junctions only work on directories, `zed/settings.json` is linked with a plain symlink through that existing junction — `setup.ps1` symlinks it after `EnsureScoopAppDataJunctions` runs so the junction exists first.

## Conventions

- Never add platform-specific logic directly into shared configs — use guards (`if-shell`, `$IsWindows`, etc.) or separate files.
- Keep setup scripts in sync: adding a new config means adding a `Link` call to both `setup.sh` and `setup.ps1`.
- All files use LF line endings, tabs for indentation (spaces for YAML), UTF-8, and a final newline — enforced via `.editorconfig` (present in the repo root).
- **`pi/`** contains the `AGENTS.md` file loaded as context by the [pi](https://github.com/mariozechner/pi) AI coding agent. It is linked into `~/.pi/agent/` so edits here take effect immediately.
