# Contributing to bm

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-idea`)
3. Make your changes
4. Run `bash build.sh` to verify the package builds
5. Run `lintian --profile debian ../bm_*.deb` to check for issues
6. Commit and push
7. Open a Pull Request

## What to Work On

See [ROADMAP.md](ROADMAP.md) for planned features. Feel free to suggest new ones.

## Code Style

- Bash 4.0+ with `set -euo pipefail`
- 2-space indentation
- Comments for non-obvious logic
- Keep functions small and focused

## Packaging

- Update `debian/changelog` for new releases
- Bump version in `build.sh` and `debian/control`
- Keep lintian clean
