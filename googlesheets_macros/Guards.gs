/**
 * Guards.gs — the checks that decide whether a macro does anything at all,
 * and which branch it takes.
 *
 * Helper names end in "_" — that is the Apps Script convention for "private".
 * It also keeps them out of the Extensions > Macros list, so only the two real
 * entry points in Macros.gs are selectable.
 */

/**
 * Port of: Function fullColumnOrRowSelected(selectionArg)
 *
 * True when the selection spans every row (so entire columns are selected) or
 * every column (entire rows). Excel's Rows.count/Columns.count of the sheet
 * become getMaxRows()/getMaxColumns() — note these are the sheet's *current*
 * grid size, which in Sheets varies per sheet, unlike Excel's fixed 1,048,576.
 */
function fullColumnOrRowSelected_(sheet, range) {
  return range.getNumRows() === sheet.getMaxRows() ||
         range.getNumColumns() === sheet.getMaxColumns();
}

/**
 * Port of: Function worksheetIsProtectedOrSelectionIsWholeSheet(selectionArg)
 *
 * Same conservative shape as the original: protected sheet -> tell the user and
 * stop; whole sheet selected -> stop silently; otherwise proceed.
 *
 * ws.ProtectContents has no exact Sheets analogue. This mirrors the VBA
 * faithfully: ANY sheet-level protection counts as protected, even one you
 * personally can edit. To only block protections that actually lock you out,
 * change the test to: protections.some(p => !p.canEdit())
 */
function sheetIsProtectedOrSelectionIsWholeSheet_(sheet, range) {
  const protections = sheet.getProtections(SpreadsheetApp.ProtectionType.SHEET);
  if (protections.length > 0) {
    SpreadsheetApp.getUi().alert('The active sheet is protected.');
    return true;
  }

  const wholeSheet = range.getNumRows() === sheet.getMaxRows() &&
                     range.getNumColumns() === sheet.getMaxColumns();
  return wholeSheet;
}

/**
 * No VBA equivalent — this is the "contiguous selection only" rule.
 *
 * Excel selections can span several non-adjacent areas; so can Sheets
 * (cmd+click). With multiple areas the branch choice is ambiguous (what if one
 * area is a full column and another is three cells?), so we refuse instead of
 * guessing.
 */
function selectionIsContiguous_(sheet) {
  const rangeList = sheet.getActiveRangeList();
  if (!rangeList) return true;
  return rangeList.getRanges().length <= 1;
}
