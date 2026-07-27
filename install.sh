#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
DOTFILES="$PWD"

if [ -n "${CODER_WORKSPACE_NAME:-}" ]; then
  HEADLESS=1
else
  HEADLESS=0
fi

if [ "$HEADLESS" = 1 ] && command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq
  sudo apt-get install -y stow zsh git curl unzip fzf ripgrep fd-find tmux bat

  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  command -v starship >/dev/null 2>&1 ||
    curl -sS https://starship.rs/install.sh |
    sh -s -- --yes --bin-dir "$HOME/.local/bin"

  command -v zoxide >/dev/null 2>&1 ||
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh |
    sh -s -- --bin-dir "$HOME/.local/bin"

  case "$(uname -m)" in
  aarch64 | arm64)
    nvim_arch=arm64
    eza_target=aarch64-unknown-linux-gnu
    ;;
  *)
    nvim_arch=x86_64
    eza_target=x86_64-unknown-linux-gnu
    ;;
  esac

  if ! command -v nvim >/dev/null 2>&1; then
    curl -fsSL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-$nvim_arch.tar.gz" |
      tar -xz -C "$HOME/.local"
    ln -sfn "$HOME/.local/nvim-linux-$nvim_arch/bin/nvim" "$HOME/.local/bin/nvim"
  fi

  if ! command -v eza >/dev/null 2>&1; then
    curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_$eza_target.tar.gz" |
      tar -xz -C "$HOME/.local/bin" ./eza
  fi

  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
fi

command -v stow >/dev/null 2>&1 || {
  echo "stow not found and no apt-get to install it; aborting" >&2
  exit 1
}

if [ "$HEADLESS" = 1 ]; then
  cat >"$HOME/.gitconfig" <<EOF
[include]
	path = $DOTFILES/.gitconfig

[credential "https://github.com"]
	helper =

[credential "https://gist.github.com"]
	helper =
EOF
fi

for f in .zshrc .p10k.zsh .aliases.zsh; do
  if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$HOME/$f.bak"
  fi
done

if [ "$HEADLESS" = 0 ]; then
  stow --target="$HOME" --restow --ignore='^install\.sh$' .
else
  stow --target="$HOME" --delete . 2>/dev/null || true

  PACKAGES=()
  for d in */; do
    case "${d%/}" in
    aerospace | backgrounds | ghostty | kitty | zed | waybar | wofi | hypr*) continue ;;
    esac
    PACKAGES+=("${d%/}")
  done
  stow --target="$HOME" --restow ${PACKAGES[@]+"${PACKAGES[@]}"}

  stow --target="$HOME" --restow \
    --ignore='^[^.].*$' \
    --ignore='^\.config$' \
    --ignore='^\.st(folder|ignore)$' \
    --ignore='^\.gitconfig$' \
    .
fi

if [ "$HEADLESS" = 1 ] && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$USER"
fi
