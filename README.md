# m

m is a lightweight tool for working with bookmarks in bash.

## Usage

m uses `$HOME/.config/m/marks` to store bookmarks. Bookmarks can be managed by editing
the marks file in your favorite editor.

### Structure

The structure of `$HOME/.config/m/marks` is very similar to the structure of the hosts
file, `/etc/hosts`. Bookmarks are defined in the format: `<name> <path>`.

**Example**

```
hosts   /etc/hosts
awesome ~/work/projects/awesome
```

### Command-line interface

```console
$ m -h
usage: [OPTIONS...] MARK
  -l    --list      List available marks
  -e    --edit      Edit available marks
  -h    --help      Show this usage summary
  -v    --version   Print version information
```

## Installation

Put [m](https://raw.github.com/KevinSjoberg/m/master/m) in a directory of your
choice. I chose `$HOME/bin/m`. Source it in your `.bash_profile` or `.bashrc` file.

## Alternatives

* [bashmarks](https://github.com/huyng/bashmarks)
