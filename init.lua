--  _       _ _     _
-- (_)_ __ (_) |_  | |_   _  __ _
-- | | '_ \| | __| | | | | |/ _` |
-- | | | | | | |_ _| | |_| | (_| |
-- |_|_| |_|_|\__(_)_|\__,_|\__,_|

-- See https://youtu.be/s9MfRDBriVs?t=74 https://www.hammerspoon.org/Spoons/SpoonInstall.html
-- This is a very easy way to add new Spoons - you can just put the name of the
-- spoon and it downloads and starts it automatically
hs.loadSpoon("SpoonInstall")

-- Lets the `hs` command-line tool run Lua in this Hammerspoon instance
-- (e.g. `hs -c 'hs.reload()'`), which makes testing changes from the terminal possible.
require("hs.ipc")

-- ADD SPOONS HERE
--This Spoon allows you to reload your Hammerspoon configuration automatically
    --when you save changes to your init.lua file
spoon.SpoonInstall:andUse("ReloadConfiguration")
spoon.SpoonInstall:andUse("ModalMgr")

-- Watch for changes in the the Goku file called karabiner.edn and notify when
-- changes are detected this makes it such that, when you make changes to your
-- Goku file, it compiles the Goku into the JSON that Karabiner understands
gokuWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/karabiner.edn', function ()
    output = hs.execute('/opt/homebrew/bin/goku')
    hs.notify.new({title = 'Karabiner Config', informativeText = output}):send()
end):start()

-- GOOGLE SHEETS: Ctrl+PageDown -> Alt(Option)+Down, Ctrl+PageUp -> Alt(Option)+Up,
-- but ONLY when the frontmost Chrome tab's URL starts with the Sheets prefix.
-- Karabiner can't see tab URLs, so this must live in Hammerspoon. It checks the URL only
-- when you actually press Ctrl+PageDown/Up while Chrome is frontmost, so it adds no typing lag.
local SHEETS_PREFIX = "https://docs.google.com/spreadsheets"

-- Tag for keystrokes this file synthesizes, so our own eventtaps can tell an
-- event we posted from one the user actually typed. Needed because two rules
-- below both involve option+down: sheetsCtrlPageNav *emits* it (it is Sheets'
-- native next-sheet key) and sheetsFilterMenu *consumes* it. Without the tag,
-- sheetsFilterMenu would swallow sheetsCtrlPageNav's output and ctrl+pagedown
-- would open the filter menu instead of moving to the next sheet.
local SYNTHETIC_TAG = 0x53485453                    -- "SHTS"
local USER_DATA = hs.eventtap.event.properties.eventSourceUserData

local function postTagged(mods, key)
    for _, isDown in ipairs({ true, false }) do
        local ev = hs.eventtap.event.newKeyEvent(mods, key, isDown)
        ev:setProperty(USER_DATA, SYNTHETIC_TAG)
        ev:post()
    end
end

local function isSynthetic(e)
    return e:getProperty(USER_DATA) == SYNTHETIC_TAG
end

sheetsCtrlPageNav = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    local f = e:getFlags()
    -- Require Ctrl held, and none of Cmd/Alt/Shift (fn is allowed for keyboards that need it).
    if not (f.ctrl and not f.cmd and not f.alt and not f.shift) then return false end

    local code = e:getKeyCode()
    local map = hs.keycodes.map
    if code ~= map.pagedown and code ~= map.pageup then return false end

    -- Only proceed if Chrome is the frontmost app (this also avoids launching Chrome via AppleScript).
    local app = hs.application.frontmostApplication()
    if not app or app:bundleID() ~= "com.google.Chrome" then return false end

    local ok, url = hs.osascript.applescript(
        'tell application "Google Chrome" to get URL of active tab of front window')
    if ok and type(url) == "string" and url:sub(1, #SHEETS_PREFIX) == SHEETS_PREFIX then
        local dir = (code == map.pagedown) and "down" or "up"
        postTagged({ "alt" }, dir)                 -- Alt(Option)+Down / +Up, tagged as ours
        return true                                -- swallow the original Ctrl+PageDown/Up
    end
    return false                                   -- not Sheets: let the key pass through unchanged
end)
sheetsCtrlPageNav:start()

-- GOOGLE SHEETS ZOOM: hyper+n / hyper+m arrive here as F17 / F18 (emitted by Karabiner).
-- When the active Chrome tab is a Google Sheet, step the SHEET's own zoom by ±10%
-- (clamped 50–200) by writing the value into the toolbar Zoom box via injected JS.
-- Anywhere else — non-Sheets Chrome tab, or any other app — fall back to normal
-- browser zoom (cmd+- / cmd+=), preserving the old behavior.
-- Requires Chrome menu: View > Developer > "Allow JavaScript from Apple Events".
local SHEETS_ZOOM_MIN, SHEETS_ZOOM_MAX = 50, 200

-- Run one line of JS (SINGLE quotes only) in Chrome's active tab; returns ok, result.
local function chromeJsExec(js)
  return hs.osascript.applescript(
    'tell application "Google Chrome" to tell active tab of front window '
    .. 'to execute javascript "' .. js .. '"')
end

-- True only when Chrome is frontmost AND its active tab is a Google Sheet.
-- Uses the same URL check as sheetsCtrlPageNav (no JS needed, so no toggle dependency here).
local function chromeSheetActive()
  local app = hs.application.frontmostApplication()
  if not app or app:bundleID() ~= "com.google.Chrome" then return false end
  local ok, url = hs.osascript.applescript(
    'tell application "Google Chrome" to get URL of active tab of front window')
  return ok and type(url) == "string" and url:sub(1, #SHEETS_PREFIX) == SHEETS_PREFIX
end

-- Read current sheet zoom, compute current+delta (clamped), and write it back.
-- Returns true if handled (including a no-op at the clamp limits), false if it
-- couldn't read the zoom (e.g. the Apple Events toggle is off) so the caller falls back.
local function sheetsStepZoom(delta)
  local ok, val = chromeJsExec("document.querySelector('input[aria-label=Zoom]').value")
  local cur = (ok and type(val) == "string") and tonumber(val:match("%d+")) or nil
  if not cur then return false end
  local target = math.max(SHEETS_ZOOM_MIN, math.min(SHEETS_ZOOM_MAX, cur + delta))
  if target == cur then return true end  -- already at 50/200; stay clamped, don't browser-zoom
  chromeJsExec("(function(){"
    .. "var i=document.querySelector('input[aria-label=Zoom]');if(!i)return 'NO_INPUT';"
    .. "var b=i.closest('.goog-toolbar-combo-button')||i.parentElement;"
    .. "['mousedown','mouseup','click'].forEach(function(t){"
    .. "b.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}))});"
    .. "i.removeAttribute('disabled');i.focus();i.value='" .. target .. "';"
    .. "i.dispatchEvent(new Event('input',{bubbles:true}));"
    .. "i.dispatchEvent(new Event('change',{bubbles:true}));"
    .. "['keydown','keypress','keyup'].forEach(function(t){"
    .. "i.dispatchEvent(new KeyboardEvent(t,{bubbles:true,key:'Enter',code:'Enter',keyCode:13,which:13}))});"
    .. "return 'OK'})();")
  -- The write leaves the Zoom combo focused/open, which steals arrow keys until you
  -- press Escape a few times. Mirror that automatically so you can resume editing.
  -- Spaced out because Closure's menu can drop back-to-back key events.
  for i = 1, 3 do
    hs.timer.doAfter(0.04 * i, function() hs.eventtap.keyStroke({}, "escape", 0) end)
  end
  return true
end

-- delta < 0 = zoom out (hyper+n / F17); delta > 0 = zoom in (hyper+m / F18).
local function handleZoomKey(delta)
  if chromeSheetActive() and sheetsStepZoom(delta) then return end
  hs.eventtap.keyStroke({ "cmd" }, (delta < 0) and "-" or "=", 0)
end

hs.hotkey.bind({}, "f17", function() handleZoomKey(-10) end)  -- hyper+n -> zoom out
hs.hotkey.bind({}, "f18", function() handleZoomKey(10) end)   -- hyper+m -> zoom in

-- LUCIDCHART: true when Chrome's active tab is Lucidchart. Used by the HYPER+' (F16)
-- binding below the Figma section.
local function chromeLucidActive()
  local app = hs.application.frontmostApplication()
  if not app or app:bundleID() ~= "com.google.Chrome" then return false end
  local ok, url = hs.osascript.applescript(
    'tell application "Google Chrome" to get URL of active tab of front window')
  return ok and type(url) == "string" and url:find("^https://lucid%.app/lucidchart/") ~= nil
end

-- GOOGLE SHEETS MACROS: ctrl+shift+i -> cmd+opt+shift+1, ctrl+shift+k -> cmd+opt+shift+2.
-- Google Sheets assigns imported macros the shortcuts cmd+opt+shift+1..9, which are awkward
-- to reach. These give the first two macros a home-row-friendly chord instead.
-- This lives in Hammerspoon (not karabiner.edn) because the requirement is "only in a Sheets
-- tab": Karabiner can see the frontmost app but not the active tab's URL, so a Karabiner rule
-- would fire on every Chrome tab. chromeSheetActive() (defined above) checks the URL, and only
-- runs when the chord is actually pressed, so it adds no typing lag.
-- Note: use the LEFT control key — Karabiner turns right_control into F2 (tap) / the
-- MEGA layer (hold), so it never sends ctrl.
local SHEETS_MACRO_KEYS = { i = "1", k = "2" }
sheetsMacroChords = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    local f = e:getFlags()
    -- Require ctrl+shift exactly, with neither cmd nor alt (fn allowed).
    if not (f.ctrl and f.shift and not f.cmd and not f.alt) then return false end

    local map = hs.keycodes.map
    local target
    for key, number in pairs(SHEETS_MACRO_KEYS) do
        if e:getKeyCode() == map[key] then target = number end
    end
    if not target then return false end

    if chromeSheetActive() then
        hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, target, 0)
        return true                                -- swallow the original ctrl+shift+i/k
    end
    return false                                   -- not Sheets: let the key pass through unchanged
