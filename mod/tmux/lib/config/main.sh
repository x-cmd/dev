

# . "${___X_CMD_ROOT_MOD}/xrc/latest"
. "${___X_CMD_ROOT_MOD}/xrc/latest"


___x_cmd_tmux_set_color(){
    : bg : color222 color111 color150 color140
    x tmux set status-bg "$1"
    # x tmux set status-fg "$2"
}


tmux setw -g    window-status-separator ' '
tmux setw -g    window-status-format "#I:#W "
tmux setw -g    window-status-current-format "#[fg=red,bg=cyan,bold]#I:#W#{?window_zoomed_flag,🔍,}"


tmux set -g     status-right-style  "bg=yellow"
tmux set -g     status-left-style   "bg=orange"

# tmux set -g     status-left "#(tmux show -v mouse)  "

# tmux set -g     status-left "#(date +%H:%M)  "

tmux set        status-interval 1
# tmux set -g     status-left "#(date +%T)  "
tmux set -g     status-right "#{host} #(date +%H:%M)"

# Provide keby
tmux bind b    display-popup -E "${SHELL:-/bin/sh} $___X_CMD_ROOT_MOD/tmux/lib/config/popup.sh"


# Section: yank mode
# copy-pipe
___X_CMD_TMUX_COPY_CANCEL="${___X_CMD_TMUX_COPY_CANCEL:-copy-pipe-and-cancel}"


x os name_
case "$___X_CMD_OS_NAME_" in
    darwin)
        tmux \
            bind-key -T copy-mode MouseDragEnd1Pane send-keys -X "$___X_CMD_TMUX_COPY_CANCEL" pbcopy \; \
            bind y run -b "tmux save-buffer - | pbcopy" \; # \
            # bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"
        ;;

    linux)
        if command -v xsel >/dev/null 2>&1; then
            tmux \
                bind-key -T copy-mode MouseDragEnd1Pane send-keys -X "$___X_CMD_TMUX_COPY_CANCEL" 'xsel -i -b' \; \
                bind-key y run -b "tmux save-buffer - | xsel -i -b"
        elif command -v xclip >/dev/null 2>&1; then
            tmux \
                bind-key -T copy-mode MouseDragEnd1Pane send-keys -X "$___X_CMD_TMUX_COPY_CANCEL" 'xclip -i -selection clipboard' \; \
                bind-key y run -b "tmux save-buffer - | xclip -i -selection clipboard"
        else
            printf "%s\n" "Please install xsel or xclip." >&2
        fi
    ;;

    win)
        if [ -c /dev/clipboard ]; then
            tmux \
                bind-key -T copy-mode MouseDragEnd1Pane send-keys -X "$___X_CMD_TMUX_COPY_CANCEL" 'cat >/dev/clipboard' \; \
                bind-key y run -b "tmux save-buffer - > /dev/clipboard"
        else
            tmux \
                bind-key -T copy-mode MouseDragEnd1Pane send-keys -X "$___X_CMD_TMUX_COPY_CANCEL" clip.exe \; \
                bind-key y run -b "tmux save-buffer - | clip.exe"
        fi
    ;;
esac

tmux set mouse on

# # TODO: better design for this.
# # copy to X11 clipboard
# if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xsel -i -b"'
# if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
# # copy to macOS clipboard
# if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | pbcopy"'
# if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"'
# # copy to Windows clipboard
# if -b 'command -v clip.exe > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | clip.exe"'
# if -b '[ -c /dev/clipboard ]' 'bind y run -b "tmux save-buffer - > /dev/clipboard"'


# EndSection

