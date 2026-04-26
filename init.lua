--  _       _ _     _
-- (_)_ __ (_) |_  | |_   _  __ _
-- | | '_ \| | __| | | | | |/ _` |
-- | | | | | | |_ _| | |_| | (_| |
-- |_|_| |_|_|\__(_)_|\__,_|\__,_|


--BEGIN: ORIGINAL TEST CODE USED AND WORKING DURING SETUP: BEGIN
----------------------------------------------------------------
-- hyper = {"cmd", "alt", "ctrl"}
--
-- hs.hotkey.bind(hyper, "h", function()
--     print("HOTKEY PRESSED!")
--     hs.alert.show("Alert is working")
-- end)
--
-- hs.hotkey.bindSpec({ hyper, "y" }, hs.toggleConsole)
-- hs.hotkey.bindSpec({ hyper, "r" }, hs.reload)
--
-- hs.notify.new({title="Hammerspoon", informativeText="Hammerspoon started!"}):send()
------------------------------------------------------------
--END: ORIGINAL TEST CODE USED AND WORKING DURING SETUP: END

-- See https://youtu.be/s9MfRDBriVs?t=74 https://www.hammerspoon.org/Spoons/SpoonInstall.html
-- This is a very easy way to add new Spoons - you can just put the name of the
-- spoon and it downloads and starts it automatically
hs.loadSpoon("SpoonInstall")

-- ADD SPOONS HERE
--This Spoon allows you to reload your Hammerspoon configuration automatically
    --when you save changes to your init.lua file
spoon.SpoonInstall:andUse("ReloadConfiguration")
spoon.SpoonInstall:andUse("ModalMgr")

-- Watch for changes in the the Goku file called karabiner.edn and notify when changes are detected
-- this makes it such that, when you make changes to your Goku file, it compiles
-- the Goku into the JSON that Karabiner understands
gokuWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/karabiner.edn', function ()
    -- Updated the path below to match your 'which goku' result
    output = hs.execute('/opt/homebrew/bin/goku')
    hs.notify.new({title = 'Karabiner Config', informativeText = output}):send()
end):start()

-- Load "Hyperspoon" and "Helperspoon" which make it easier to manage Hammerspoon.
--hs.loadSpoon('Hyper')
--hs.loadSpoon('Helpers')
--
--slack = 'com.tinyspeck.slackmacgap'
--
--hyper:app(slack)
--    :action('open', {
--        default = combo({'cmd'}, 'k'),
--    })

--hyper:app('fallback')
--    :action('open', {
--        default = combo({'cmd'}, 'o'),
--    })
--    :action('copy', {
--        default = combo({'cmd'}, 'c'),
--    })
--    :action('paste', {
--        default = combo({'cmd'}, 'v'),
--    })
--    :action('insert', {
--        default = combo({'cmd', 'shift', 'option', 'control'}, 'i'), -- Alfred clipboard
--    })
--    :action('alfred', {
--        default = function()
--            hs.osascript.applescript('tell application id "com.runningwithcrayons.Alfred" to search ""')
--        end,
--    })
