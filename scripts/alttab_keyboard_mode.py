#!/usr/bin/env python3
"""Switch AltTab's alt+tab / cmd+tab shortcuts between keyboard layouts.

Why: on the Kinesis, the key next to the spacebar is Option (alt). On the
MacBook keyboard it's Command. This script keeps "all apps" on whichever key
sits next to the spacebar.

    Mode                     All apps     Active app only
    home   (Kinesis)         alt+tab      cmd+tab
    travel (laptop keyboard) cmd+tab      alt+tab

How: AltTab stores each shortcut's "hold" key (alt or cmd) in its preferences.
Slot 3 = "all apps", slot 4 = "active app". The script swaps the hold keys of
those two slots. It never builds a shortcut from scratch -- it only moves the
two existing values -- so it can't create a broken shortcut.

The right option / right command remaps are NOT handled here. Karabiner does
those automatically per keyboard (see karabiner.edn, "KEYBOARD-AWARE").

Usage:
    kbmode            toggle between home and travel
    kbmode status     show the current mode (changes nothing)
    kbmode travel     switch to travel mode (laptop keyboard)
    kbmode home       switch to home mode (Kinesis)
"""

import plistlib
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

DOMAIN = "com.lwouis.alt-tab-macos"
APP_NAME = "AltTab"
ALL_APPS_HOLD = "holdShortcut3"     # slot 3: shows all apps
ACTIVE_APP_HOLD = "holdShortcut4"   # slot 4: shows the active app only
BACKUP = Path.home() / ".local/state/kbmode/alttab-backup.plist"

# What the "all apps" hold key looks like in each mode.
ALL_APPS_KEY_FOR_MODE = {"home": "⌥", "travel": "⌘"}
OTHER_MODE = {"home": "travel", "travel": "home"}


def run(*cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def export_prefs():
    """Read AltTab's whole preferences domain into a Python dict."""
    with tempfile.NamedTemporaryFile(suffix=".plist") as f:
        result = run("defaults", "export", DOMAIN, f.name)
        if result.returncode != 0:
            sys.exit(f"Could not read AltTab settings: {result.stderr.strip()}")
        return plistlib.load(open(f.name, "rb"))


def current_mode(prefs):
    key = prefs.get(ALL_APPS_HOLD, {}).get("string")
    for mode, symbol in ALL_APPS_KEY_FOR_MODE.items():
        if key == symbol:
            return mode
    return None


def app_is_running():
    return run("pgrep", "-x", APP_NAME).returncode == 0


def quit_alttab():
    if not app_is_running():
        return
    run("osascript", "-e", f'tell application "{APP_NAME}" to quit')
    for _ in range(50):  # wait up to 5 seconds
        if not app_is_running():
            return
        time.sleep(0.1)
    sys.exit("AltTab didn't quit within 5 seconds. Nothing was changed.")


def main():
    args = sys.argv[1:]
    prefs = export_prefs()
    mode = current_mode(prefs)

    if args and args[0].lower() == "status":
        print(f"Current mode: {mode or 'unknown (shortcuts look hand-edited)'}")
        return

    if args:
        target = args[0].lower()
        if target not in ALL_APPS_KEY_FOR_MODE:
            sys.exit("Usage: kbmode [status|home|travel]  (no argument = toggle)")
    else:
        target = OTHER_MODE.get(mode)  # toggle; None if mode is unknown

    if mode is None:
        sys.exit(
            "AltTab's shortcut 3 hold key isn't alt or cmd, so I can't tell "
            "which mode you're in. Fix it in AltTab's settings first."
        )
    if mode == target:
        print(f"Already in {target} mode. Nothing to do.")
        return

    # Quit first: AltTab keeps settings in memory and could overwrite our
    # change when it quits. Then re-read, in case quitting saved anything.
    quit_alttab()
    prefs = export_prefs()

    BACKUP.parent.mkdir(parents=True, exist_ok=True)
    with open(BACKUP, "wb") as f:
        plistlib.dump(prefs, f)

    prefs[ALL_APPS_HOLD], prefs[ACTIVE_APP_HOLD] = (
        prefs[ACTIVE_APP_HOLD],
        prefs[ALL_APPS_HOLD],
    )

    with tempfile.NamedTemporaryFile(suffix=".plist") as f:
        plistlib.dump(prefs, open(f.name, "wb"))
        result = run("defaults", "import", DOMAIN, f.name)
    if result.returncode != 0:
        run("open", "-a", APP_NAME)
        sys.exit(f"Could not save AltTab settings: {result.stderr.strip()}")

    run("open", "-a", APP_NAME)

    new_mode = current_mode(export_prefs())
    if new_mode != target:
        sys.exit(
            f"Something went wrong: mode is now {new_mode}. "
            f"Restore with: defaults import {DOMAIN} {BACKUP}"
        )

    other = "⌘" if ALL_APPS_KEY_FOR_MODE[target] == "⌥" else "⌥"
    print(
        f"Switched to {target} mode: "
        f"{ALL_APPS_KEY_FOR_MODE[target]}+Tab = all apps, "
        f"{other}+Tab = active app. AltTab restarted."
    )


if __name__ == "__main__":
    main()
