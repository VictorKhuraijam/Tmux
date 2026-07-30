#!/bin/bash
cd ~/.local/share/tmux/resurrect && ln -sf $(/bin/ls -1t tmux_resurrect_* | fzf) last && tmux run-shell ~/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh
