--  _       _ _     _
-- (_)_ __ (_) |_  | |_   _  __ _
-- | | '_ \| | __| | | | | |/ _` |
-- | | | | | | |_ _| | |_| | (_| |
-- |_|_| |_|_|\__(_)_|\__,_|\__,_|

-- See https://youtu.be/s9MfRDBriVs?t=74 https://www.hammerspoon.org/Spoons/SpoonInstall.html
-- This is a very easy way to add new Spoons - you can just put the name of the
-- spoon and it downloads and starts it automatically
hs.loadSpoon("SpoonInstall")

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

-- GOOGLE SHEETS MACROS: ctrl+shift+i -> cmd+opt+shift+1, ctrl+shift+k -> cmd+opt+shift+2.
-- Google Sheets assigns imported macros the shortcuts cmd+opt+shift+1..9, which are awkward
-- to reach. These give the first two macros a home-row-friendly chord instead.
-- This lives in Hammerspoon (not karabiner.edn) because the requirement is "only in a Sheets
-- tab": Karabiner can see the frontmost app but not the active tab's URL, so a Karabiner rule
-- would fire on every Chrome tab. chromeSheetActive() (defined above) checks the URL, and only
-- runs when the chord is actually pressed, so it adds no typing lag.
-- Note: use the LEFT control key — Karabiner remaps right_control to F2, so it never sends ctrl.
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
