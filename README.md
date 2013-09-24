# m
m is a lightweight tool for using marks in
[bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell\)).


## Usage
m uses `$HOME/.marks` to store marks. Marks are managed by editing this file in
your favorite editor.

**File structure**

    hosts   /etc/hosts
    awesome /code/work/projects/awesome

**Command-line interface**

    $ m
    Usage:
      m [OPTION] [MARK]

    General Options:
      -e, --edit    Edit mark with $EDITOR
      -h, --help    Usage
      -l, --list    List marks

## Installation
Put [m](https://raw.github.com/KevinSjoberg/m/master/m) in a directory of your
choice. I chose `$HOME/bin/m`. Source it via your `$HOME/.bashrc`.

## Alternatives

  * [bashmarks](https://github.com/huyng/bashmarks)
