# PRD: BetterTouchTool App-Specific Window Cycling Shortcut

**Author:** Sean Morris  
**Date:** 2026-05-02  
**Tool:** BetterTouchTool (macOS)  
**Status:** Draft

---

## Overview

This document specifies the behavior for a custom keyboard shortcut implemented in BetterTouchTool (BTT) that allows the user to launch, activate, and cycle through all open windows of a specific application — using a single chord of modifier keys plus one repeated trigger key — without disrupting the existing window z-order of windows that are not ultimately selected.

The example configuration described throughout this document binds **`⌃⌥⌘ D`** to **Google Chrome**. The implementation uses a single parameterized BTT script/named trigger that accepts an app name and trigger key, so additional app bindings (e.g., `⌃⌥⌘ T` → Terminal, `⌃⌥⌘ S` → Slack) require only a new BTT shortcut entry pointing at the same underlying script with different arguments — no duplication of logic.

---

## Goals

- Provide instant keyboard-driven access to any window of a target application.
- Allow visual cycling through multiple windows of the same app with a lightweight preview.
- **Not** disrupt the window stack (z-order / "most recently used" order) of windows that the user cycles past but does not select.
- Feel distinct from macOS's built-in `⌘ \`` behavior, which raises each window to the front as you cycle.

---

## Non-Goals

- This does not replace Mission Control or Exposé.
- This does not manage windows across multiple apps simultaneously.
- This does not resize, move, or snap windows.
- This does not need to persist state between shortcut invocations (cycle index resets each time the shortcut is initiated).

---

## Trigger & Modifier Keys

| Property | Value |
|---|---|
| Modifier chord | `⌃` Control + `⌥` Option + `⌘` Command |
| Trigger key (Chrome example) | `D` |
| Cycle advance | Tap `D` again while all three modifiers remain held |
| Commit / select | Release **any** of the three modifier keys (`⌃`, `⌥`, or `⌘`) |
| Cancel | None — there is no explicit cancel gesture. Releasing a modifier always commits the currently previewed window. |

---

## Behavioral States

### State 1 — No windows of target app are open on the current Space

**Trigger:** `⌃⌥⌘ D` pressed; Chrome has no windows open on the currently active Space.

**Expected behavior:**
- If Chrome is not running at all, launch it (which opens a new window on the current Space).
- If Chrome is running but all its windows are on other Spaces, open a new Chrome window on the current Space.
- Bring the new window to the foreground as the active window.
- No cycling UI is shown.

---

### State 2 — Exactly one window of target app is open on the current Space

**Trigger:** `⌃⌥⌘ D` pressed; Chrome has exactly one window on the currently active Space.

**Expected behavior:**
- Activate Chrome and bring that single window to the foreground.
- No cycling UI is shown (nothing to cycle through).
- Release of modifier keys is a no-op (window is already in front).

---

### State 3 — Multiple windows of target app are open on the current Space (Cycle Mode)

**Trigger:** `⌃⌥⌘ D` pressed; Chrome has 2 or more windows on the currently active Space.

**Expected behavior on first press:**
- Enter "Cycle Mode."
- The current cycle index is set to 0, pointing at the most-recently-active Chrome window on the current Space.
- Display a preview of that window (see Preview UI section below).
- Do **not** raise or reorder any windows yet.

**Expected behavior on each subsequent `D` press (modifiers still held):**
- Increment the cycle index (wrapping around after the last window).
- Update the preview to show the newly indexed window.
- Do **not** raise, focus, or change the z-order of any window during cycling. Windows being cycled past must remain in the same position in the MRU (most-recently-used) stack as they were before the shortcut was initiated.

