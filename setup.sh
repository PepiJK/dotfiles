#!/usr/bin/env bash

echo "Setting up symlinks..."

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src="$DOTFILES/$1"
	local dst="$2"

	mkdir -p "$(dirname "$dst")"
	rm -rf "$dst"
	ln -s "$src" "$dst"
	echo "LINK  $dst -> $src"
}

# Bash
link "bash/.bashrc" "$HOME/.bashrc"

# Ghostty
link "ghostty/config" "$HOME/.config/ghostty/config"

# Oh My Posh
link "oh-my-posh/star-ghostty.omp.json" "$HOME/.config/oh-my-posh/star-ghostty.omp.json"
link "oh-my-posh/star-win-term.omp.json" "$HOME/.config/oh-my-posh/star-win-term.omp.json"

# Pi
link "pi/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"

# Tmux
link "tmux/.tmux.conf" "$HOME/.tmux.conf"

# Lazygit
link "lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

# Neovim
link "nvim/init.lua" "$HOME/.config/nvim/init.lua"

# VS Code (Linux path)
VSCODE_DIR="$HOME/.config/Code/User"
link "vscode/settings.json" "$VSCODE_DIR/settings.json"
link "vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

echo "Done."
