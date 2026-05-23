# claude-deep

Claude Code wrapper for DeepSeek API.

Запускает `claude` с DeepSeek-моделями вместо Anthropic:
- **deepseek-v4-pro** — основной агент (Opus/Sonnet tier)
- **deepseek-v4-flash-no-reasoner** — субагенты и Haiku-задачи

## Установка

```bash
curl -fsSL https://raw.githubusercontent.com/ansafonov/claude-deep/main/install.sh | bash
```

Скрипт спросит DeepSeek API key и сохранит в `~/.config/claude-deep/env`.

**Требования:** `python3`, `claude` (Claude Code CLI)

## Использование

```bash
claude-deep                    # интерактивный режим
claude-deep -p "вопрос"        # одиночный запрос
```

## Конфиг

`~/.config/claude-deep/env`:

```bash
DEEPSEEK_API_KEY=sk-...
# DEEPSEEK_BASE_URL=https://api.deepseek.com/anthropic  # по умолчанию
```
