# Import aliases
source ~/.zaliases
# App vars
export PASSWORD_STORE_GPG_OPTS="--armor"
export FZF_DEFAULT_OPTS="--reverse --border"
# Do not store commands that start with a space
setopt HIST_IGNORE_SPACE
# Lines configured by zsh-newuser-install
HISTFILE=~/.zhistfile
HISTSIZE=10000
SAVEHIST=10000
# Vi mode
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/msytnyk/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# ZSH autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH syntax highlightning
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# Starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"
