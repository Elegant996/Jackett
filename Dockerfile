FROM alpine:3.20 as stage

ARG VERSION

RUN apk add --no-cache \
    curl \
    xz
RUN mkdir -p /opt/Jackett
RUN curl -o /tmp/jackett.tar.gz -sL "https://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.LinuxMuslAMDx64.tar.gz"
RUN tar xzf /tmp/jackett.tar.gz -C /opt/Jackett --strip-components=1
RUN rm -rf /tmp/*

FROM alpine:3.20 as mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox \
    icu-data-full \
    icu-libs \
    libcurl \
    tzdata
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY --from=stage /opt/Jackett /opt/Jackett/

EXPOSE 9117
VOLUME [ "/data" ]
ENV HOME /data
WORKDIR $HOME
CMD ["/opt/Jackett/jackett", "--NoUpdates"]

LABEL org.opencontainers.image.description="API Support for your favorite torrent trackers"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.source="https://github.com/Jackett/Jackett"
LABEL org.opencontainers.image.title="Jackett"
LABEL org.opencontainers.image.version=${VERSION}