# bm — Directory Bookmark Manager

Bookmark directories from the command line and jump between them instantly.

## Features

- Add named bookmarks for any directory
- Jump to bookmarked directories with a single command
- List, search, and remove bookmarks
- Tab completion for bookmark names
- Automatic `cd` on `bm go` — no `cd $(...)` needed
- Persistent storage in `~/.config/bm/bookmarks`

## Install

### From the .deb

```sh
sudo apt install ./bm_*.deb
```

### From source

```sh
sudo apt install debhelper
dpkg-buildpackage -us -uc
sudo apt install ./../bm_*.deb
```

## Usage

```sh
bm add myproject       # bookmark current directory
bm go myproject        # jump to bookmarked directory (cd's automatically)
bm ls                  # list all bookmarks
bm path myproject      # print path without cd
bm del myproject       # remove bookmark
bm help                # show help
```

## Shell Integration

`bm go <name>` changes your directory automatically — no manual `~/.bashrc` edits needed.

| Mechanism | Applies to |
|-----------|------------|
| `/etc/profile.d/bm.sh` | Login shells (SSH, tty, `su -`) |
| `/etc/bash.bashrc` | Non-login shells (most terminals) |

## Building

### With debhelper (recommended)

```sh
sudo apt install debhelper
make build
```

### Without debhelper

```sh
./build.sh
```

Output: `../bm_1.0.0_all.deb`

## Package Structure

```
.
├── bm                    # the CLI tool
├── bm.1                  # man page
├── bm.sh                 # shell function (sourced by profile.d)
├── bash-completion/      # tab completion
├── etc/profile.d/        # login shell integration
└── debian/               # packaging files
```

## License

MIT
