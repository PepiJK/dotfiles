---
title: Dotfiles
---

# Dotfiles

Cross-platform dotfiles for Arch Linux (bash) and Windows 11 (PowerShell 7).

## Setup

**Linux:** `bash setup.sh` (no arguments)
**Windows:** `.\setup.ps1 -UserName <username>` (run as Administrator)

Both scripts create symlinks (or junctions on Windows) from the target locations into this repo, so edits here are live immediately.
The setup scripts are the source of truth for link targets and platform-specific setup behavior.

## Agent guidance

Read `.agents/AGENTS.md` before editing; it defines the global coding, scope, testing, and Git rules for work in this repository.
Whenever a configuration entry is added or edited, update the `Structure` table with its source and link targets.

## Documented workflows

- Before creating a branch, read `docs/agents/branch-template.md`.
- Before creating a commit, read `docs/agents/commit-template.md`.
- Before creating an issue or work item, read `docs/agents/issue-template-guidance.md`.
- Before creating or updating a pull request, read `docs/agents/pull-request-template.md`.
- Before creating a release, read `.github/release_template.md`.
- Before locating code or doing structural or cross-component work, read `ARCHITECTURE.md`; update it in the same change when structure, components, data stores, integrations, or invariants change, and add each settled domain term to its Domain language section as `**Term**:` with a one- or two-sentence definition followed by `_Avoid_:` synonyms.
- Before working in an area, read the ADRs in `docs/adr/` that touch it and flag any conflict explicitly; record a decision without asking when it is hard to reverse, surprising without context, and the result of a real trade-off, using `docs/adr/NNNN-kebab-slug.md` with a short title and 1-3 sentences on context, decision, and why, and supersede rather than rewrite a changed decision.

## Structure