end)
sheetsMacroChords:start()

-- FIGMA FONT SIZE: ctrl+shift+, -> cmd+shift+, (smaller), ctrl+shift+. -> cmd+shift+. (bigger).
-- Gives a universal ctrl+shift+,/. "font size" chord; Figma's own keys use cmd instead of ctrl.
-- Fires in the Figma desktop app, or in Chrome/Firefox when the active tab is Figma. This lives
-- in Hammerspoon (not karabiner.edn) because Karabiner can't see which browser tab is active.
-- Chrome is checked by URL (same AppleScript as chromeSheetActive). Firefox has no AppleScript
-- URL access, so it's checked by window title instead: Firefox's window title is the active
-- tab's title, and Figma tabs end in "Figma" (e.g. "My File – Figma").
-- Same left-control note as sheetsMacroChords above.
local FIGMA_FONT_KEYS = { ",", "." }

local function figmaActive()
  local app = hs.application.frontmostApplication()
  if not app then return false end
  local id = app:bundleID()
  if id == "com.figma.Desktop" then return true end
  if id == "com.google.Chrome" then
    local ok, url = hs.osascript.applescript(
      'tell application "Google Chrome" to get URL of active tab of front window')
    return ok and type(url) == "string" and url:find("^https://www%.figma%.com/") ~= nil
  end
  if id ~= "org.mozilla.firefox" then return false end
  local win = hs.window.focusedWindow()
  local title = win and win:title() or ""
  return title:find("Figma$") ~= nil or title:find("Figma — Mozilla Firefox$") ~= nil
end

figmaFontSize = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    local f = e:getFlags()
    -- Require ctrl+shift exactly, with neither cmd nor alt (fn allowed).
    if not (f.ctrl and f.shift and not f.cmd and not f.alt) then return false end

    local map = hs.keycodes.map
    local target
    for _, key in ipairs(FIGMA_FONT_KEYS) do
        if e:getKeyCode() == map[key] then target = key end
    end
    if not target then return false end

    if figmaActive() then
        hs.eventtap.keyStroke({ "cmd", "shift" }, target, 0)
        return true                                -- swallow the original ctrl+shift+,/.
    end
    return false                                   -- not Figma: let the key pass through unchanged
