#!/usr/bin/env bash
# scripts/refresh.sh
# Called by tmux hooks to re-apply pane highlight styles

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

apply_pane_highlight_settings
