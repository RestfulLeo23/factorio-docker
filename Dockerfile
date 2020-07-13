FROM frolvlad/alpine-glibc:alpine-3.12

LABEL maintainer="https://github.com/factoriotools/factorio-docker"

ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845

ENV PORT=34197 \
    RCON_PORT=27015 \
    VERSION=0.18.35 \
    SAVES=/factorio/saves \
    CONFIG=/factorio/config \
    MODS=/factorio/mods \
    PUID="$PUID" \
    PGID="$PGID"

RUN archive="/tmp/factorio_headless_x64_$VERSION.tar.xz" \
    && mkdir -p /opt /factorio \
    && apk add --update --no-cache --no-progress bash binutils curl file gettext jq libintl pwgen shadow su-exec \
    && curl -sSL "https://www.factorio.com/get-download/$VERSION/headless/linux64" -o "$archive" \
    && tar xf "$archive" --directory /opt \
    && chmod ugo=rwx /opt/factorio \
    && rm "$archive" \
    && mkdir -p /opt/factorio/config/ \
    && addgroup -g "$PGID" -S "$GROUP" \
    && adduser -u "$PUID" -G "$GROUP" -s /bin/sh -SDH "$USER" \
    && chown -R "$USER":"$GROUP" /opt/factorio /factorio

COPY files/*.sh /
COPY files/config.ini /opt/factorio/config/config.ini

VOLUME /factorio
EXPOSE $PORT/udp $RCON_PORT/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
