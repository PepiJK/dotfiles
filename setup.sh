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

# Hunk
link "hunk/config.toml" "$HOME/.config/hunk/config.toml"

# Oh My Posh
link "oh-my-posh/star-ghostty.omp.json" "$HOME/.config/oh-my-posh/star-ghostty.omp.json"
link "oh-my-posh/star-win-term.omp.json" "$HOME/.config/oh-my-posh/star-win-term.omp.json"

# AI Agents (Google Antigravity & GitHub Copilot)
link ".agents/AGENTS.md" "$HOME/.gemini/antigravity-cli/rules/AGENTS.md"
link ".agents/AGENTS.md" "$HOME/.github/copilot-instructions.md"
link ".agents/AGENTS.md" "$HOME/.agents/AGENTS.md"

# AI Agent Skills (Google Antigravity & GitHub Copilot)
for skill in pepi-verify pepi-update-docs pepi-commit pepi-pr-description pepi-unslop pepi-worktree; do
	link ".agents/skills/$skill/SKILL.md" "$HOME/.gemini/antigravity-cli/skills/$skill/SKILL.md"
	link ".agents/skills/$skill/SKILL.md" "$HOME/.agents/skills/$skill/SKILL.md"
done

if ! HUNK_SKILL_PATH="$(hunk skill path)"; then
	echo "Unable to resolve the Hunk skill with 'hunk skill path'." >&2
	exit 1
fi
if [[ ! -f "$HUNK_SKILL_PATH" ]]; then
	echo "Hunk skill path does not point to a file: $HUNK_SKILL_PATH" >&2
	exit 1
fi
link "$HUNK_SKILL_PATH" "$HOME/.gemini/antigravity-cli/skills/hunk-review/SKILL.md"
link "$HUNK_SKILL_PATH" "$HOME/.agents/skills/hunk-review/SKILL.md"

# Tmux
link "tmux/.tmux.conf" "$HOME/.tmux.conf"

# Herdr
link "herdr/config.toml" "$HOME/.config/herdr/config.toml"

# Lazygit
link "lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

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
