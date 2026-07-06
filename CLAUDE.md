# Dotfiles

## Troubleshooting

### Hyper key (caps lock) suddenly stops working — all Karabiner remaps dead

**Symptom:** Holding caps lock + a layer key (e.g. caps+w, then h/j/l/i) does nothing — the key just types literally (caps+w types "w"). Affects the *whole* hyper layer, not one chord. Hammerspoon reloads, `goku` recompiles, and Karabiner restarts do **not** fix it.

**Root cause (seen 2026-06-24):** A Karabiner-Elements major update (→ v16.0.0) silently dropped macOS permissions / left the privileged **grabber daemon** unable to read the keyboard. The config (`karabiner.edn` → `karabiner.json`) is fine — this is a macOS permission/daemon problem, not a dotfiles problem.

**Where the chord actually runs (not Hammerspoon):** Karabiner-Elements intercepts caps+w+key → sends e.g. ⌘F9/⌘F10 → **Rectangle Pro** moves the window. Hammerspoon only recompiles the `.edn` via `goku`; it does not run the chord. So "I reloaded Hammerspoon" is a red herring.

**Diagnosis checklist (in order):**

1. Confirm config is loaded: selected profile in `~/.config/karabiner/karabiner.json` contains the rules (first rule = "CAPS LOCK - HYPER KEY").
2. Check Input Monitoring grants: `sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "SELECT client, auth_value FROM access WHERE service='kTCCServiceListenEvent';"` — **`org.pqrs.Karabiner-Core-Service` must be present and = 2**. If it's missing, that's the bug.
3. Check the privileged grabber daemon is running: `ps aux | grep -iE "karabiner_grabber|Karabiner-Core-Service" | grep -v grep`. If absent, the daemon isn't grabbing → no Input Monitoring prompt ever fires.
4. Check daemon log for the loop: `tail ~/.local/share/karabiner/log/core_service.log` — repeated `connect_failed: Permission denied` confirms it.

**Fix that worked:**

1. Ensure Karabiner is approved under **System Settings → General → Login Items & Extensions → Allow in the Background**.
2. Ensure **Karabiner-Core-Service** is enabled in **Input Monitoring** AND **Accessibility** (the `+` button often adds the wrong bundle — the Settings UI app, not Core-Service — so verify with the `sqlite3` query above).
3. **Reboot.** A `brew reinstall --cask karabiner-elements` alone does NOT fix it (only swaps files; doesn't restart the system daemon or re-fire permission prompts). The reboot is what lets the grabber daemon start clean and request Input Monitoring.

**Also check the Kinesis keyboard layout.** If the hyper layer still misbehaves after the daemon and permissions are confirmed healthy, verify the active hardware layout on the Kinesis Freestyle Pro itself — the physical key positions Karabiner sees depend on which onboard layout is selected. As of 2026-06-25, the intended layout was **layout 2**.

## To Do

### BTT

1. When switching between windows, it might seem like it selects the next window but doesn't actually. Happens specifically when in an insert mode (e.g. Notes open in Firefox, or a terminal window with Claude running).
2. Doesn't appropriately select windows with right Shift + x for Excel — even though you select one, it doesn't actually become active. Maybe related to insert mode?
3. When any key other than the current app-switcher key is pressed, stop the current switcher and allow switching to another.
4. Use right shift + o to cycle through non-otherwise-specified apps.
5. Figure out a way for BTT script to be in dotfiles for consistency.

**Note**: . Gemini and GPT said that it was not possible for the BTT Window switcher to show up on every monitor.

### Alt-Tab

1. Implement a fix to go forward and back with .
2. Find better shortcut for tab creation and tab closing — hyper+t/w conflict with alt-tab.

### Alfred

1. The shortcut to go to a specific tab brings all windows to the front.
2. Fix Alfred not showing same options as standard Spotlight.
3. Banner be gone doesn't work with Granola and Zoom messages.
4. Make the modal appear on all windows instead of just one.
5. Set up capslock+j and capslock+k to scroll through alfred results only when alfred is the open application.

```clojure
  ;; TRIED TO IMPLEMENT THIS, BUT REALIZED IT CONFLICTS WITH WINDOW MANAGEMENT (W) AND ALT-TAB (T)
  ;;{:des "Hyper+t/w for new tab creation and tab closing"
  ;; :rules [[:t :!St ["hyper" 1]]]
  ;;         [:w :!Sw ["hyper" 1]]]}
```

### Other

1. Implement something like vim chords to navigate around text easier.
2. Implement another layer for arrow keys?
3. Shortcuts for Increase/Decrease font size.

## BTT App Switcher Design

### Two-script pattern

- **Right shift + key** → switch between open windows of a specific app (`core_window_switcher.js`)
- **Right shift + left shift + key** → open a new instance of the app (`open_new_app_instance.js`)

### BTT variable naming convention

`open_new_app_instance.js` reads then immediately clears these variables before acting:

| Variable | Used for |
| --- | --- |
| `btt_ws_app_shell_command_to_open` | Apps needing a custom shell command (e.g. `/usr/local/bin/code --new-window` for VS Code) |
| `btt_ws_app_name_to_open` | Regular apps — pass the macOS app name (e.g. `Google Chrome`) |
| `btt_ws_app_path_to_open` | Chrome Apps — pass the `.app` bundle path |
| `btt_ws_app_bundle_id_to_open` | Chrome Apps — pass the bundle identifier |

Priority: shell command → bundle ID → app name. Only one path is configured per trigger.

### Chrome App identifiers

| App | `btt_ws_app_path_to_open` | `btt_ws_app_bundle_id_to_open` |
| --- | --- | --- |
| Google Calendar | `/Users/smorris/Applications/Chrome Apps.localized/Calendar.app` | `com.google.Chrome.app.kjbdgfilnfhdoflbpgamdcdgpehopbep` |
| Google Meet | `/Users/smorris/Applications/Chrome Apps.localized/Google Meet.app` | `com.google.Chrome.app.kjgfgldnnfoeklkmfkjfagphfepbbdan` |
| Slack | `/Users/smorris/Applications/Chrome Apps.localized/Slack.app` | `com.google.Chrome.app.gpnmjojgpojfhdidkfnhhggcghbbgpbp` |
