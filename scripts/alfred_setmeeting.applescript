#!/usr/bin/osascript
-- ;setmeeting for Alfred
-- Run from Alfred with:  osascript ~/.dotfiles/setmeeting.applescript
-- Assumes your Mac is set to Eastern Time.
-- Output example: 1:30 PM ET / 12:30 CT / 11:30 MT (SLC) / 10:30 PT / 1:30 AM TPH
-- Unchecked zones in the dialog are left out of the output.

use AppleScript version "2.4"
use framework "Foundation"
use framework "AppKit"
use scripting additions

-- Dialog pieces shared with the Return-key handler below
property okBtn : missing value
property cancelBtn : missing value
property alertWin : missing value

on run argv
	-- Remember the app you were typing in (e.g. Chrome)
	set frontApp to current application's NSWorkspace's sharedWorkspace()'s frontmostApplication()

	-- Round up to the next :00 or :30 (1:20 -> 1:30, 1:30 -> 2:00)
	set nowDate to current date
	set nowMins to (hours of nowDate) * 60 + (minutes of nowDate)
	set startMins to ((nowMins div 30) + 1) * 30

	-- Build 24 half-hour slots (12 hours) starting at the default
	set slotLabels to {}
	repeat with i from 0 to 23
		set end of slotLabels to my fmtTime(startMins + i * 30, true)
	end repeat

	-- Show the dialog: {picked row index (0-based), CT?, MT?, PT?, TPH?}, or false if cancelled
	set dlg to my showDialog(slotLabels)

	-- Return focus to the original app, raising ONLY its active window
	frontApp's activateWithOptions:2
	delay 0.1

	if dlg is false then return ""
	set {idx, wantCT, wantMT, wantPT, wantTPH} to dlg
	set etMins to startMins + idx * 30

	-- CT, MT (Salt Lake City), and PT shift for DST on the same dates as ET,
	-- so fixed 1/2/3-hour offsets are correct year-round.
	set parts to {my fmtTime(etMins, true) & " ET"}
	if wantCT then set end of parts to my fmtTime(etMins - 60, false) & " CT"
	if wantMT then set end of parts to my fmtTime(etMins - 120, false) & " MT (SLC)"
	if wantPT then set end of parts to my fmtTime(etMins - 180, false) & " PT"

	-- Manila has no DST, so it's 12 or 13 hours ahead of ET depending on the
	-- date; compute it from the actual meeting date via macOS's timezone data.
	if wantTPH then
		set meetingDate to (nowDate - (time of nowDate)) + etMins * 60
		set fmt to current application's NSDateFormatter's new()
		fmt's setLocale:(current application's NSLocale's localeWithLocaleIdentifier:"en_US_POSIX")
		fmt's setTimeZone:(current application's NSTimeZone's timeZoneWithName:"Asia/Manila")
		fmt's setDateFormat:"h:mm a"
		set end of parts to ((fmt's stringFromDate:meetingDate) as text) & " TPH"
	end if

	set AppleScript's text item delimiters to " / "
	set output to parts as text
	set AppleScript's text item delimiters to ""
	return output
end run

-- Native dialog: scrolling time list + four checkboxes (all checked)
on showDialog(slotLabels)
	set NSApp to current application's NSApplication's sharedApplication()
	NSApp's setActivationPolicy:1 -- accessory: can take focus, no Dock icon

	-- Accessory view holding the list and checkboxes
	set acc to current application's NSView's alloc()'s initWithFrame:{{0, 0}, {300, 230}}

	-- Scrolling list of times
	set rows to current application's NSMutableArray's new()
	repeat with lbl in slotLabels
		(rows's addObject:(current application's NSDictionary's dictionaryWithObject:(contents of lbl) forKey:"label"))
	end repeat
	set ctrl to current application's NSArrayController's alloc()'s initWithContent:rows

	set col to current application's NSTableColumn's alloc()'s initWithIdentifier:"time"
	col's setWidth:280
	col's setEditable:false
	set tbl to current application's NSTableView's alloc()'s initWithFrame:{{0, 0}, {300, 190}}
	tbl's addTableColumn:col
	tbl's setHeaderView:(missing value)
	tbl's setAllowsEmptySelection:false
	tbl's setAllowsMultipleSelection:false
	col's bind:"value" toObject:ctrl withKeyPath:"arrangedObjects.label" options:(missing value)

	set scroller to current application's NSScrollView's alloc()'s initWithFrame:{{0, 36}, {300, 194}}
	scroller's setDocumentView:tbl
	scroller's setHasVerticalScroller:true
	scroller's setBorderType:2 -- bezel
	acc's addSubview:scroller

	-- Checkboxes, all on by default
	set cbCT to current application's NSButton's checkboxWithTitle:"CT" target:(missing value) action:(missing value)
	set cbMT to current application's NSButton's checkboxWithTitle:"MT (SLC)" target:(missing value) action:(missing value)
	set cbPT to current application's NSButton's checkboxWithTitle:"PT" target:(missing value) action:(missing value)
	set cbTPH to current application's NSButton's checkboxWithTitle:"TPH" target:(missing value) action:(missing value)
	set xs to {0, 60, 165, 225}
	set boxes to {cbCT, cbMT, cbPT, cbTPH}
	repeat with i from 1 to 4
		set cb to item i of boxes
		(cb's setState:1)
		(cb's setFrameOrigin:{item i of xs, 6})
		(acc's addSubview:cb)
	end repeat

	-- The alert window itself
	set alert to current application's NSAlert's new()
	-- Clock icon (built-in SF Symbol, macOS 11+), replacing the generic
	-- folder icon macOS shows for scripts. Falls back to blank if unavailable.
	set clockIcon to missing value
	try
		set clockIcon to current application's NSImage's imageWithSystemSymbolName:"clock" accessibilityDescription:"Clock"
		set symConfig to current application's NSImageSymbolConfiguration's configurationWithPointSize:40 weight:0
		set clockIcon to clockIcon's imageWithSymbolConfiguration:symConfig
	end try
	if clockIcon is missing value then set clockIcon to current application's NSImage's alloc()'s initWithSize:{1, 1}
	alert's setIcon:clockIcon
	alert's setMessageText:"Set Meeting"
	alert's setInformativeText:"Meeting time (ET):"
	set my okBtn to alert's addButtonWithTitle:"OK" -- Return
	set my cancelBtn to alert's addButtonWithTitle:"Cancel" -- Escape
	alert's setAccessoryView:acc
	alert's layout()
	set my alertWin to alert's |window|()

	-- Pre-select the default (first) time and give the list keyboard focus
	tbl's selectRowIndexes:(current application's NSIndexSet's indexSetWithIndex:0) byExtendingSelection:false
	tbl's scrollRowToVisible:0
	alertWin's setInitialFirstResponder:tbl
	alertWin's makeFirstResponder:tbl

	-- macOS normally sends Return to the default (OK) button no matter which
	-- button is focused. This timer checks focus while the dialog is open and,
	-- when you Tab to Cancel, moves the Return key to Cancel instead.
	set returnTimer to current application's NSTimer's timerWithTimeInterval:0.05 target:me selector:"syncReturnKey:" userInfo:(missing value) repeats:true
	current application's NSRunLoop's currentRunLoop()'s addTimer:returnTimer forMode:(current application's NSModalPanelRunLoopMode)

	NSApp's activateIgnoringOtherApps:true
	set response to (alert's runModal()) as integer
	returnTimer's invalidate()
	if response is not 1000 then return false -- 1000 = first button (OK)

	set idx to (tbl's selectedRow()) as integer
	if idx < 0 then set idx to 0
	return {idx, ((cbCT's state()) as integer) = 1, ((cbMT's state()) as integer) = 1, ((cbPT's state()) as integer) = 1, ((cbTPH's state()) as integer) = 1}
end showDialog

-- Called by the timer: Return goes to Cancel when Cancel has focus, else to OK
on syncReturnKey:theTimer
	try
		set fr to alertWin's firstResponder()
		if (fr is not missing value) and ((fr's isEqual:cancelBtn) as boolean) then
			okBtn's setKeyEquivalent:""
			cancelBtn's setKeyEquivalent:(character id 13) -- Return
		else
			okBtn's setKeyEquivalent:(character id 13) -- Return
			cancelBtn's setKeyEquivalent:(character id 27) -- Escape
		end if
	end try
end syncReturnKey:

-- Format minutes-since-midnight as "1:30" or "1:30 PM" (wraps past midnight)
on fmtTime(m, withAmPm)
	set m to m mod 1440
	if m < 0 then set m to m + 1440
	set h24 to m div 60
	set mm to m mod 60
	set h12 to h24 mod 12
	if h12 = 0 then set h12 to 12
	set mmStr to text -2 thru -1 of ("0" & mm)
	set s to (h12 as text) & ":" & mmStr
	if withAmPm then
		if h24 < 12 then
			set s to s & " AM"
		else
			set s to s & " PM"
		end if
	end if
	return s
end fmtTime
