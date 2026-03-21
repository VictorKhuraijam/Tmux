#!/bin/bash

RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"
KEEP=300

cd "$RESURRECT_DIR" || exit 1

# Count total resurrect files
total=$(/bin/ls -1 tmux_resurrect_*.txt 2>/dev/null | wc -l)

if [[ "$total" -le "$KEEP" ]]; then
 echo "Only $total files found, nothing to clean up."
 exit 0
fi

# Delete oldest files, keeping the lastest $KEEP
/bin/ls -1t tmux_resurrect_*.txt | tail -n +$((KEEP + 1)) | xargs rm -f

echo "Cleaned up $((total -KEEP)) old restore points. Keeping latest $KEEP."

