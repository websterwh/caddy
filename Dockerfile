FROM caddy:2-builder AS builder

# Optional: pass a one-off extra plugin at build time without touching plugins.txt
# e.g. docker build --build-arg EXTRA_PLUGIN=github.com/foo/bar .
ARG EXTRA_PLUGIN=""

COPY plugins.txt /plugins.txt

RUN set -eux; \
    PLUGIN_ARGS=$(awk '\
        { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0) } \
        /^[[:space:]]*#/ || /^$/ { next } \
        { if ($0 !~ /^[^\/]+\.[^\/]+\//) $0="github.com/" $0; printf "--with %s ", $0 }' /plugins.txt); \
    if [ -n "$EXTRA_PLUGIN" ]; then \
        PLUGIN_ARGS="$PLUGIN_ARGS --with $EXTRA_PLUGIN"; \
    fi; \
    echo "Building with: $PLUGIN_ARGS"; \
    eval xcaddy build $PLUGIN_ARGS

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
