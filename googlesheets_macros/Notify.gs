/**
 * Notify.gs — brief, non-blocking messages.
 *
 * A toast appears bottom-right and vanishes on its own, so it never interrupts
 * typing. Used for "I deliberately did nothing" cases, which matter more here
 * than in Excel: a macro takes a second or two to run, so silence is
 * indistinguishable from slowness.
 */
function toast_(message) {
  SpreadsheetApp.getActive().toast(message, 'No change', 3);
}
