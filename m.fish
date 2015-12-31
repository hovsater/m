#!/bin/sh
set -U MARKS_FILE $HOME/.marks

function m
  if test -n $argv[1];
    switch $argv[1]
      case "-h" "--help"
        __m_print_usage -h
      case "-e" "--edit"
        __m_edit_mark
      case "-l" "--list"
        __m_list_marks
      case "-p" "--print"
        __m_print_mark $argv[2]
      case "-s" "--save"
        __m_save_mark  $argv[2]
      case "-d" "--delete"
        __m_delete_mark $argv[2]
      case '*'
        __m_use_mark $argv[1]
    end
  else
    __m_print_usage -h
  end
end

function __m_edit_mark --description "edit marks file"
  set -l path $MARKS_FILE

  if begin; test (count $argv) -gt 1; and test -d $argv[2]; end
    set -l mark $argv[2]
    set -l path (__m_mark_destination $mark)
  end

  if test -f $path;
    eval $EDITOR $path
  else if test -d $path;
    eval $EDITOR $path
  else
    echo "No mark named: $mark"
    return 1
  end
end

function __m_use_mark --description "Go to (cd) to the directory associated with a mark"
  if [ (count $argv) -lt 1 ]
    echo -e "\033[0;31mERROR: '' mark does not exist\033[00m"
    return 1
  end

  if not __m_print_usage $argv[1];
    cat $MARKS_FILE | sed -r "s/^(\w+) /set -x DIR_\1 /" | .
    set -l target (env | grep "^DIR_$argv[1]=" | cut -f2 -d "=")

    if [ ! -n "$target" ]
      echo -e "\033[0;31mERROR: mark '$argv[1]' does not exist\033[00m"
      return 1
    end

    if [ -d "$target" ]
      cd "$target"
      return 0
    else
      echo -e "\033[0;31mERROR: '$target' does not exist\033[00m"
      return 1
    end
  end
end

function __m_save_mark --description "Save the current directory as a mark"
  set -l bn $argv[1]
  if [ (count $argv) -lt 1 ]
    set bn (basename (pwd))
  end

  if not echo $bn | grep -q "^[a-zA-Z0-9_]*\$";
    echo -e "\033[0;31mERROR: Mark names may only contain alphanumeric characters and underscores.\033[00m"
    return 1
  end

  if __m_valid_mark $bn;
    sed -i='' "/$bn /d" $MARKS_FILE
  end

  set -l pwd (pwd | sed "s#^$HOME#\$HOME#g")
  echo "$bn \"$pwd\"" >> $MARKS_FILE

  __m_update_completions
  return 0
end

function __m_print_mark --description "Print the directory associated with a mark"
  if [ (count $argv) -lt 1 ]
    echo -e "\033[0;31mERROR: mark name required\033[00m"
    return 1
  end
  if not __m_print_usage $argv[1];
    cat $MARKS_FILE | sed -r "s/^(\w+) /set -x DIR_\1 /" | .
    env | grep "^DIR_$argv[1]=" | cut -f2 -d "="
  else
    echo 'FUCK'
  end
end

function __m_delete_mark --description "Delete a bookmark"
  if [ (count $argv) -lt 1 ]
    echo -e "\033[0;31mERROR: bookmark name required\033[00m"
    return 1
  end
  if not _valid_bookmark $argv[1];
    echo -e "\033[0;31mERROR: bookmark '$argv[1]' does not exist\033[00m"
    return 1
  else
    sed -i='' "/$argv[1] /d" $MARKS_FILE
    __m_update_completions
  end
end

function __m_list_marks --description "List all available marks"
  if not __m_print_usage $argv[1];
    cat $MARKS_FILE | sed -r "s/^(\w+) /set -x DIR_\1 /" | .
    env | sort | awk '/DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'
  end
end

function __m_print_usage
  if [ (count $argv) -lt 1 ]
    return 1
  end

  if begin; [ "-h" = $argv[1] ]; or [ "-help" = $argv[1] ]; or [ "--help" = $argv[1] ]; end
    cat '
Usage:
  m [OPTION] [BOOKMARK]

General Options:
  -h, --help                   - Usage
  -l, --list                   - List marks
  -e, --edit                   - Edit BOOKMARK with \$EDITOR
  -s, --save   <mark_name> - Saves the current directory as "mark_name"
  -p, --print  <mark_name> - Prints the directory associated with "mark_name"
  -d, --delete <mark_name> - Deletes the mark
  <mark_name>              - Goes (cd) to the directory associated with "mark_name"'
    return 0
  end

  return 1
end

function __m_valid_mark
  if begin; [ (count $argv) -lt 1 ]; or not [ -n $argv[1] ]; end
    return 1
  else
    cat $MARKS_FILE | sed -r "s/^(\w+) /set -x DIR_\1 /" | .
    set -l mark (env | grep "^DIR_$argv[1]=" | cut -f1 -d "=" | cut -f2 -d "_")
    if begin; not [ -n "$mark" ]; or not [ $mark=$argv[1] ]; end
      return 1
    else
      return 0
    end
  end
end

function __m_update_completions
    env | grep "^DIR_" | cut -f1 -d "=" | sed "s/^/ set -e /" | .
    cat $MARKS_FILE | sed -r "s/^(\w+) /set -x DIR_\1 /" | .
    set -x _marks (env | grep "^DIR_" | sed "s/^DIR_//" | cut -f1 -d "=" | tr '\n' ' ')
    complete -c __m_print_mark -a $_marks -f
    complete -c __m_delete_mark -a $_marks -f
    complete -c __m_use_mark -a $_marks -f
    complete -c m -a $_marks -f
    if not set -q NO_FISHMARKS_COMPAT_ALIASES
        complete -c p -a $_marks -f
        complete -c d -a $_marks -f
        complete -c g -a $_marks -f
    end
end
__m_update_completions
