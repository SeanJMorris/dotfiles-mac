/**
 * ColumnRowSize.gs — the "whole column(s) or whole row(s) selected" branch.
 */

/**
 * Port of: Sub ColRowWidthHeightChange(ChangeVal)
 *
 * Normalize-then-step, exactly like the VBA: find the smallest width among the
 * selected columns, then set EVERY selected column to that smallest value plus
 * one step. Selecting columns of 80/150/60px and pressing increase gives three
 * columns of 80px (60 + 20), not 100/170/80 — increasing can shrink the widest
 * column. That is the original behavior, and it is what makes ragged columns
 * even out.
 *
 * Dropped from the VBA: the MinWidth = 200 / MinHeight = 200 sentinels. In
 * Excel 200 is near the 255-character ceiling, so it read as "infinity." In
 * pixels 200 is an ordinary column width, so it cannot carry over as a number —
 * this tracks "nothing found yet" with null instead.
 *
 * Also dropped: Round(). Pixel values are already whole numbers.
 *
 * @param {Sheet} sheet
 * @param {Range} range      contiguous selection
 * @param {number} changeVal +1 to grow, -1 to shrink
 */
function colRowWidthHeightChange_(sheet, range, changeVal) {
  const wholeColumnsSelected = range.getNumRows() === sheet.getMaxRows();
  const wholeRowsSelected = range.getNumColumns() === sheet.getMaxColumns();

  // The VBA used two independent Ifs, so a whole-sheet selection would have run
  // both. Here the whole-sheet case is already refused by the guard, so exactly
  // one of these branches can run — hence else-if.
  if (wholeColumnsSelected) {
    resizeColumns_(sheet, range, changeVal);
  } else if (wholeRowsSelected) {
    resizeRows_(sheet, range, changeVal);
  }
}

function resizeColumns_(sheet, range, changeVal) {
  const firstColumn = range.getColumn();
  const columnCount = range.getNumColumns();

  const smallest = smallestVisibleColumnWidth_(sheet, firstColumn, columnCount);
  if (smallest === null) {
    toast_('Every selected column is hidden — nothing to resize.');
    return;
  }

  const target = Math.max(MIN_COLUMN_WIDTH_PX, smallest + (changeVal * COLUMN_STEP_PX));

  // One batched call for the whole run. Safe because the selection is
  // guaranteed contiguous. Hidden columns in the run receive the new width but
  // stay hidden — in Sheets, hidden is a separate flag from width, unlike
  // Excel where hiding a column sets its width to 0.
  sheet.setColumnWidths(firstColumn, columnCount, target);
}

function resizeRows_(sheet, range, changeVal) {
  const firstRow = range.getRow();
  const rowCount = range.getNumRows();

  const smallest = smallestVisibleRowHeight_(sheet, firstRow, rowCount);
  if (smallest === null) {
    toast_('Every selected row is hidden — nothing to resize.');
    return;
  }

  const target = Math.max(MIN_ROW_HEIGHT_PX, smallest + (changeVal * ROW_STEP_PX));
  sheet.setRowHeights(firstRow, rowCount, target);
}

/**
 * The VBA skipped hidden columns with "If col.ColumnWidth > 0", which works
 * because Excel hides a column by zeroing its width. Sheets keeps the width
 * value when a column is hidden, so hidden-ness has to be asked about directly
 * — otherwise a hidden 20px column would drag every visible column down to it.
 *
 * @return {?number} smallest visible width in pixels, or null if all are hidden
 */
function smallestVisibleColumnWidth_(sheet, firstColumn, columnCount) {
  let smallest = null;

  for (let offset = 0; offset < columnCount; offset++) {
    const column = firstColumn + offset;
    if (sheet.isColumnHiddenByUser(column)) continue;

    const width = sheet.getColumnWidth(column);
    if (smallest === null || width < smallest) smallest = width;
  }

  return smallest;
}

/** Row-height counterpart of smallestVisibleColumnWidth_. */
function smallestVisibleRowHeight_(sheet, firstRow, rowCount) {
  let smallest = null;

  for (let offset = 0; offset < rowCount; offset++) {
    const row = firstRow + offset;
    if (sheet.isRowHiddenByUser(row)) continue;

    const height = sheet.getRowHeight(row);
    if (smallest === null || height < smallest) smallest = height;
  }

  return smallest;
}
