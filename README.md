# Custom Caddy image

This image builds Caddy with modules listed in `plugins.txt`.

## `plugins.txt` format

- Lines that are empty or start with `#` are ignored.
- Full Go module paths are used as-is, for example `github.com/caddy-dns/cloudflare`.
- GitHub shorthand entries are supported and are auto-prefixed with `github.com/`, for example:
  - `lucaslorentz/caddy-docker-proxy/v2` becomes `github.com/lucaslorentz/caddy-docker-proxy/v2`.

`EXTRA_PLUGIN` is still supported at build time for one-off module testing.

## Bundled Docker proxy

This image bundles `lucaslorentz/caddy-docker-proxy/v2` and starts with the Docker proxy command (`caddy docker-proxy`).

At runtime, mount the Docker socket so the proxy can discover containers:

```bash
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 80:80 -p 443:443 \
  <image>
```
