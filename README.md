# bm

![Build](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Lintian](https://img.shields.io/badge/lintian-clean-brightgreen)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20wsl2-lightgrey)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)

a directory bookmark manager for the command line. bookmark directories and jump between them instantly — no more typing long paths or hunting through `cd ../../..`.

built by Nishanth C

## table of contents

- [install](#install)
- [remove](#remove)
- [what it does](#what-it-does)
- [how it works](#how-it-works)
- [building from source](#building-from-source)
- [requirements](#requirements)
- [file structure](#file-structure)
- [contributing](#contributing)
- [license](#license)

## install

download the latest .deb from releases and run:

```sh
sudo dpkg -i bm_1.0.0_all.deb
```

open a new terminal. start bookmarking:

```sh
bm add myproject       # bookmark current dir
bm go myproject        # jump to bookmarked dir
bm ls                  # list all bookmarks
bm del myproject       # remove bookmark
```

## remove

```sh
sudo dpkg --purge bm
```

open a new terminal. everything is gone — no leftover files, no broken .bashrc.

verify it's fully clean:

```sh
dpkg -l | grep bm                # should return nothing
ls /etc/profile.d/ | grep bm     # should return nothing
grep bm ~/.bashrc                 # should return nothing
which bm                          # should return nothing
```

## what it does

- `bm add <name>` → bookmarks your current directory with a name
- `bm go <name>` → jumps to a bookmarked directory (cd's automatically)
- `bm ls` → lists all bookmarks with their paths
- `bm path <name>` → prints the path of a bookmark without changing directory
- `bm del <name>` → removes a bookmark
- `bm help` → shows usage

shell integration is automatic — `bm go` runs `cd` in your current shell. login shells load via `/etc/profile.d/bm.sh`, non-login shells are wired through `/etc/bash.bashrc` at install time. no manual `~/.bashrc` edits needed.

bash completion is included — tab completes bookmark names on `go`, `del`, `rm`, and `path`.

man page available — `man bm` for full documentation.

## how it works

bookmarks are stored as `name=path` pairs in `~/.config/bm/bookmarks`:

```
docs=/home/user/projects/docs
config=/etc/nginx
```

the `bm` binary works like any other command. the shell function wraps it — when you run `bm go`, the function intercepts it, calls `command bm path` to get the path, and runs `builtin cd` in your shell. a child process can't change its parent's directory, so the function is the only way `cd` works.

the package wires itself into your shell at install time via `postinst`. `prerm` removes the wiring on uninstall. no hand-editing shell configs.

## building from source

clone the repo and build:

```sh
git clone https://github.com/Nishanthc08/bookmark-manager
cd bookmark-manager
bash build.sh
```

or using make:

```sh
make build       # build the .deb
make clean       # remove build artifacts
```

verify the built package:

```sh
dpkg-deb --info ../bm_1.0.0_all.deb
dpkg-deb --contents ../bm_1.0.0_all.deb
lintian --profile debian ../bm_1.0.0_all.deb
```

updating the version — edit `debian/changelog`, `debian/control`, and `build.sh` before building:

```
Version: 1.1
```

## requirements

- Ubuntu 18.04+ or any Debian-based system
- bash 4.0+ (pre-installed on all modern Ubuntu/Debian)
- no other dependencies

works on WSL2. does not work on macOS — macOS ships with bash 3.2 which is too old.

## file structure

```
bookmark-manager/
├── bm                    ← the CLI tool. this is what runs
├── bm.1                  ← man page source
├── bm.sh                 ← shell function for cd. sourced by profile.d
├── build.sh              ← builds the .deb from source
├── Makefile              ← make build / clean
├── INSTALL               ← plain text install instructions
├── bash-completion/
│   └── bm                ← tab completion for bookmark names
├── etc/
│   └── profile.d/
│       └── bm.sh         ← login shell auto-load
├── debian/
│   ├── control           ← package name, version, maintainer, description
│   ├── changelog         ← version history in Debian format
│   ├── copyright         ← MIT license in DEP-5 machine-readable format
│   ├── compat            ← debhelper compatibility level
│   ├── rules             ← build instructions for dpkg-buildpackage
│   ├── install           ← declares which files install where
│   ├── manpages          ← tells debhelper about the man page
│   ├── docs              ← tells debhelper which docs to install
│   ├── conffiles         ← marks profile.d script as conffile
│   ├── postinst          ← runs after install, wires into /etc/bash.bashrc
│   ├── prerm             ← runs before removal, cleans /etc/bash.bashrc
│   ├── source/
│   │   ├── format        ← declares 3.0 (native) source format
│   │   └── options       ← excludes files from source tarball
│   └── tests/
│       ├── control       ← autopkgtest test declarations
│       └── basic-smoke   ← verifies binary, man page, and shell file
├── .github/
│   ├── workflows/
│   │   └── build.yml     ← CI: build, lint, attach to release
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── PULL_REQUEST_TEMPLATE.md
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── DOCUMENTATION.md       ← detailed technical documentation
├── ROADMAP.md
├── SECURITY.md
├── SUPPORT.md
└── LICENSE
```

## contributing

see [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute code. see [ROADMAP.md](ROADMAP.md) for what is planned.

## license

MIT — do whatever you want with it, fork it, redistribute, modify.

bookmark your directories, not your path — written for everyone who lives in the terminal.
