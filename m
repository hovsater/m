#!/bin/sh

m() {
  local marks=~/.marks

  case "$1" in
    ""|"-h"|"--help")
cat <<-USAGE
Usage:
  m [MARK]

General Options:
  -e, --edit    Edit mark with \$EDITOR
  -h, --help    Usage
  -l, --list    List marks
USAGE
    ;;
    "-e"|"--edit")
      local mark=$2
      local path=$(cat $marks | grep "^$mark" | awk '{print $2}')

      if [[ -n "$path" ]]; then
        eval "$EDITOR $path"
      else
        echo "No mark named: $mark"
        return 1
      fi
    ;;
    "-l"|"--list")
      cat $marks
    ;;
    *)
      local mark=$1
      local path=$(cat $marks | grep "^$mark" | awk '{print $2}')

      if [ -n "$path" ]; then
        eval "cd $path"
      else
        echo "No mark named: $mark"
        return 1
      fi
    ;;
  esac
}

__m_complete() {
  local cur
  local marks

  cur=${COMP_WORDS[COMP_CWORD]}
  marks=$(m -l | awk '{print $1}')

  COMPREPLY={}
  COMPREPLY=($(compgen -W "$marks" -- $cur))

  return 0
}

complete -F __m_complete m
