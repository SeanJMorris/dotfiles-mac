# Google Sheets size-stepping macros

Apps Script port of the Excel/VBA macros that grow and shrink whatever is
selected: **entire columns or rows resize, anything else changes font size.**

| Chord | Macro | Shortcut Sheets actually sees |
| --- | --- | --- |
| ctrl+shift+i | `colWidthRowHeightIncreaseOrFontSizeIncrease` | Cmd+Opt+Shift+1 |
| ctrl+shift+k | `colWidthRowHeightDecreaseOrFontSizeDecrease` | Cmd+Opt+Shift+2 |

Google only allows Cmd+Opt+Shift+1..9 for macros, so the original ctrl+shift
chords are recreated in [`../init.lua`](../init.lua), which translates them
while a Google Sheets tab is active in Chrome.

## Files

| File | Holds |
| --- | --- |
| `Macros.gs` | The two entry points. The only functions without a trailing `_`, so the only two Sheets will show as macros. |
| `Guards.gs` | Protected-sheet / whole-sheet / contiguous-selection checks, and the whole-column-or-row test that picks the branch. |
| `ColumnRowSize.gs` | Column-width and row-height stepping (normalize-to-smallest, then step). |
| `FontSize.gs` | Per-cell font stepping, preserving mixed sizes in one selection. |
| `Notify.gs` | Toast helper for the deliberate "did nothing" cases. |
| `Config.gs` | Every tunable number. |
| `appsscript.json` | Manifest that binds the two macros to their shortcuts. Sean didn't need this on 9/2/26 when he implemented the first version of this successfully by plugging it into his google sheets apps script. |

## Tunables (`Config.gs`)

| Constant | Value | Notes |
| --- | --- | --- |
| `COLUMN_STEP_PX` | 20 | Excel stepped 1 character (~7px); Apps Script is pixels-only. |
| `ROW_STEP_PX` | 10 | The VBA's doubled row increment is already baked in — don't double it again. |
| `MIN_COLUMN_WIDTH_PX` | 20 | Floor. Required: Sheets throws below ~2px. |
| `MIN_ROW_HEIGHT_PX` | 10 | Floor, same reason. |
| `MIN_FONT_SIZE_PT` / `MAX_FONT_SIZE_PT` | 1 / 400 | The range Sheets accepts. |

## Install (per spreadsheet)

1. In the spreadsheet: **Extensions > Apps Script**.
2. **Project Settings** (gear) > tick **Show "appsscript.json" manifest file in
   editor**. Without this you can't paste the manifest, and without the
   manifest there are no keyboard shortcuts.
3. Create one script file per `.gs` above, matching the names, and paste the
   contents. (File names don't affect behavior — Apps Script concatenates every
   file into one shared scope — but matching them keeps this README accurate.)
4. Replace `appsscript.json` with the copy here. `Ctrl+Alt+Shift+1` is the
   correct manifest spelling; macOS presents it as Cmd+Opt+Shift+1.
5. **Save**, then run `colWidthRowHeightIncreaseOrFontSizeIncrease` once from
   the editor to trigger the authorization prompt. Shortcuts stay dead until
   the script is authorized.
6. Back in the sheet, confirm both entries appear under **Extensions > Macros**.

To push from this repo instead of pasting, `clasp` works:
`npm i -g @google/clasp && clasp login && clasp clone <scriptId> && clasp push`.

## Known differences from the Excel version

- **Not global.** `PERSONAL.XLSB` made the Excel macros available in every
  workbook. A container-bound Apps Script belongs to *one spreadsheet* — repeat
  the install per file, or package it as an editor add-on.
- **No undo.** Script-made changes generally don't enter the Cmd+Z stack.
- **~1–2s per press.** Every run is a server round trip, so you can't hold the
  chord to ramp a size up; presses queue.
- **Contiguous selections only.** Cmd+click multi-area selections are refused
  with a toast rather than guessing which branch to take.
- **Any sheet protection blocks**, mirroring the VBA's conservative
  `ws.ProtectContents` check — even a protection you can personally edit. See
  the comment in `Guards.gs` for the one-line change to only block real locks.
- **`timeZone` in the manifest is a placeholder** (`America/Los_Angeles`).
  Irrelevant to these macros; change it if the project ever uses dates.
