FROM alpine:3.21 AS source

ADD ./jackett.tar.gz /

FROM alpine:3.21 as build-sysroot

# Prepare sysroot
RUN mkdir -p /sysroot/etc/apk && cp -r /etc/apk/* /sysroot/etc/apk/

# Fetch runtime dependencies
RUN apk add --no-cache --initdb -p /sysroot \
    alpine-baselayout \
    busybox \
    icu-data-full \
    icu-libs \
    libcurl \
    tzdata
RUN rm -rf /sysroot/etc/apk /sysroot/lib/apk /sysroot/var/cache

# Install Jackett to new system root
RUN mkdir -p /sysroot/opt/Jackett
COPY --from=source /Jackett /sysroot/opt/Jackett

# Install entrypoint
COPY --chmod=755 ./entrypoint.sh /sysroot/entrypoint.sh

# Build image
FROM scratch
COPY --from=build-sysroot /sysroot/ /

EXPOSE 9117
VOLUME [ "/data" ]
ENV HOME=/data
WORKDIR $HOME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/Jackett/jackett", "--NoUpdates"]