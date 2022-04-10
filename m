#!/usr/bin/env bash

function m() {
  local marks="$HOME/.config/m/marks"
  local version="0.0.1"

  # Create "$HOME/.config/m/marks" if it doesn't exist.
  if ! [[ -f "$marks" ]]; then
    mkdir -p "$(dirname "$marks")"
    touch "$marks"
  fi

  case "$1" in
    ""|"-h"|"--help")
	cat <<-HELP
	usage: [OPTIONS...] MARK
	  -l --list	List available marks
	  -e --edit	Edit available marks
	  -h --help	Show this usage summary
	  -v --version	Print version information
	HELP
      ;;
    "-l"|"--list")
      cat "$marks"
      ;;
    "-e"|"--edit")
      if [[ -n "$EDITOR" ]]; then
        $EDITOR "$marks"
      else
        echo "m: \$EDITOR not defined. Please set it and try again."
        return 1
      fi
      ;;
    "-v"|"--version")
      echo "$version"
      ;;
    *)
      read -r mark_name mark_path < <(grep "^$1 " "$marks")

      # Ensure that we got a match back
      if [[ -n "$mark_name" ]]; then
        # Expand tilde to the home directory.
        mark_path=${mark_path/#\~/$HOME}

        if [[ -d "$mark_path" ]]; then
          cd "$mark_path" || return
        elif [[ -f "$mark_path" ]]; then
          $EDITOR "$mark_path"
        else
          echo "m: $mark_path is not a directory/file"
          return 1
        fi
      else
        echo "m: mark $1 does not exist"
        return 1
      fi
      ;;
  esac
}

_m_completion() {
  local marks

  marks=$(m -l | cut -d ' ' -f1)
  COMPREPLY=($(compgen -W "$marks" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _m_completion m
