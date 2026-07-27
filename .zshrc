ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

PATH="/opt/homebrew/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

source "${ZINIT_HOME}/zinit.zsh"

eval "$(rbenv init - zsh)"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode
zinit wait lucid light-mode for lukechilds/zsh-nvm

autoload -Uz compinit
compinit -C
zinit cdreplay -q

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color $realpath"
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "ls --color $realpath"

eval "$(fzf --zsh)"

if [ -f "$HOME/.aliases.zsh" ]; then
    source "$HOME/.aliases.zsh"
fi

# bun completions
[ -s "/Users/colin/.bun/_bun" ] && source "/Users/colin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
# export PNPM_HOME="/Users/colin/Library/pnpm"
export PNPM_HOME="/Users/colin/.nvm/versions/node/v24.15.0/bin"
case ":$PATH:" in
  *":$PNPM_HOME:") ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load Angular CLI autocompletion (cached once)
if [[ ! -f ~/.zsh_ng_completion ]] && command -v ng >/dev/null 2>&1; then
  ng completion script > ~/.zsh_ng_completion 2>/dev/null
fi
[[ -f ~/.zsh_ng_completion ]] && source ~/.zsh_ng_completion

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

if [[ ":$PATH:" != *":$PYENV_ROOT/shims:"* ]]; then
  eval "$(pyenv init -)"
fi

# Git
export PATH=/usr/local/bin:$PATH

alias history="history 1"
alias docker="TERM=screen-256color docker"

# The next line updates PATH for the Google Cloud SDK.
if [[ -z "$GCLOUD_SDK_INITIALIZED" ]] && [ -f '/Users/colin/Downloads/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/colin/Downloads/google-cloud-sdk/path.zsh.inc'
  export GCLOUD_SDK_INITIALIZED=1
fi

# The next line enables shell command completion for gcloud.
if [[ -z "$GCLOUD_COMPLETION_INITIALIZED" ]] && [ -f '/Users/colin/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/colin/Downloads/google-cloud-sdk/completion.zsh.inc'
  export GCLOUD_COMPLETION_INITIALIZED=1
fi

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/helm@3/bin:$PATH"

export EDITOR=nvim

export PATH="$HOME/.local/bin:$PATH"

if [[ -z "$WT_SHELL_INITIALIZED" ]] && command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
  export WT_SHELL_INITIALIZED=1
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi


# ============ BEGIN coder COMPLETION ============
_coder_completions() {
	local -a args completions
	args=("${words[@]:1:$#words}")
	completions=(${(f)"$(COMPLETION_MODE=1 "coder" "${args[@]}")"})
	compadd -a completions
}
compdef _coder_completions coder
# ============ END coder COMPLETION ==============


[ -f ~/.zshrc.local ] && source ~/.zshrc.local

