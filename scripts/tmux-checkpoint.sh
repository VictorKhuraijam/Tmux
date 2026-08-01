#!/usr/bin/env bash

set -e

DIR="$HOME/.local/share/tmux/resurrect"

cd "$DIR"

selected=$(
	{
		# Named checkpoints
		find . -maxdepth 1 -type f \
			-name "*.txt" \
			! -name "tmux_resurrect_*" \
			-printf "%T@\t%f\n" |
			sort -nr |
			cut -d' ' -f2-

		# Auto saves (newest first)
		find . -maxdepth 1 -type f \
			-name "tmux_resurrect_*" \
			-printf "%T@ %f\n" |
			sort -nr |
			cut -d' ' -f2- |
			awk '
        BEGIN { first=1 }
        {
            file=$0

            # Extract timestamp from filename
            ts=file
            sub(/^tmux_resurrect_/, "", ts)
            sub(/\.txt$/, "", ts)

            # Format:
            # 20260801T223022
            # ->
            # 2026-08-01 22:30
            year=substr(ts,1,4)
            mon=substr(ts,5,2)
            day=substr(ts,7,2)
            hour=substr(ts,10,2)
            min=substr(ts,12,2)

            pretty=year "-" mon "-" day " " hour ":" min

            if(first){
                printf "CHECKPOINT\tLatest Checkpoint (%s)\t%s\n", pretty, file
                first=0
            } else {
                printf "CHECKPOINT\tCheckpoint (%s)\t%s\n", pretty, file
            }
        }'
	} |
		fzf --with-nth=2 --delimiter='\t' |
		awk -F'\t' '{print $NF}'
)

[ -z "$selected" ] && exit

ln -sf "$selected" last

tmux run-shell ~/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh
