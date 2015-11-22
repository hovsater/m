#!/bin/sh
set -U marks_file $HOME/.marks

function __m_print_usage  --description "prints usage instructions"
  cat '
  Usage:
    m [OPTION] [BOOKMARK]

  General Options:
    -h, --help    Usage
    -l, --list    List bookmarks
    -e, --edit    Edit BOOKMARK with \$EDITOR
  '
end

function __m_edit_mark --description "edit marks file"
  set -l path $marks_file

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

function __m_list_marks --description "lists all marks"
  cat $marks_file
end

function __m_use_mark --description "navigates to the mark"
  if test ! -n $argv[1]
    echo "Need a mark to navigate to"
    return 1
  end
  set -l path (__m_mark_destination $argv[1])

  if test -n "$path";
    eval cd $path
  else
    echo "Directory $path does not exist"
    return 1
  end
end

function __m_mark_destination --description "returns a destination path for the mark"
  echo (cat $marks_file | grep "^$argv[1]" | awk '{print $2}')
end

function m
  if test -n $argv[1];
    switch $argv[1]
      case "-h" "--help"
        __m_print_usage
      case "-e" "--edit"
        __m_edit_mark
      case "-l" "--list"
        __m_list_marks
      case '*'
        __m_use_mark $argv[1]
    end
  else
    __m_print_usage
  end
end

function __m_mark_names
  echo (m -l | awk '{print $1}')
end

function __m_complete
  set -l cur $COMP_WORDS[$COMP_CWORD]
  set -l marks (__m_mark_names)
  set -g COMPREPLY (complete -C $cur -- $marks)
  echo $COMPREPLY
  return 0
end

complete -f -c m -w __m_complete -a (__m_mark_names)
