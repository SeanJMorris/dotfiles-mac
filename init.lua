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
