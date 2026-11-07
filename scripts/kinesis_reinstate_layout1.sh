#!/usr/bin/env bash
# Reinstate the standard Mac layout onto Kinesis layout 1.
#
# Copies the layout file kept in ~/.dotfiles/secrets/ onto the Kinesis
# keyboard's drive as layout1.txt, replacing whatever is there.
# The keyboard's drive must be mounted ("FS PRO" -- put the keyboard in
# v-drive mode first).
#
# Run from Alfred with the keyword 'layout'.
set -euo pipefail

SRC="$HOME/.dotfiles/secrets/standard_kinesis_mac_layout_2026.08.03.txt"
TARGET_DIR="/Volumes/FS PRO/layouts"
TARGET="$TARGET_DIR/layout1.txt"
TMP="$TARGET_DIR/.layout1.txt.tmp"

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file not found: $SRC" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Kinesis drive not mounted (looked for $TARGET_DIR)" >&2
  exit 1
fi

# 1. Copy the source onto the keyboard's drive under a temporary name.
#    If this fails (drive full, unplugged), the existing layout1.txt is untouched.
cp "$SRC" "$TMP"

# 2. Swap it into place. mv replaces layout1.txt in one step, so there's
#    never a moment where layout1.txt is missing.
mv -f "$TMP" "$TARGET"

echo "Kinesis layout 1 reinstated from $(basename "$SRC")"
