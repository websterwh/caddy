# caddy-crowdsec

Custom Caddy 2 build with plugins baked in via [xcaddy](https://github.com/caddyserver/xcaddy).

## Current plugins
- [caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer) — CrowdSec integration, blocks known-bad IPs at the edge
- [caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip) — enables `trusted_proxies cloudflare` for Cloudflare Tunnel setups

## Images
- `ghcr.io/websterwh/caddy-crowdsec:latest`
- `websterwh/caddy-crowdsec:latest`

Drop-in replacement for the official `caddy:2` image — same volumes, same Caddyfile syntax, just extra modules registered.

## Adding a new plugin

Edit `plugins.txt`, add one line per Go module path, commit, push:

```
github.com/hslatman/caddy-crowdsec-bouncer
github.com/WeidiDeng/caddy-cloudflare-ip
github.com/your/new-plugin
```

Push to `main` and the workflow rebuilds and pushes `latest` automatically. No Dockerfile or workflow edits needed.

## Testing a plugin before committing it

Go to Actions → Build and Push → Run workflow, and fill in `extra_plugin` with the module path. This builds and pushes a `test-<sha>` tag instead of touching `latest`, so you can pull it and test without affecting your running stack. Once confirmed, add it to `plugins.txt` properly and push.

## Automatic rebuilds

- **Weekly schedule** (Mondays 06:00 UTC): rebuilds against the latest `caddy:2-builder` base to pick up upstream Caddy security patches even if this repo hasn't changed.
- **Dependabot**: opens PRs when the `caddy` base image tag or GitHub Actions versions in the workflow have updates. Docker/Actions version bumps only — Dependabot can't see xcaddy module versions since they aren't tracked via a go.mod in this repo, so plugin updates ride along automatically each time xcaddy resolves latest at build time.