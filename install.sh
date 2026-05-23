#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/andrey-n-safonov/claude-deep/main"
BIN_DIR="${HOME}/bin"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude-deep"
CONF_FILE="$CONF_DIR/env"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}→${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
err()     { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

# Зависимости
command -v claude >/dev/null 2>&1 || err "claude (Claude Code) не найден. Установи: https://claude.ai/code"

# Скачиваем бинарники
info "Скачиваю скрипты в $BIN_DIR ..."
mkdir -p "$BIN_DIR"
curl -fsSL "$REPO_URL/bin/claude-deep" -o "$BIN_DIR/claude-deep"
chmod +x "$BIN_DIR/claude-deep"

# ~/bin в PATH?
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    warn "$HOME/bin не в PATH. Добавь в ~/.bashrc или ~/.zshrc:"
    warn '  export PATH="$HOME/bin:$PATH"'
fi

# API ключ
mkdir -p "$CONF_DIR"
if [[ -f "$CONF_FILE" ]] && grep -q "DEEPSEEK_API_KEY=" "$CONF_FILE" 2>/dev/null; then
    warn "Конфиг уже существует: $CONF_FILE"
    read -rp "Перезаписать? [y/N] " ans </dev/tty
    [[ "$ans" =~ ^[Yy]$ ]] || { info "Установка завершена (ключ не изменён)."; exit 0; }
fi

read -rp "DeepSeek API key (sk-...): " api_key </dev/tty
[[ -z "$api_key" ]] && err "Ключ не введён"

cat > "$CONF_FILE" <<EOF
DEEPSEEK_API_KEY=$api_key
# DEEPSEEK_BASE_URL=https://api.deepseek.com/anthropic
EOF
chmod 600 "$CONF_FILE"

info "Готово! Проверь:"
echo "  claude-deep -p 'Привет, какой сейчас год?'"
