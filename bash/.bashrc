# source local overrides
if [ -f "$HOME/.bashrc.local" ]; then
	source "$HOME/.bashrc.local"
fi

# skip if non-interactiv
[[ $- != *i* ]] && return

# history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

# aliases
alias ls='ls -lah --color=auto'
alias grep='grep --color=auto'
alias lg='lazygit'
alias cc='claude'
alias nv='nvim'

# env variables
export EDITOR="nvim"

# angular cli completions
source <(ng completion script 2>/dev/null)

# fnm setup
eval "$(fnm env --use-on-cd --shell bash)"

# oh my posh
eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/star-ghostty.omp.json)"

# Added by Antigravity CLI installer
export PATH="/home/josef/.local/bin:$PATH"
