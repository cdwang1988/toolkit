#!/bin/bash
#
# Download the file using the following command:
# ```
# curl -o ~/.edenrc https://raw.githubusercontent.com/cdwang1988/toolkit/main/envsetup.sh
# ```
#
# And add the following statement to the `~/.bashrc` or `~/.bash_profile`:
# ```
# if [ -f ~/.edenrc ]; then
#   source ~/.edenrc
# fi
# ```

export EDEN_RC=~/.edenrc
export EDEN_ALIASES=~/.eden_aliases

gitroot() {
  local dir="$PWD"
  local git_dir="$(git rev-parse --show-toplevel 2>/dev/null)"

  while [ -n "$git_dir" ]; do
    dir="$git_dir"
    git_dir="$(cd "$(dirname "$git_dir")" && git rev-parse --show-toplevel 2>/dev/null)"
  done

  echo "$dir"
}

defa() {
  local alias_name="$1"
  local alias_definition="$2"

  # Check if the alias is already defined
  if type "$alias_name" >/dev/null 2>&1; then
    if ! alias "$alias_name" >/dev/null 2>&1; then
      echo "Error: '$alias_name' is already defined as a non-alias," $(type "$alias_name")
      return 1
    fi
  fi

  # Check if the alias already exists in the .eden_aliases file
  touch "$EDEN_ALIASES"
  if grep -q "alias $alias_name=" "$EDEN_ALIASES"; then
    sed -i "s|alias $alias_name=.*|alias $alias_name='$alias_definition'|" "$EDEN_ALIASES"
  else
    echo "alias $alias_name='$alias_definition'" >>"$EDEN_ALIASES"
  fi

  # Define the alias
  alias "$alias_name"="$alias_definition"
  alias "$alias_name"
}

dela() {
  local alias_name="$1"
  sed -i "/alias $alias_name=.*/d" "$EDEN_ALIASES"
  unalias $alias_name
}

alias all='type -a'
alias va='cat "$EDEN_ALIASES"'
alias ea='vim "$EDEN_ALIASES"'
alias vp='cat "$EDEN_RC"'
alias ep='vim "$EDEN_RC"'

if [ -f "$EDEN_ALIASES" ]; then
  source "$EDEN_ALIASES"
fi
