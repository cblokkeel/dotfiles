#!/usr/bin/env bash
# scripts/helpers.sh

# ── Defaults ──────────────────────────────────────────────────────────────────
DEFAULT_ACTIVE_BORDER_COLOR="colour39"   # bright cyan  (like iTerm2)
DEFAULT_INACTIVE_BORDER_COLOR="colour238" # dim grey
DEFAULT_ACTIVE_PANE_STYLE=""             # optional background tint for active pane
DEFAULT_INACTIVE_PANE_STYLE="bg=colour234" # subtle dark bg for inactive panes
DEFAULT_DIM_INACTIVE="on"               # whether to dim inactive pane content

# ── Read user config (via @plugin options in .tmux.conf) ──────────────────────
get_tmux_option() {
  local option="$1"
  local default="$2"
  local value
  value="$(tmux show-option -gqv "$option")"
  echo "${value:-$default}"
}

apply_pane_highlight_settings() {
  local active_border
  local inactive_border
  local active_style
  local inactive_style
  local dim_inactive

  active_border="$(get_tmux_option "@pane-focus-active-border" "$DEFAULT_ACTIVE_BORDER_COLOR")"
  inactive_border="$(get_tmux_option "@pane-focus-inactive-border" "$DEFAULT_INACTIVE_BORDER_COLOR")"
  active_style="$(get_tmux_option "@pane-focus-active-style" "$DEFAULT_ACTIVE_PANE_STYLE")"
  inactive_style="$(get_tmux_option "@pane-focus-inactive-style" "$DEFAULT_INACTIVE_PANE_STYLE")"
  dim_inactive="$(get_tmux_option "@pane-focus-dim-inactive" "$DEFAULT_DIM_INACTIVE")"

  # Pane border colors
  tmux set-option -g pane-active-border-style "fg=${active_border}"
  tmux set-option -g pane-border-style "fg=${inactive_border}"

  # Pane background styles (active vs inactive content area)
  if [[ -n "$active_style" ]]; then
    tmux set-option -g window-active-style "$active_style"
  fi
  if [[ -n "$inactive_style" ]]; then
    tmux set-option -g window-style "$inactive_style"
  fi

  # Dim inactive panes (draws content at reduced intensity)
  if [[ "$dim_inactive" == "on" ]]; then
    # Only set dim if window-style doesn't already set bg, to avoid conflicts
    if [[ -z "$inactive_style" ]]; then
      tmux set-option -g window-style "fg=colour250,bg=default"
    fi
    tmux set-option -g window-active-style "fg=default,bg=default"
  fi
}

setup_hooks() {
  # Re-apply on relevant events so styles survive session attach / new windows
  tmux set-hook -g client-focus-in  "run-shell '#{CURRENT_DIR}/scripts/refresh.sh'"
  tmux set-hook -g client-focus-out "run-shell '#{CURRENT_DIR}/scripts/refresh.sh'"
  tmux set-hook -g after-select-pane "run-shell '#{CURRENT_DIR}/scripts/refresh.sh'"
  tmux set-hook -g after-new-window  "run-shell '#{CURRENT_DIR}/scripts/refresh.sh'"
  tmux set-hook -g session-created   "run-shell '#{CURRENT_DIR}/scripts/refresh.sh'"
}
