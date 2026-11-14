#!/usr/bin/env bash

echo "Setting up symlinks..."

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src="$1"
	local dst="$2"

	if [[ "$src" != /* ]]; then
		src="$DOTFILES/$src"
	fi

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

# AI Agents (Google Antigravity & GitHub Copilot)
link ".agents/AGENTS.md" "$HOME/.gemini/antigravity-cli/rules/AGENTS.md"
link ".agents/AGENTS.md" "$HOME/.github/copilot-instructions.md"
link ".agents/AGENTS.md" "$HOME/.agents/AGENTS.md"

# AI Agent Skills (Google Antigravity & GitHub Copilot)
for skill in pepi-unslop pepi-project-setup pepi-interview pepi-visualize pepi-show-me; do
	link ".agents/skills/$skill" "$HOME/.gemini/antigravity-cli/skills/$skill"
	link ".agents/skills/$skill" "$HOME/.agents/skills/$skill"
done

# Tmux
link "tmux/.tmux.conf" "$HOME/.tmux.conf"

# Herdr
link "herdr/config.toml" "$HOME/.config/herdr/config.toml"

# Lazygit
link "lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
link "lazygit/extdiff.sh" "$HOME/.config/lazygit/extdiff.sh"

# Neovim
link "nvim/init.lua" "$HOME/.config/nvim/init.lua"

# VS Code (Linux path)
VSCODE_DIR="$HOME/.config/Code/User"
link "vscode/settings.json" "$VSCODE_DIR/settings.json"
link "vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

# Zed
link "zed/settings.json" "$HOME/.config/zed/settings.json"
link "zed/keymap.json" "$HOME/.config/zed/keymap.json"

echo "Done."
