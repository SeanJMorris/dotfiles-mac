# Spatial Window Management — Product Requirements Document

## Goal

Use a keyboard shortcut to cycle focus through windows that are prominently displayed on screen, moving spatially left or right.

## Trigger

`Cmd + Alt + Ctrl + Left/Right arrow`

## Window Eligibility

**A window MUST be included if:**

- It occupies 40% or more of the visible screen area of the monitor it is on
- It is on a currently active Space across any connected monitor
- This applies across all monitors

**A window MUST be excluded if:**

- It occupies less than 40% of the visible screen area of the monitor it is on
- It is minimized, hidden, or on a non-active Space

## Navigation Behavior

- Windows are ordered left to right by their horizontal screen position across all monitors
- `Left` moves focus to the next eligible window to the left
- `Right` moves focus to the next eligible window to the right

## Wrapping Behavior

- All monitors are arranged horizontally, same size, same plane
- Pressing `Left` on the left-most window wraps to the right-most window
- Pressing `Right` on the right-most window wraps to the left-most window

## Implementation Notes

- "Full screen" refers only to windows that happen to fill the screen dimensions — no special accommodation is needed for macOS native fullscreen (green button)
- The 40% threshold is calculated as the intersection area of the window and the screen's visible frame (respecting menubar/dock), divided by the total visible screen area
- Navigation is implemented by sorting eligible windows by their `x` position and indexing the sorted list directly, rather than relying on Hammerspoon's built-in `focusWindowWest/East` (which has its own internal window-finding logic that ignores the candidate filter)
