# claude-deep

Run [Claude Code](https://claude.ai/code) backed by [DeepSeek](https://platform.deepseek.com/) models instead of Anthropic's API. Same CLI, different (cheaper) inference.

| Claude Code role | Model |
|---|---|
| Main agent (Opus/Sonnet) | `deepseek-v4-pro` |
| Subagents & fast tasks (Haiku) | `deepseek-v4-flash-no-reasoner` |

## Requirements

- DeepSeek API key — get one at [platform.deepseek.com](https://platform.deepseek.com/)
- [Claude Code](https://claude.ai/code) CLI (`claude` in PATH):

  ```bash
  curl -fsSL -x [http|socks5://proxy:port] https://claude.ai/install.sh | bash
  ```

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/andrey-n-safonov/claude-deep/main/install.sh | bash
```

The script will:
1. Download `claude-deep` to `~/bin/`
2. Prompt for your DeepSeek API key
3. Save it to `~/.config/claude-deep/env` (mode 600)

## Usage

```bash
claude-deep           # interactive session
claude-deep -p "..."  # one-shot prompt
```

All `claude` flags work as usual.

## Configuration

`~/.config/claude-deep/env` is sourced at startup:

```bash
DEEPSEEK_API_KEY=sk-...
# DEEPSEEK_BASE_URL=https://api.deepseek.com/anthropic  # default
```

To update the key, re-run `install.sh` or edit the file directly.

### Proxy

Claude Code makes a hardcoded connectivity check to `api.anthropic.com` on startup regardless of `ANTHROPIC_BASE_URL`. If Anthropic's servers are not directly reachable, set an HTTP proxy (Node.js does not support SOCKS5 in `HTTPS_PROXY`):

```bash
HTTPS_PROXY=http://127.0.0.1:8118
NO_PROXY=api.deepseek.com
```

If you only have a SOCKS5 proxy, put [Privoxy](https://www.privoxy.org/) in front of it:

```bash
# /etc/privoxy/config — add:
forward-socks5t / 127.0.0.1:1081 .
```

Then point `HTTPS_PROXY` to Privoxy (`http://127.0.0.1:8118`). DeepSeek API traffic goes direct via `NO_PROXY`.

## How it works

`claude-deep` sets `ANTHROPIC_BASE_URL` to DeepSeek's Anthropic-compatible endpoint and maps Claude model tiers to DeepSeek equivalents via `ANTHROPIC_DEFAULT_*` env vars. Claude Code itself is unmodified.
