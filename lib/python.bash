#!/bin/sh

# python development

# Miniconda3 4.5.12 installer
__conda_setup="$(CONDA_REPORT_ERRORS=false '$HOME/tools/miniconda/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
  \eval "$__conda_setup"
else
  if [ -f "$HOME/tools/miniconda/etc/profile.d/conda.sh" ]; then
    . "$HOME/tools/miniconda/etc/profile.d/conda.sh"
    CONDA_CHANGEPS1=false conda activate base
  else
    \export PATH="$HOME/tools/miniconda/bin:$PATH"
  fi
fi
unset __conda_setup