**Expected behavior on modifier key release (any of `⌃`, `⌥`, `⌘`):**
- The window at the current cycle index is brought to the foreground and becomes the active window.
- Cycle Mode is exited. The preview UI is dismissed.
- All other Chrome windows remain in the z-order position they held before the shortcut was initiated (i.e., their MRU rank is unchanged relative to each other and relative to other apps' windows).

---

## Key Behavioral Constraint: Non-Destructive Cycling

This is the most important behavioral distinction from `⌘ \``.

**With `⌘ \``:** Each keypress raises the next window to the foreground, which changes the window's position in the MRU order. After cycling, the window stack is reordered, which can disrupt the user's spatial memory and break workflows that depend on the prior window order.

**With this shortcut:** Windows that are *cycled past but not selected* must retain their original MRU position. Only the *selected* window (the one in focus when a modifier is released) is raised to the foreground and its MRU position updated. From macOS's perspective, it should look as if the user had directly activated that one window with no intermediate steps.

**Implementation implication:** The cycling mechanism must not call `activate` (AppleScript) or `NSApplication.activate` on any window other than the final selected one. During cycling, the windows should be observed (e.g., enumerated via `CGWindowListCopyWindowInfo`) but not focused or raised.

---

## Preview UI

During Cycle Mode, the user must be able to see which window they're about to select. A live/real-time window capture is **not** required — a cached snapshot is sufficient.

### Option A — BTT Floating HUD with Cached Window Thumbnail (Preferred)

- Use a cached window snapshot (e.g., from the Dock's thumbnail store or `CGWindowListCreateImage` captured at shortcut-initiation time rather than on each keypress) to display a thumbnail for the indexed window.
- Display the thumbnail in a BTT Named Trigger–triggered HUD overlay or a small floating panel.
- Overlay should include the window's title string.
- Overlay should dismiss instantly on modifier release.

**Pros:** Non-intrusive, does not alter window state; capturing once at initiation avoids per-keypress latency.  
**Cons:** Thumbnail may not reflect the very latest window contents if the window changed recently, but this is acceptable.

### Option B — Text-Only Window Title List (Fallback)

- Use Accessibility APIs (`AXUIElement`) to read window titles and display them as a text-only list in a BTT HUD (no thumbnail).
- Highlight the currently indexed window title in the list.

**Pros:** Simpler to implement in pure AppleScript, no image capture required.  
**Cons:** No visual thumbnail, relies on window titles being descriptive.

### Option C — App Exposé (Not Recommended)

- Invoke App Exposé (`⌃ ↓` by default) to show all Chrome windows, then navigate with arrow keys.

**Cons:** Changes window focus behavior, requires a different interaction model, does not integrate with the modifier-release commit gesture, and may alter window z-order.

---

## Window Enumeration & Ordering

The shortcut operates **only on windows present in the currently active macOS Space.** Windows on other Spaces are excluded from enumeration entirely and are unaffected by the shortcut.

Windows in the cycle should be ordered by **most recently used (MRU)** — i.e., the same order macOS would return them via the Accessibility API or `CGWindowListCopyWindowInfo` with `kCGWindowListOptionOnScreenOnly`, filtered to the current Space.

- Minimized windows: **Include** in the cycle list (they can be un-minimized on selection).
- Off-screen / moved-off-display windows on the current Space: **Include.**
- Windows on other Spaces: **Exclude.**
- Fullscreen windows in other Spaces: **Exclude.**
- Hidden windows (`app.hidden = true`): **Exclude.**

**Implementation note:** `CGWindowListCopyWindowInfo` with `kCGWindowListOptionOnScreenOnly` returns only windows on the current Space, which naturally handles the Space-filtering requirement. Minimized windows will require an additional pass via the Accessibility API since they are not returned by the on-screen window list.

---

## BTT Implementation Notes

### Parameterized Script Design

The core logic is implemented once as a single reusable script that accepts two parameters:

| Parameter | Description | Example |
|---|---|---|
| `APP_NAME` | The macOS process name of the target application | `"Google Chrome"` |
| `TRIGGER_KEY` | The letter key bound to this app (for documentation/logging only) | `"D"` |

Each per-app BTT shortcut (e.g., `⌃⌥⌘ D`, `⌃⌥⌘ T`, `⌃⌥⌘ S`) calls the same named trigger or shell script, passing only the app name as an argument. This means adding a new app requires only a new BTT shortcut entry — no changes to the underlying script.

### Suggested BTT Constructs

| BTT Feature | Usage |
|---|---|
| Named Trigger (parameterized) | Central entry point; receives `APP_NAME`, manages cycle state |
| Global Variables | `btt_cycle_index`, `btt_cycle_window_ids` (comma-separated), `btt_cycle_app` |
| AppleScript Action | Enumerate windows, build window ID list, activate final selection |
| Shell Script Action | Capture cached window snapshots at initiation via `CGWindowListCreateImage` |
| HUD / Floating Overlay | Display cached thumbnail and window title |
| Key Sequence: Key Up | Detect modifier release to trigger the commit action |

### Suggested AppleScript Skeleton (Window Enumeration)

```applescript
-- APP_NAME is passed in as a BTT variable, e.g., "Google Chrome"
set appName to do shell script "echo $APP_NAME"

tell application "System Events"
    set targetProc to first process whose name is appName
    set winList to every window of targetProc
    -- Returns windows in front-to-back (MRU) order
    set winNames to name of every window of targetProc
end tell
```

Note: this returns all windows for the process. Space-filtering should be applied using `CGWindowListCopyWindowInfo` at the shell/Swift layer before passing the window ID list to BTT variables.

### Detecting Modifier Release in BTT

BTT supports triggering actions on **key up** events. To detect when any of the three modifiers is released:

- Create three separate BTT triggers: `⌃ Key Up`, `⌥ Key Up`, `⌘ Key Up` — each while the other two are still held (or configure a broad key-up handler that checks BTT variable state).
- Each of these triggers should fire the "commit" action: activate the window at `btt_cycle_index` and clear the cycle state variables.

### State Cleanup

On commit, the following must be reset:
- `btt_cycle_index` → `0`
- `btt_cycle_window_ids` → `""`
- `btt_cycle_app` → `""`
- Dismiss any floating HUD overlay.

---

## Edge Cases

| Scenario | Expected Behavior |
|---|---|
| Chrome window is minimized (on current Space) | Un-minimize and bring to foreground on selection |
| Chrome window is on a different Space | Exclude from the cycle — only windows on the currently active Space are eligible |
| Chrome is running but all windows are on other Spaces | Treat as State 1: open a new Chrome window on the current Space |
| Chrome window is in fullscreen mode on another Space | Exclude from the cycle |
| User taps `D` past the last window | Wrap around to index 0 (first / most-recent window) |
| Chrome window closes while cycling | Re-enumerate windows; if the current index no longer exists, clamp to last valid index |
| Two `D` presses in very quick succession | BTT should handle debouncing; ensure cycle index increments correctly and preview updates atomically |
| User initiates shortcut and immediately releases modifier without pressing `D` again | Treat as State 2 / direct activation of the MRU window on current Space |

---

## Success Criteria

1. **Launch:** Pressing `⌃⌥⌘ D` when Chrome has no window on the current Space opens a new Chrome window within ~1 second.
2. **Activate:** Pressing `⌃⌥⌘ D` when Chrome has one window on the current Space brings it to front immediately.
3. **Cycle:** Pressing `⌃⌥⌘ D` repeatedly (modifiers held) steps through each Chrome window on the current Space one by one, displaying a visible preview.
4. **Space isolation:** Windows on other Spaces are never surfaced, activated, or reordered by the shortcut.
5. **Non-destructive z-order:** After completing a cycle and selecting a window, `⌘ \`` behavior in Chrome should reflect the same window stack as before the shortcut was initiated — except the selected window is now at the front.
6. **Commit on modifier release:** Releasing any single modifier key while a window is previewed brings exactly that window to the foreground.
7. **No stutter:** The preview updates within 200ms of each `D` keypress during cycling.

---

## Resolved Decisions

| Decision | Resolution |
|---|---|
| Cancel gesture | No explicit cancel. Releasing any modifier key always commits the currently previewed window. |
| Space switching | No — the shortcut is strictly scoped to the currently active Space. Windows on other Spaces are excluded entirely. |
| Thumbnail fidelity | A cached snapshot captured at shortcut-initiation time is sufficient. A live/real-time capture is not required. |
| Script architecture | Single parameterized script accepting `APP_NAME`. Each per-app BTT shortcut calls the same script with a different argument. |
| BTT permissions | BTT already has Accessibility and Screen Recording permissions granted. No additional setup needed. |
