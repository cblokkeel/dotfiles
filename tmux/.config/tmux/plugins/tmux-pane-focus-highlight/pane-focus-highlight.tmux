#!/usr/bin/env bash
# pane-focus-highlight.tmux
# TPM-compatible plugin entry point

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

main() {
  apply_pane_highlight_settings
  setup_hooks
}

main
