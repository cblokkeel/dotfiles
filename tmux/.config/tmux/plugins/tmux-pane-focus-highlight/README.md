# tmux-pane-focus-highlight

Highlight the active tmux pane — like iTerm2's focused-pane indicator.

- Bright border on the active pane
- Dimmed border + slightly darker background on inactive panes
- Works with [TPM](https://github.com/tmux-plugins/tpm) or manual install
- Zero dependencies beyond tmux ≥ 2.1

---

## What it looks like

```
┌─────────────────────┬─────────────────┐
│                     │                 │
│   ACTIVE PANE       │  inactive pane  │
│   (cyan border)     │  (dim border +  │
│                     │   dark bg)      │
│                     │                 │
└─────────────────────┴─────────────────┘
```

---

## Installation

### With TPM (recommended)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'your-username/tmux-pane-focus-highlight'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/your-username/tmux-pane-focus-highlight \
  ~/.tmux/plugins/tmux-pane-focus-highlight

# Add to ~/.tmux.conf:
run-shell ~/.tmux/plugins/tmux-pane-focus-highlight/pane-focus-highlight.tmux
```

Then reload: `tmux source ~/.tmux.conf`

---

## Configuration

All options go in `~/.tmux.conf` **before** the `run-shell` / TPM line.

| Option | Default | Description |
|---|---|---|
| `@pane-focus-active-border` | `colour39` | Active pane border color (cyan) |
| `@pane-focus-inactive-border` | `colour238` | Inactive pane border color (dim grey) |
| `@pane-focus-active-style` | _(none)_ | `window-active-style` value for active pane |
| `@pane-focus-inactive-style` | `bg=colour234` | `window-style` value for inactive panes |
| `@pane-focus-dim-inactive` | `on` | Dim inactive pane text (`on`/`off`) |

### Example customisations

```tmux
# iTerm2-style cyan highlight (default)
set -g @pane-focus-active-border   "colour39"
set -g @pane-focus-inactive-border "colour238"

# Amber / warm theme
set -g @pane-focus-active-border   "colour214"
set -g @pane-focus-inactive-border "colour240"

# Green terminal aesthetic
set -g @pane-focus-active-border   "colour46"
set -g @pane-focus-inactive-border "colour236"

# No background dimming (border highlight only)
set -g @pane-focus-dim-inactive    "off"
set -g @pane-focus-inactive-style  ""

# True color / hex (requires tmux ≥ 2.9 + terminal support)
set -g @pane-focus-active-border   "#5DB8D5"
set -g @pane-focus-inactive-border "#555555"
```

---

## Conflicts

If you already set `pane-active-border-style`, `pane-border-style`, `window-style`,
or `window-active-style` elsewhere in your config, move them **after** the plugin
load, or remove the conflicting plugin option to let your manual settings win.

---

## Requirements

- tmux ≥ 2.1 (for `window-style` / `window-active-style`)
- tmux ≥ 2.9 for true-color hex values in border styles
