#!/usr/bin/env bash
set -euo pipefail

SRC="/Volumes/FS PRO/layouts/seans_other_backups/layout2_copy_2026.08.03.txt"
STAGED="$(dirname "$SRC")/layout2.txt"
TARGET_DIR="/Volumes/FS PRO/layouts"
TARGET="$TARGET_DIR/layout2.txt"

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file not found: $SRC" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: target directory not found: $TARGET_DIR" >&2
  exit 1
fi

# 1. Copy the backup and rename it to layout2.txt
if [[ -e "$STAGED" && "${FORCE:-0}" != "1" ]]; then
  echo "Error: staging file already exists: $STAGED" >&2
  echo "Remove it first, or re-run with FORCE=1 to overwrite." >&2
  exit 1
fi
cp -p "$SRC" "$STAGED"
echo "Copied to: $STAGED"

# 2. Delete the existing layout2.txt in the parent directory
if [[ -e "$TARGET" ]]; then
  rm -f "$TARGET"
  echo "Deleted: $TARGET"
else
  echo "Note: no existing file at $TARGET — nothing to delete."
fi

# 3. Move the new layout2.txt into the parent directory
mv "$STAGED" "$TARGET"
echo "Moved into place: $TARGET"