end)
figmaFontSize:start()

-- HYPER+': arrives here as F16 (emitted by Karabiner).
--   Figma (desktop app, or a Figma tab in Chrome/Firefox) -> cmd+\ (show/hide UI)
--   Chrome Lucidchart tab                                 -> option+shift+f
--   anywhere else                                         -> nothing
-- Must come after figmaActive() is defined, since Lua locals are only visible below them.
hs.hotkey.bind({}, "f16", function()
  if figmaActive() then
    hs.eventtap.keyStroke({ "cmd" }, "\\", 0)
  elseif chromeLucidActive() then
    hs.eventtap.keyStroke({ "alt", "shift" }, "f", 0)
  end
end)

-- GOOGLE SHEETS SORT/FILTER MENU: option+down -> cmd+ctrl+r, only in a Sheets tab.
-- Ported out of karabiner.edn on 9/14/26. Karabiner could only scope this to "Chrome or
-- Firefox is frontmost", which killed option+down (end-of-paragraph) in every text field
-- in the browser — Gmail compose, Slack, comment boxes. chromeSheetActive() narrows it to
-- an actual spreadsheet URL, so option+down behaves normally everywhere else.
-- Two deliberate trade-offs:
--   1. Inside Sheets this overrides the native option+down (next sheet tab). That key is
--      already covered by ctrl+pagedown (see sheetsCtrlPageNav above), which is the Excel
--      chord being preserved, so option+down is free to reuse here.
--   2. The isSynthetic() check is load-bearing: sheetsCtrlPageNav posts option+down itself,
--      and without the tag this tap would eat it and break ctrl+pagedown.
-- Chrome only — Karabiner's version also covered Firefox, but the URL check is
-- Chrome-specific AppleScript, so Firefox loses this mapping.
sheetsFilterMenu = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    if isSynthetic(e) then return false end        -- our own next-sheet keystroke: pass through

    local f = e:getFlags()
    -- Require option alone, with none of ctrl/cmd/shift (fn allowed).
    if not (f.alt and not f.ctrl and not f.cmd and not f.shift) then return false end

    if e:getKeyCode() ~= hs.keycodes.map.down then return false end

    if chromeSheetActive() then
        hs.eventtap.keyStroke({ "cmd", "ctrl" }, "r", 0)
        return true                                -- swallow the original option+down
    end
    return false                                   -- not Sheets: let the key pass through unchanged
end)
sheetsFilterMenu:start()

