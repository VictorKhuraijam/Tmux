#!/usr/bin/env bash

set -e

DIR="$HOME/.local/share/tmux/resurrect"
SAVE_SCRIPT="$HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh"

name=$(printf "" | fzf --print-query --prompt="Checkpoint name: " | head -1)

[ -z "$name" ] && exit

# Save using tmux-resurrect
tmux run-shell "$SAVE_SCRIPT"

# Wait for the save to finish
sleep 0.5

latest=$(find "$DIR" -maxdepth 1 -name 'tmux_resurrect_*' -printf '%T@ %p\n' |
	sort -nr |
	head -1 |
	cut -d' ' -f2-)

if [[ -e "$DIR/$name.txt" ]]; then
	tmux display-message "Checkpoint '$name' already exists."
	exit 1
fi

cp "$latest" "$DIR/$name.txt"

# Make this the default restore target
ln -sf "$name.txt" "$DIR/last"

tmux display-message "Checkpoint saved as: $name"
