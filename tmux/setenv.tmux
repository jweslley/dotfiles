#!/usr/bin/env bash

if [ -z "$OPENAI_API_KEY" ]; then
  tmux setenv -g OPENAI_API_KEY "$(op read op://private/OpenAI/api_key --no-newline)"
fi