-- CHROME TAB SEARCH FROM ANY APP: hyper+o arrives here as F19 (emitted by Karabiner),
-- but only when Chrome is NOT frontmost -- inside Chrome, Karabiner sends cmd+shift+a directly.
-- Brings forward exactly ONE Chrome browser window, then opens tab search (cmd+shift+a).
-- Which window:
--   1. The topmost Chrome window that is at least partly showing on any monitor, so
--      whenever possible nothing you were looking at gets covered.
--   2. Otherwise, the most recently used Chrome window on the current Space.
--   3. Otherwise (Chrome not running, or only minimized windows): do nothing.
-- Chrome App windows (Slack, Calendar, Meet) report their own bundle IDs
-- (com.google.Chrome.app.*), so the exact bundle-ID check skips them.
-- Uses window:focus() instead of activating Chrome, because activating the app (what
-- AppleScript's "activate" / "set frontmost" do) brings EVERY Chrome window forward.
local CHROME_ID = "com.google.Chrome"
local MIN_VISIBLE_AREA = 10000   -- px²: a sliver smaller than ~100x100 doesn't count as "showing"

-- Pieces of rectangle r left over after cutting out rectangle c (0 to 4 rectangles).
local function subtractRect(r, c)
  local x1, y1 = math.max(r.x, c.x), math.max(r.y, c.y)
  local x2, y2 = math.min(r.x + r.w, c.x + c.w), math.min(r.y + r.h, c.y + c.h)
  if x1 >= x2 or y1 >= y2 then return { r } end   -- no overlap: r is untouched
  local pieces = {}
  if r.y < y1 then table.insert(pieces, { x = r.x, y = r.y, w = r.w, h = y1 - r.y }) end                -- strip above
  if y2 < r.y + r.h then table.insert(pieces, { x = r.x, y = y2, w = r.w, h = r.y + r.h - y2 }) end    -- strip below
  if r.x < x1 then table.insert(pieces, { x = r.x, y = y1, w = x1 - r.x, h = y2 - y1 }) end            -- strip left
  if x2 < r.x + r.w then table.insert(pieces, { x = x2, y = y1, w = r.x + r.w - x2, h = y2 - y1 }) end -- strip right
  return pieces
end

-- How many px² of `frame` are not covered by any of `coveringFrames`.
local function uncoveredArea(frame, coveringFrames)
  local pieces = { frame }
  for _, c in ipairs(coveringFrames) do
    local remaining = {}
    for _, p in ipairs(pieces) do
      for _, q in ipairs(subtractRect(p, c)) do table.insert(remaining, q) end
    end
    pieces = remaining
    if #pieces == 0 then return 0 end
  end
  local area = 0
  for _, p in ipairs(pieces) do area = area + p.w * p.h end
  return area
end

-- Walk on-screen windows front to back, remembering every frame above the current one.
local function pickChromeWindow()
  if not hs.application.get(CHROME_ID) then return nil end   -- not running: do nothing
  local above, mostRecent = {}, nil
  for _, w in ipairs(hs.window.orderedWindows()) do
    local app = w:application()
    if app and app:bundleID() == CHROME_ID and w:isStandard() then
      mostRecent = mostRecent or w
      if uncoveredArea(w:frame(), above) >= MIN_VISIBLE_AREA then return w end
    end
    table.insert(above, w:frame())
  end
  return mostRecent
end

-- Global (not local) so the timer isn't garbage-collected mid-wait.
chromeTabSearchTimer = nil

local function chromeTabSearch()
  local win = pickChromeWindow()
  if not win then return end
  win:focus()
  -- Wait (up to ~1s) until Chrome is actually frontmost, so cmd+shift+a can't
  -- land in the app we just left.
  if chromeTabSearchTimer then chromeTabSearchTimer:stop() end
  local tries = 0
  chromeTabSearchTimer = hs.timer.doEvery(0.05, function()
    tries = tries + 1
    local front = hs.application.frontmostApplication()
    if front and front:bundleID() == CHROME_ID then
      chromeTabSearchTimer:stop()
      hs.eventtap.keyStroke({ "cmd", "shift" }, "a", 0)
    elseif tries >= 20 then
      chromeTabSearchTimer:stop()
    end
  end)
end

hs.hotkey.bind({}, "f19", chromeTabSearch)   -- hyper+o outside Chrome

-- CHROME VERTICAL TABS TOGGLE: hyper+; in Chrome arrives here as the URL
-- hammerspoon://toggle-vertical-tabs (opened by Karabiner). Clicks the View menu's
-- "Collapse Vertical Tabs" item instead of sending cmd+shift+l, because pages like
-- Google Docs swallow cmd+shift+l ("left align"). The item is a checkbox: its name
-- stays the same and a checkmark means collapsed, so one click toggles either way.
-- URL names must be lowercase -- macOS lowercases them before Hammerspoon sees them.
hs.urlevent.bind("toggle-vertical-tabs", function()
  local app = hs.application.get("com.google.Chrome")
  if not app then return end
  if not app:selectMenuItem({ "View", "Collapse Vertical Tabs" }) then
    hs.alert.show('Chrome\'s View menu has no "Collapse Vertical Tabs" item')
  end
end)

-- JUMP TO A NAMED CHROME TAB: MEGA (RCTRL) + a letter arrives here as a spare F-key
-- (emitted by Karabiner). Each binding at the bottom names one exact tab title.
-- Finds the Chrome tab with that title, makes it the active tab in its window, and
-- brings forward ONLY that window (same window:focus() approach as chromeTabSearch
-- above, so other Chrome windows stay where they are).
-- If several tabs match, picks the most recently OPENED one: Chrome numbers tabs in
-- creation order, so the highest tab id wins. Chrome can't report "most recently viewed".
-- If none is open (or Chrome isn't running), shows an alert and does nothing else.
-- Titles must not contain a double quote (") -- it would break the AppleScript below.

-- Returns {left, top, right, bottom} of the window holding the newest matching tab,
-- after switching that window to the tab; returns "NONE" if no tab matches.
-- Reads all titles/ids of a window in one request each, which stays fast with many tabs.
local function chromeTabScript(title)
  return [[
tell application "Google Chrome"
  set bestTabId to -1
  set bestWinId to missing value
  set bestIdx to 0
  repeat with w in every window
    set titles to title of every tab of w
    set ids to id of every tab of w
    repeat with i from 1 to count of titles
      if item i of titles is "]] .. title .. [[" then
        set tid to (item i of ids) as number  -- ids exceed AppleScript's integer range
        if tid > bestTabId then
          set bestTabId to tid
          set bestWinId to id of w
          set bestIdx to i
        end if
      end if
    end repeat
  end repeat
  if bestWinId is missing value then return "NONE"
  set active tab index of window id bestWinId to bestIdx
  return bounds of window id bestWinId
end tell
]]
end

-- AppleScript and Hammerspoon describe windows differently, so match on position/size.
local function sameFrame(f, b)
  local tol = 2
  return math.abs(f.x - b[1]) <= tol and math.abs(f.y - b[2]) <= tol
     and math.abs(f.x + f.w - b[3]) <= tol and math.abs(f.y + f.h - b[4]) <= tol
end

-- Global (not local) so the timer isn't garbage-collected mid-wait.
-- Shared by all bindings: pressing a second one cancels a first that's still waiting.
namedTabTimer = nil

local function jumpToChromeTab(title)
  local notFound = 'No "' .. title .. '" tab open'
  -- Check first: AppleScript's "tell application" would otherwise LAUNCH Chrome.
  if not hs.application.get(CHROME_ID) then hs.alert.show(notFound) return end
  local ok, bounds = hs.osascript.applescript(chromeTabScript(title))
  if not ok or type(bounds) ~= "table" then hs.alert.show(notFound) return end

  -- Two maximized windows on one monitor share a frame, so also require the window
  -- title to show the target tab. Chrome updates the title a moment after the tab
  -- switch, so poll (up to ~1s); on timeout, settle for the frame match alone.
  if namedTabTimer then namedTabTimer:stop() end
  local tries = 0
  namedTabTimer = hs.timer.doEvery(0.05, function()
    tries = tries + 1
    local app = hs.application.get(CHROME_ID)
    local match, fallback
    for _, w in ipairs(app and app:allWindows() or {}) do
      if w:isStandard() and sameFrame(w:frame(), bounds) then
        fallback = fallback or w
        if (w:title() or ""):find(title, 1, true) then match = w break end
      end
    end
    local win = match or (tries >= 20 and fallback) or nil
    if win or tries >= 20 then
      namedTabTimer:stop()
      if win then
        if win:isMinimized() then win:unminimize() end
        win:focus()
      else
        hs.alert.show('Found "' .. title .. '" tab but couldn\'t raise its window')
      end
    end
  end)
end

-- Karabiner key -> F-key map lives in karabiner.edn ("MEGA (RCTRL) + ..." rules).
-- Hammerspoon can only see F13-F20; F16-F19 are taken (Lucidchart, zoom, tab search),
-- so after these, only F14-F15 are left (and MonitorControl treats those as brightness).
hs.hotkey.bind({}, "f20", function() jumpToChromeTab("ELEMENT - Google Docs") end)  -- MEGA + e
hs.hotkey.bind({}, "f13", function() jumpToChromeTab("CATCHALL: Lucidchart") end)   -- MEGA + c

-- Out of usable F-keys, so newer bindings arrive as hammerspoon:// links instead
-- (Karabiner runs `open -g 'hammerspoon://<name>'`). Names must be lowercase.
hs.urlevent.bind("jump-tab-dash", function()
  jumpToChromeTab("DASH - Service Workflowers: Lucidchart")
end)  -- MEGA + d
