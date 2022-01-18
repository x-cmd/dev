FROM --platform=$TARGETPLATFORM xcmd/base-ubuntu-2-dev

RUN eval "$(curl https://get.x-cmd.com/dev)"

RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' \
    | tee "$HOME/.bashrc" "$HOME/.kshrc" "$HOME/.dashrc" "$HOME/.zshrc"