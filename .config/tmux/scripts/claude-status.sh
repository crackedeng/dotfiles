#!/bin/sh
pane_pid=${1:-$(tmux display-message -p '#{pane_pid}' 2>/dev/null)}
# Get all descendant PIDs recursively
descendants() {
    for child in $(pgrep -P "$1" 2>/dev/null); do
        echo "$child"
        descendants "$child"
    done
}
for pid in $(descendants "$pane_pid"); do
    if [ -L "/tmp/claude-tmux-pid-$pid" ]; then
        cat "/tmp/claude-tmux-pid-$pid" 2>/dev/null
        exit 0
    fi
done
