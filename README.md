# bm — Directory Bookmark Manager

Bookmark directories from the command line and jump between them instantly.

## Quick Start

```sh
# Build the package
sudo apt install debhelper
dpkg-buildpackage -us -uc

# Install
sudo apt install ./../bm_*.deb

# Use it
bm add myproject       # bookmark current dir
bm go myproject        # jump to bookmarked dir
bm ls                  # list bookmarks
bm del myproject       # remove bookmark
```

## Shell Integration

By default `bm go <name>` prints the path — you need `cd $(bm go name)`.
After installing the package, `bm go <name>` directly changes your directory
(uses `cd` automatically) — no manual setup needed.

Login shells auto-load via `/etc/profile.d/bm.sh`.
Non-login shells are wired through `/etc/bash.bashrc` during install.

## Commands

| Command | Description |
|---------|-------------|
| `bm add <name>` | Bookmark current directory as `<name>` |
| `bm go <name>` | Jump to bookmarked directory (with shell integration) |
| `bm list` / `bm ls` | List all bookmarks |
| `bm del <name>` / `bm rm <name>` | Remove a bookmark |
| `bm path <name>` | Print path of a bookmark |
| `bm help` | Show help |

## License

MIT
