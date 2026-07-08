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
        hs.eventtap.keyStroke({ "alt" }, dir, 0)  -- Alt(Option)+Down / +Up
        return true                                -- swallow the original Ctrl+PageDown/Up
    end
    return false                                   -- not Sheets: let the key pass through unchanged
end)
sheetsCtrlPageNav:start()