| Folder              | Config                                 | Linked to                                                                                                                                                                                                                                                                                                 |
| ------------------- | -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bash/`             | `.bashrc`                              | `~/.bashrc`                                                                                                                                                                                                                                                                                               |
| `copilot/`          | `settings.json`                        | `~/.copilot/settings.json` (Linux, or `$COPILOT_HOME/settings.json`) / `$env:COPILOT_HOME\settings.json` (Windows)                                                                                                                                                                                        |
| `ghostty/`          | `config`                               | `~/.config/ghostty/config`                                                                                                                                                                                                                                                                                |
| `lazygit/`          | `config.yml`, `extdiff.sh`             | `~/.config/lazygit/` (Linux) / `$XDG_CONFIG_HOME\lazygit\` (Windows)                                                                                                                                                                                                                                      |
| `nvim/`             | `init.lua` (plugins, parsers, and LSP) | `~/.config/nvim/init.lua` (Linux) / `$XDG_CONFIG_HOME\nvim\init.lua` (Windows)                                                                                                                                                                                                                            |
| `oh-my-posh/`       | `*.omp.json`                           | `~/.config/oh-my-posh/` (Linux) / `$XDG_CONFIG_HOME\oh-my-posh\` (Windows)                                                                                                                                                                                                                                |
| `.agents/`          | `AGENTS.md` (global instructions)      | `~/.gemini/antigravity-cli/rules/AGENTS.md`, `~/.github/copilot-instructions.md`, `~/.agents/AGENTS.md` (Linux) / `$UserHome\.gemini\antigravity-cli\rules\AGENTS.md`, `$env:COPILOT_HOME\copilot-instructions.md`, `$UserHome\.agents\AGENTS.md` (Windows) |
| `.agents/skills/`   | Per-skill folders (`SKILL.md` + files) | `~/.gemini/antigravity-cli/skills/<skill>/`, `~/.agents/skills/<skill>/` (Linux) / `$UserHome\.gemini\antigravity-cli\skills\<skill>\`, `$UserHome\.agents\skills\<skill>\`, `$env:COPILOT_HOME\skills\<skill>\` (Windows junctions)                       |
| `powershell/`       | `Microsoft.PowerShell_profile.ps1`     | `~\Documents\PowerShell\`, `~\Documents\WindowsPowerShell\` (Windows only)                                                                                                                                                                                    |
| `tmux/`             | `.tmux.conf`                           | `~/.tmux.conf`                                                                                                                                                                                                                                                |
| `vscode/`           | `settings.json`, `keybindings.json`    | `~/.config/Code/User/` (Linux) / `$UserAppData\Code\User\` (Windows standard profile) / `$SCOOP\persist\vscode\data\user-data\User\` (Windows Scoop portable)                                                                                                 |
| `windows-terminal/` | `settings.json`                        | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal*\LocalState\` (Windows only, MS Store)                                                                                                                                                                     |

## Platform notes

- **tmux:** shared config, Windows-only settings guarded with `if-shell 'if ($env:OS -ne "Windows_NT") { exit 1 }'`. On Windows, psmux is used instead of native tmux, and `setup.ps1` creates a `$UserHome\.psmux` junction pointing to `$env:XDG_CONFIG_HOME\psmux`.
- **oh-my-posh:** two themes — `star-ghostty.omp.json` for Ghostty (Linux), `star-win-term.omp.json` for Windows Terminal. On Windows, `EnsureScoopAppDataJunctions` links `%LOCALAPPDATA%\oh-my-posh` to `$SCOOP\AppData\Local\oh-my-posh`.
- **Windows setup** must run as Administrator to create symlinks and junctions, and validates that all required user environment variables in `$RequiredEnv` exist and point to valid paths (`SCOOP`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME`, `XDG_BIN_HOME`, `XDG_RUNTIME_DIR`, `NUGET_PACKAGES`, `GH_CONFIG_DIR`, `AZURE_CONFIG_DIR`, `COPILOT_HOME`, `TEMP`, `TMP`, `NPM_CONFIG_CACHE`, `NPM_CONFIG_PREFIX`, `NPM_CONFIG_USERCONFIG`, `NPM_CONFIG_GLOBALCONFIG`, `VSCODE_EXTENSIONS`, `VSCODE_AGENT_FOLDER`, `VSCODE_CLI_DATA_DIR`).
- **PowerShell profile** and **Windows Terminal** are Windows-only; no Linux equivalents in this repo.
- **VS Code** is linked to `~/.config/Code/User/` on Linux and to both `$UserAppData\Code\User\` (standard profile) and `$SCOOP\persist\vscode\data\user-data\User\` (Scoop portable) on Windows.

## Conventions

- Never add platform-specific logic directly into shared configs — use guards (`if-shell`, `$IsWindows`, etc.) or separate files.
- Keep cross-platform link definitions in sync between `setup.sh` and `setup.ps1`; platform-specific configs belong only in the applicable script.
- All files use LF line endings, tabs for indentation (spaces for YAML), UTF-8, and a final newline — enforced via `.editorconfig` (present in the repo root).
- **`.agents/`** contains the `AGENTS.md` file loaded as global context by AI coding assistants like Google Antigravity and GitHub Copilot. It is linked into their respective global rule directories, including GitHub Copilot CLI on Windows.
- **`.agents/skills/`** contains one folder per repository-managed skill (e.g. `pepi-unslop`, `pepi-project-setup`, `pepi-interview`, `pepi-visualize`, `pepi-show-me`, `pepi-retro`, listed explicitly in `setup.sh`/`setup.ps1`). Each folder contains `SKILL.md` and any supporting files, and is linked as a whole into `~/.gemini/antigravity-cli/skills/<skill>/` and `~/.agents/skills/<skill>/` (used by GitHub Copilot).

## Validation

- This repository has no build, test, or lint configuration.
- For setup or instruction changes, run `bash -n setup.sh`, a syntax-only PowerShell parse of `setup.ps1`, and `git diff --check`. Do not execute the setup scripts as validation because they replace destination paths.
