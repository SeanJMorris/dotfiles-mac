/**
 * FontSize.gs — the "selection is not a whole column/row" branch.
 */

/**
 * Port of: Sub FontSizeChanger(selectionArg, fontSizeChangeIncrement)
 *
 * The VBA looped cell by cell (For Each myCell) so a selection with mixed font
 * sizes kept its variety — 10pt and 14pt cells both move up one step rather
 * than flattening to a single size. Doing that with one setFontSize() call per
 * cell would be painfully slow here (every call is a server round trip), so
 * this reads the whole block as a 2D array, adds the delta in memory, and
 * writes it back in one call. Same result, one round trip.
 *
 * @param {Range} range      contiguous selection
 * @param {number} delta     +1 to grow, -1 to shrink
 */
function fontSizeChanger_(range, delta) {
  const sizes = range.getFontSizes();

  for (let row = 0; row < sizes.length; row++) {
    for (let col = 0; col < sizes[row].length; col++) {
      sizes[row][col] = clampFontSize_(sizes[row][col] + delta);
    }
  }

  range.setFontSizes(sizes);
}

/** Keeps a size inside the range Sheets will accept. */
function clampFontSize_(size) {
  return Math.min(MAX_FONT_SIZE_PT, Math.max(MIN_FONT_SIZE_PT, size));
}
