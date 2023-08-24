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
  local bash_aliases_file=~/.bash_aliases

  # Check if the alias is already defined
  if type "$alias_name" >/dev/null 2>&1; then
    if ! alias "$alias_name" >/dev/null 2>&1; then
      echo "Error: '$alias_name' is already defined as a non-alias," $(type "$alias_name")
      return 1
    fi
  fi

  # Check if the alias already exists in the .bash_aliases file
  if grep -q "alias $alias_name=" "$bash_aliases_file"; then
    sed -i "s|alias $alias_name=.*|alias $alias_name='$alias_definition'|" "$bash_aliases_file"
  else
    echo "alias $alias_name='$alias_definition'" >>"$bash_aliases_file"
  fi

  # Define the alias
  alias "$alias_name"="$alias_definition"
  alias "$alias_name"
}

dela() {
  local alias_name="$1"
  sed -i "/alias $alias_name=.*/d" ~/.bash_aliases
  unalias $alias_name
}

alias all='type -a'
alias va='cat ~/.bash_aliases'
alias ea='vim ~/.bash_aliases'
alias vp='cat ~/.bashrc'
alias ep='vim ~/.bashrc'

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
