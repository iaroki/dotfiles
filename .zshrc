typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/6lrbkxnpym1z8lqrrpg59bwnddxfdc52-zsh-5.9/share/zsh/$ZSH_VERSION/help"

# Use viins keymap as the default.
bindkey -v

STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
VI_MODE_SET_CURSOR=true
autoload -U compinit && compinit
source /nix/store/7103y0q8n75aj611pcfv48sv3nfj2gzd-zsh-autosuggestions-0.7.1/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)


# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/home/msytnyk/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd

if [[ $options[zle] = on ]]; then
  source <(/nix/store/zqn0nh2q8c81rf5z7gx3d87cl233yzdw-fzf-0.65.0/bin/fzf --zsh)
fi

bindkey jk vi-cmd-mode
zstyle ':completion::complete:make:*:targets' call-command true
# emacs vterm
if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
  source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi

if [[ $TERM != "dumb" ]]; then
  eval "$(/nix/store/6hq21mqkmdm1ds9974w9xw00blym6fh5-starship-1.23.0/bin/starship init zsh)"
fi

eval "$(/nix/store/qj6a7xr3knnl5wjs3rvr8ajbjkxbn32f-direnv-2.37.1/bin/direnv hook zsh)"

export GPG_TTY=$TTY
/nix/store/m7b03yjgsang1kws4lwhzk0dr0dkrjwf-gnupg-2.4.8/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null

alias -- aws_profile='export AWS_PROFILE=$(aws configure list-profiles | fzf --prompt "Choose active AWS profile:")'
alias -- b='bat --style=header,grid --paging=never'
alias -- ga='git add'
alias -- gc='git commit'
alias -- gco='git checkout'
alias -- gcp='git cherry-pick'
alias -- gdiff='git diff'
alias -- gl='git prettylog'
alias -- gp='git push'
alias -- gs='git status'
alias -- gt='git tag'
alias -- gwa='git worktree add'
alias -- gwl='git worktree list'
alias -- gwr='git worktree remove'
alias -- home-switch='home-manager switch --flake '\''.#thinkpad'\'''
alias -- lg=lazygit
alias -- ll='eza -l'
alias -- ls=eza
alias -- nixos-switch='sudo nixos-rebuild switch --flake '\''.#thinkpad'\'''
alias -- vf='vifm .'
alias -- vim=nvim
source /nix/store/34r5z8iyybf3l8wb4i089p489whsmrcz-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()


