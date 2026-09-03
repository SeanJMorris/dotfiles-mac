/**
 * Config.gs — every tunable number lives here.
 *
 * WHY PIXELS: the Excel original stepped column width by 1 *character* (~7px)
 * and row height by 2 *points* (~3px). Apps Script only accepts pixels, so
 * there is no literal equivalent — these are the chosen per-press steps.
 * The VBA's doubling of the row increment (ChangeVal + ChangeVal) is already
 * baked into ROW_STEP_PX; do not double it again in the code.
 */

// How much one press moves things.
const COLUMN_STEP_PX = 20;
const ROW_STEP_PX = 10;

// Floors, so a decrease can't collapse a column/row to invisible.
// The VBA had no floor (Excel silently hides a 0-width column); Apps Script
// throws on a width below ~2px, so a floor is required, not just nice to have.
const MIN_COLUMN_WIDTH_PX = 20;
const MIN_ROW_HEIGHT_PX = 10;

// Sheets rejects a font size below 1 and above 400.
const MIN_FONT_SIZE_PT = 1;
const MAX_FONT_SIZE_PT = 400;
