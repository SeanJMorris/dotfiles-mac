-- Bring the most recent regular Chrome browser window forward and open tab search (cmd+shift+a).
-- Called by Karabiner on hyper+o when Chrome is NOT the frontmost app (see karabiner.edn).
--
-- Does nothing when:
--   * Chrome isn't running (checked first so this script never launches Chrome)
--   * Chrome has no visible browser window (e.g. only minimized windows are open)
--
-- Chrome App windows (Slack, Calendar, Meet) show up in Chrome's window list but
-- report visible = false, as do minimized windows -- so "first visible window"
-- = most recent regular, non-minimized browser window (the list is ordered
-- most-recent first).

if application "Google Chrome" is not running then return

tell application "Google Chrome"
	set targetWindow to missing value
	repeat with w in windows
		if visible of w then
			set targetWindow to w
			exit repeat
		end if
	end repeat
	if targetWindow is missing value then return
	set index of targetWindow to 1
	activate
end tell

-- Wait (up to ~1s) until Chrome is actually frontmost, so the keystroke can't
-- land in the app we just left. Sending the keystroke requires macOS
-- Accessibility permission for whatever process runs this script.
tell application "System Events"
	repeat 20 times
		if frontmost of process "Google Chrome" then exit repeat
		delay 0.05
	end repeat
	if frontmost of process "Google Chrome" then keystroke "a" using {command down, shift down}
end tell
