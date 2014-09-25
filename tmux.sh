#!/bin/bash
#
# Tmux configuration Hyperion
#


function tmux_hyperion {
    tmux start-server
    tmux new-session -s hyperion -n hyperion -d
    tmux new-window -n "Master"
    tmux new-window -n "Discovery"
    tmux new-window -n "Minion-1"
    tmux new-window -n "Minion-2"
    tmux attach-session -t hyperion
}

tmux_hyperion
