#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-$HOME/.local/share/open-webui-linux}"
OPENAI_API_BASE_URL="${OPENAI_API_BASE_URL:-http://127.0.0.1:8085/v1}"
OPENAI_API_KEY="${OPENAI_API_KEY:-local}"
WEBUI_VENV="${WEBUI_VENV:-$HOME/open-webui-venv}"
LOG_DIR="${LOG_DIR:-$HOME/llm-logs}"

mkdir -p "$LOG_DIR"

if [[ -f "$HOME/.config/llama-launch/brave-search.env" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.config/llama-launch/brave-search.env"
fi

export DATA_DIR
export OPENAI_API_BASE_URL
export OPENAI_API_KEY
export ENABLE_OPENAI_API="True"
export ENABLE_OLLAMA_API="False"
export WEBUI_AUTH="False"

if [[ -n "${BRAVE_SEARCH_API_KEY:-${BRAVE_API_KEY:-}}" ]]; then
    export ENABLE_WEB_SEARCH="True"
    export WEB_SEARCH_ENGINE="brave"
    export WEB_SEARCH_RESULT_COUNT="${WEB_SEARCH_RESULT_COUNT:-5}"
    export WEB_SEARCH_CONCURRENT_REQUESTS="${WEB_SEARCH_CONCURRENT_REQUESTS:-1}"
    export BYPASS_WEB_SEARCH_EMBEDDING_AND_RETRIEVAL="True"
    export BYPASS_WEB_SEARCH_WEB_LOADER="True"
    export BRAVE_SEARCH_API_KEY="${BRAVE_SEARCH_API_KEY:-$BRAVE_API_KEY}"
fi

exec "$WEBUI_VENV/bin/open-webui" serve --host 0.0.0.0 --port 8080 \
  >> "$LOG_DIR/open-webui.log" 2>&1

