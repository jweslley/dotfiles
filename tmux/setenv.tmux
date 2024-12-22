#!/usr/bin/env bash

if [ -z "$OPENAI_API_KEY" ]; then
  tmux setenv -g OPENAI_API_KEY "$(op read op://private/OpenAI/api_key --no-newline)"
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
  tmux setenv -g ANTHROPIC_API_KEY "$(op read op://private/ClaudeAI/api_key --no-newline)"
fi

if [ -z "$LANGUAGETOOL_USERNAME" ]; then
  tmux setenv -g LANGUAGETOOL_USERNAME "$(op read op://private/LanguageTool/username --no-newline)"
fi

if [ -z "$LANGUAGETOOL_API_KEY" ]; then
  tmux setenv -g LANGUAGETOOL_API_KEY "$(op read op://private/LanguageTool/api_key --no-newline)"
fi
