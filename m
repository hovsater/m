#!/bin/sh

m() {
  local marks=~/.marks

  case "$1" in
    ""|"-h"|"--help")
cat <<-USAGE
Usage:
  m [OPTION] [BOOKMARK]

General Options:
  -h, --help    Usage
  -l, --list    List bookmarks
  -e, --edit    Edit BOOKMARK with \$EDITOR
USAGE
    ;;
    "-e"|"--edit")
      if [ -n "$2" ]; then
        local mark=$2
        local mark_dir=$(cat $marks | grep "^$mark" | awk '{print $2}')
      else
        local mark_dir=$marks
      fi

      if [[ -n "$mark_dir" ]]; then
        eval "$EDITOR $mark_dir"
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
      local mark_dir=$(cat $marks | grep "^$mark" | awk '{print $2}' | head -1)

      if [ -n "$mark_dir" ]; then
        eval "cd $mark_dir"
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

if [ $ZSH_VERSION ]; then
  autoload -U compinit && compinit
  autoload -U bashcompinit && bashcompinit
fi

complete -F __m_complete m
