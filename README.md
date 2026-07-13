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
bm add myproject     # bookmark current dir
cd $(bm go myproject)  # jump to bookmarked dir
bm ls                  # list bookmarks
bm del myproject       # remove bookmark
```

## Commands

| Command | Description |
|---------|-------------|
| `bm add <name>` | Bookmark current directory as `<name>` |
| `bm go <name>` | Print path of bookmark (use with `cd $()`) |
| `bm list` / `bm ls` | List all bookmarks |
| `bm del <name>` / `bm rm <name>` | Remove a bookmark |
| `bm path <name>` | Print path of a bookmark |
| `bm help` | Show help |

## License

MIT
