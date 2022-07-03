

# split:
#     - vertical
#     - horizontal
# new:
#     - window
#     - session
#     - pane
# kill:
#     - window
#     - session
#     - pane


. $HOME/.x-cmd/xrc/latest

while true; do
    x ui select idx "Command: " \
        "choose-tree (<PREFIX> + s)" \
        "vertical-split (<PREFIX> + \")" \
        "horizontal-split (<PREFIX> + \%)" \
        "new-window (<PREFIX> + n)" \
        "kill-window (<PREFIX> + k)" \
        "kill-panel (<PREFIX> + x)" \
        "new-session (<PREFIX> + Ctrl-C)"

    case "$idx" in
        1)              tmux choose-tree;           exit ;;
        2)              tmux split-window -v;       exit ;;
        3)              tmux split-window -h;       exit ;;
        4)              tmux new-window;            exit ;;
        5)              tmux kill-window;           exit ;;
        6)              tmux kill-panel;            exit ;;
        7)              tmux new-session;           exit ;;
        *)              ;;
    esac
done

