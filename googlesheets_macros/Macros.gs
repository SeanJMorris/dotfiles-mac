/**
 * Macros.gs — the two entry points. These are the ONLY functions here without a
 * trailing underscore, so they are the only two that appear in
 * Extensions > Macros and can be bound to a keyboard shortcut.
 *
 * Shortcuts (set in appsscript.json):
 *   Increase -> Cmd+Opt+Shift+1   (reached as ctrl+shift+i via Hammerspoon)
 *   Decrease -> Cmd+Opt+Shift+2   (reached as ctrl+shift+k via Hammerspoon)
 *
 * Google only offers Cmd+Opt+Shift+1..9 for macros; the ctrl+shift+i / +k
 * chords from the Excel original are recreated in ~/.dotfiles/init.lua, which
 * translates them into these shortcuts while a Sheets tab is active.
 */

/** Port of: Sub ColWidthRowHeightIncreaseOrFontSizeIncrease() — CTRL+SHIFT+I */
function colWidthRowHeightIncreaseOrFontSizeIncrease() {
  stepSelection_(1);
}

/** Port of: Sub ColWidthRowHeightDecreaseOrFontSizeDecrease() — CTRL+SHIFT+K */
function colWidthRowHeightDecreaseOrFontSizeDecrease() {
  stepSelection_(-1);
}

/**
 * The shared body of both macros. The VBA duplicated this logic in each Sub;
 * here the only difference between them is the sign, so they share one path.
 *
 * @param {number} changeVal +1 to grow, -1 to shrink
 */
function stepSelection_(changeVal) {
  const sheet = SpreadsheetApp.getActiveSheet();

  if (!selectionIsContiguous_(sheet)) {
    toast_('Select one continuous block of cells, columns, or rows.');
    return;
  }

  const range = sheet.getActiveRange();
  if (!range) return;

  // Matches the VBA's "If worksheetIsProtectedOrSelectionIsWholeSheet Then Exit Sub".
  if (sheetIsProtectedOrSelectionIsWholeSheet_(sheet, range)) return;

  if (fullColumnOrRowSelected_(sheet, range)) {
    colRowWidthHeightChange_(sheet, range, changeVal);
  } else {
    fontSizeChanger_(range, changeVal);
  }
}
