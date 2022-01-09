FROM --platform=$TARGETPLATFORM xcmd/alpine

RUN x proxy apk set && \
    apk add -u dash bash zsh mksh && \
    x proxy apk set official

ADD x /bin/x
RUN chmod +x /bin/x

ENV ENV="/root/.ashrc"
RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$ENV"


RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$HOME/.bashrc"
RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$HOME/.kshrc"
RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$HOME/.dashrc"
RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$HOME/.zshrc"

# RUN printf "x theme use ys" | bash -i

RUN x proxy apk set && \
    apk add -u git && \
    x proxy apk set official
