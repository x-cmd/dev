FROM --platform=$TARGETPLATFORM xcmd/base-alpine-2-dev

RUN eval "$(curl https://get.x-cmd.com/dev)"

ENV ENV="/root/.ashrc"
RUN printf '[ -f "$HOME/.x-cmd/.boot/boot" ] && . "$HOME/.x-cmd/.boot/boot"' >> "$ENV"
