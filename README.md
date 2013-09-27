# m
m is a lightweight tool for working with bookmarks in the terminal.

## Usage
m uses `$HOME/.marks` to store bookmarks. Bookmarks can be managed by editing
the marks file in your favorite editor. m even provide a shortcut for doing
this: `m -e`.

### Structure
The structure of `$HOME/.marks` is very similar to the structure of the hosts
file, `/etc/hosts`. Bookmarks are defined in the format: `<key> <path>`.

**Example**

    hosts   /etc/hosts
    awesome /code/work/projects/awesome

### Command-line interface

    $ m
    Usage:
      m [OPTION] [BOOKMARK]

    General Options:
      -h, --help    Usage
      -l, --list    List bookmarks
      -e, --edit    Edit BOOKMARK with $EDITOR

**Example**

    ~ $ m -l
    hosts   /etc/hosts
    awesome /code/work/projects/awesome
    ~ $ m awesome
    /code/work/projects/awesome $

## Installation

### Homebrew
m can be installed with [Homebrew](http://brew.sh/).

    brew tap KevinSjoberg/formulas
    brew install KevinSjoberg/m

### Manually
Put [m](https://raw.github.com/KevinSjoberg/m/master/m) in a directory of your
choice. I chose `$HOME/bin/m`. Source it via your `$HOME/.bashrc`.

## Alternatives

  * [bashmarks](https://github.com/huyng/bashmarks)
