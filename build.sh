#!/usr/bin/env bash
# Build script for bm package
# Works with or without debhelper installed
set -euo pipefail

if command -v dh &>/dev/null; then
  # Proper Debian build with debhelper
  dpkg-buildpackage -us -uc
else
  # Manual build (debhelper not available)
  echo "debhelper not found, using manual build..."
  DEB=bm_1.0.0_all.deb
  DEST=debian/bm

  rm -rf "$DEST" "../$DEB" "../bm_1.0.0"*".buildinfo" "../bm_1.0.0"*".changes"

  install -d "$DEST/DEBIAN" "$DEST/usr/bin" "$DEST/usr/share/man/man1"
  install -d "$DEST/usr/share/bash-completion/completions" "$DEST/usr/share/doc/bm" "$DEST/usr/share/bm"
  install -d "$DEST/etc/profile.d"

  install -m 755 bm "$DEST/usr/bin/"
  install -m 644 bm.1 "$DEST/usr/share/man/man1/"
  gzip -9n "$DEST/usr/share/man/man1/bm.1"
  install -m 644 bash-completion/bm "$DEST/usr/share/bash-completion/completions/"
  install -m 644 bm.sh "$DEST/usr/share/bm/"
  install -m 644 etc/profile.d/bm.sh "$DEST/etc/profile.d/"
  install -m 644 debian/changelog "$DEST/usr/share/doc/bm/changelog"
  install -m 644 debian/copyright "$DEST/usr/share/doc/bm/"
  gzip -9n "$DEST/usr/share/doc/bm/changelog"

  cp debian/postinst "$DEST/DEBIAN/"
  cp debian/prerm "$DEST/DEBIAN/"
  cp debian/conffiles "$DEST/DEBIAN/"

  dpkg-gencontrol -P"$DEST"
  dpkg-deb --root-owner-group --build "$DEST" ..

  echo "Built: ../$DEB"
fi
