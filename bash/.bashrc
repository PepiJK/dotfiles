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

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# angular cli completions
source <(ng completion script)

# oh my posh
eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/star-ghostty.omp.json)"
