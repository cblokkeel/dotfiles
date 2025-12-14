alias cd="z"
alias vim="nvim"
alias v="nvim"
alias ls="eza"
alias ll="eza -lah"
alias cat="bat"
alias src="source ~/.zshrc"

alias g="git"

alias gs="git status"
alias gss="git status --short"

alias ga="git add"
alias gaa="git add -A"
alias gap="git add --patch"

alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcae="git commit --amend --no-edit"

alias gd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
alias gp="git push"
alias gu="git pull"
alias gpf="git push --force-with-lease"

alias gi="git init"
alias gcl="git clone"
alias gl="git log --decorate --graph --all"

alias up="docker compose up -d"
alias down="docker compose down"
alias logs="docker logs --follow --tail 100"

alias submit="gt submit --stack --update-only"
alias modify="gt modify"

alias tf="terraform"

alias k="kubectl"
alias ktx="kubectx"
alias kgp="kubectl get pods"
alias kpf="kubectl port-forward"
