# bm — Directory Bookmark Manager — Detailed Documentation

## Overview

bm is a command-line directory bookmark manager packaged as a proper Debian `.deb` package.
It lets you name and save any directory, then jump to it instantly from anywhere in the
terminal. It follows the Debian packaging standard (source format 3.0 native) and ships
with shell integration, bash completion, a man page, and maintainer scripts.

---

## 1. Problem

Linux users working across multiple projects spend time typing long `cd` paths or setting
temporary aliases that don't persist. Existing solutions like `z`, `fasd`, or `autojump`
are powerful but rely on frequency heuristics and can be unpredictable. bm is explicit:
you choose the name, you get the path.

---

## 2. How It Works

### 2.1 The CLI Tool (`bm`)

A bash script at `/usr/bin/bm`. It stores bookmarks as key=value pairs in a plain text
file at `~/.config/bm/bookmarks`.

**Commands:**

| Command | Action |
|---------|--------|
| `bm add <name>` | Saves current working directory as `<name>` |
| `bm go <name>` | Prints the bookmarked path (or jumps with shell integration) |
| `bm list` / `bm ls` | Lists all bookmarks with paths |
| `bm del <name>` / `bm rm <name>` | Removes a bookmark |
| `bm path <name>` | Prints the bookmarked path (same as go without cd) |
| `bm help` | Shows usage |

**Data format (`~/.config/bm/bookmarks`):**

```
docs=/home/user/projects/docs
config=/etc/nginx
logs=/var/log/nginx
```

### 2.2 Shell Integration (`bm.sh`)

A bash function at `/usr/share/bm/bm.sh`. When sourced, it wraps the `bm` command so
that `bm go <name>` runs `cd` directly in your current shell.

```bash
bm() {
  if [[ "$1" == "go" ]] && [[ -n "${2:-}" ]]; then
    local dir
    dir=$(command bm path "$2") || return $?
    if [[ -d "$dir" ]]; then
      builtin cd "$dir"
    fi
  else
    command bm "$@"
  fi
}
```

This is necessary because a child process (the `bm` script) cannot change the parent
shell's working directory. The function intercepts `go` at the shell level and runs
`builtin cd` instead.

### 2.3 Bash Completion (`/usr/share/bash-completion/completions/bm`)

Provides tab completion for bookmark names on `bm go`, `bm del`, `bm rm`, and `bm path`.
Reads completion candidates directly from `~/.config/bm/bookmarks`.

---

## 3. Automatic Shell Activation

The package activates itself at install time — no manual `~/.bashrc` edits.

### 3.1 Login Shells

File: `/etc/profile.d/bm.sh`

Sourced by `/etc/profile` for all login shells (SSH, tty, `su -`, `sudo -i`).

```bash
if [ -f /usr/share/bm/bm.sh ]; then
  . /usr/share/bm/bm.sh
fi
```

### 3.2 Non-Login Shells

The `postinst` maintainer script appends a sourcing block to `/etc/bash.bashrc`. This
covers interactive non-login shells, which is what most GUI terminal emulators (GNOME
Terminal, Konsole, xterm, etc.) start as.

Block added to `/etc/bash.bashrc`:

```bash
# BEGIN bm shell integration
if [ -f /usr/share/bm/bm.sh ]; then
  . /usr/share/bm/bm.sh
fi
# END bm shell integration
```

### 3.3 Clean Removal

The `prerm` maintainer script removes this block on `apt remove` or `apt purge`:

```bash
sed -i '/^# BEGIN bm shell integration$/,/^# END bm shell integration$/d' /etc/bash.bashrc
```

---

## 4. Package Structure

### 4.1 Source Format

`3.0 (native)` — used because bm has no separate upstream; it's a Debian-native package.

### 4.2 Files

| File | Install Path | Purpose |
|------|-------------|---------|
| `bm` | `/usr/bin/bm` | CLI tool |
| `bm.1` | `/usr/share/man/man1/bm.1.gz` | Man page |
| `bm.sh` | `/usr/share/bm/bm.sh` | Shell function for cd |
| `bash-completion/bm` | `/usr/share/bash-completion/completions/bm` | Tab completion |
| `etc/profile.d/bm.sh` | `/etc/profile.d/bm.sh` | Login shell auto-load |
| `debian/changelog` | `/usr/share/doc/bm/changelog.gz` | Change log |
| `debian/copyright` | `/usr/share/doc/bm/copyright` | License |

### 4.3 Debian Packaging Files

| File | Purpose |
|------|---------|
| `debian/control` | Source and binary package metadata |
| `debian/changelog` | Version history (`bm (1.0.0)`) |
| `debian/rules` | Build recipe — uses `dh $@` |
| `debian/compat` | Debhelper compatibility level (13) |
| `debian/install` | Maps source files to install destinations |
| `debian/copyright` | DEP-5 format, MIT license |
| `debian/source/format` | `3.0 (native)` |
| `debian/conffiles` | Marks `/etc/profile.d/bm.sh` as conffile |
| `debian/postinst` | Post-install: wires into `/etc/bash.bashrc` |
| `debian/prerm` | Pre-remove: cleans up `/etc/bash.bashrc` |

---

## 5. Build Process

### 5.1 With debhelper (standard)

```sh
sudo apt install debhelper
make build
```

Equivalent to `dpkg-buildpackage -us -uc`. Produces:

- `bm_1.0.0_all.deb` — binary package
- `bm_1.0.0.dsc` — source package signature
- `bm_1.0.0.tar.xz` — source tarball
- `bm_1.0.0_amd64.buildinfo` — build environment
- `bm_1.0.0_amd64.changes` — upload metadata

### 5.2 Without debhelper

```sh
./build.sh
```

A self-contained bash script that replicates what debhelper does: creates `debian/bm/`,
installs all files with correct permissions and ownership, runs `dpkg-gencontrol` for
control file generation, and builds with `dpkg-deb --root-owner-group`.

### 5.3 `debian/rules`

```makefile
#!/usr/bin/make -f
%:
    dh $@

override_dh_auto_build:
override_dh_auto_clean:
override_dh_auto_test:
```

Empty overrides because there's nothing to compile. The `dh_install` step reads
`debian/install` and places files accordingly. The file is kept canonical for
Debian maintainer workflow compatibility.

---

## 6. Quality

- **lintian**: Zero errors, zero warnings
- **Dependencies**: Only `bash (>= 4.0)` (for `set -euo pipefail`)
- **Storage**: Single plain text file at `~/.config/bm/bookmarks`
- **Persistence**: Survives reboots, sessions, and terminal restarts
- **Permissions**: No root required for runtime; package needs root only for install

---

## 7. Git Workflow

Branch: `main`, with remote at `github.com:Nishanthc08/bookmark-manager`.

Commit history (chronological):

```
24f10b6 Initial release: bm 1.0.0
4d867a8 updations
8761795 restructure: move bm script to repo root, clean up build artifacts
3901800 feat: add automatic shell integration for bm go cd behavior
c159389 docs: overhaul README with features, usage, build instructions
```

---

## 8. Roadmap

- zsh completion support
- `bm rename` command
- Fuzzy search (`bm go fuzzy-partial-match`)
- Export/import bookmarks across machines
- GitHub Actions workflow for auto-build on tag
