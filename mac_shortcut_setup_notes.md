# Setup Notes for Lyven Project

By Sean Morris

The Lyven Project is Sean's productivity setup using the following files:

| File | Tool | Description |
| ----- | ---- | ----------- |
| `~/.config/karabiner.edn` | Goku File -> Karabiner JSON | Place where layers and mappings are specified |
| `~/.hammerspoon/init.lua` | Hammerspoon Lua File | Defines what the signals from Karabiner actually do. |

In sum: The karabiner.edn file captures the keystrokes and Hammerspoon acts on it.

This shortcut configuration setup is inspired by the work of Andrew Morgan as
shared in this blog post: [How To Train Your
Keyboard](https://tighten.com/insights/how-to-train-your-keyboard/)

Andrew makes use of the following Hammerspoon Spoons in this [Hyperspoon Github
Repo](https://github.com/andrewmile/hyperspoon), which I have downloaded into my Hammerspoon Spoons directory:

- `~/.hammerspoon/Spoons/Hyper.spoon`
- `~/.hammerspoon/Spoons/Helpers.spoon`

## File Locations for Reference

| Command | Output |
| --------- | ----------- |
| `which karabiner_cli` | `/opt/homebrew/bin/karabiner_cli` |
| `which goku` | `/opt/homebrew/bin/goku` |
| `which hs` | `/opt/homebrew/bin/hs` |

## Sean's Setup Notes

Install Karabiner-Elements
`brew install --cask karabiner-elements`
System Settings > Privacy & Security > Accessibility and toggle Hammerspoon On.
System Settings > Notifications > Application Notifications, Turn Hammerspoon On.

Install Goku
`brew install yqrashawn/goku/goku`

To run Goku as a background service (instead of manually) so that it runs in
the background and sets itself up as a system0level process and starts itself
in the background when you start your computer
`brew services start yqrashawn/goku/goku`

`brew install --cask hammerspoon` Then follow instructions on this great Youtube
Video by Diego Zamboni (<https://youtu.be/s9MfRDBriVs?t=68>) to download
<https://www.hammerspoon.org/Spoons/SpoonInstall.html> with which you can
install other spoons from the spoon community more quickly and easily.  which
you can do via the terminal with: I could have tried to do this all with the
terminal (see below), but it didn't seem worth it, so I downloaded it manually
from <https://www.hammerspoon.org/Spoons/SpoonInstall.html>, then unzipped the
file and updated init.lua ✅.  Maybe later attempt to download SpoonInstall Spoon
via the terminal `cd ~/.hammerspoon/Spoons` `curl -LO
https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip`
I included the "gokuWatcher" section in init.lua as per Andrew Morgan's
instructions, but because I had used Diego's SpoonInstall spoon, I didn't need
to use the extra code to start ReloadConfiguration and send the notification
that the Config is loaded ✅.

I created karabiner.edn in ~/.config/ - apparently Goku doesn't do it for you.

When I ran `brew services start yqrashawn/goku/goku`, it said: "Successfully
started `goku` (label: homebrew.mxcl.goku)"

I copied Helpers.spoon and Hyper.spoon into my ~/.hammerspoon/Spoons directory
as per instructions (see <https://github.com/andrewmile/hyperspoon/tree/main>)

I put the code that the Tighten article said to in karabiner.edn but I got an
error from Hammerspoon and AI said that I had to install ModalMgr spoon. I
didn't really learn what this was, but I did it anyway.

I had to change the name of the default profile in Karabiner elements from
"Default profile" so simply "Default" because I was getting an error.
After that, you have to simply enter `goku` (i did it in ~/.config) and got a
message that said "Done!"

After all of this, my command key stopped working entirely. I couldn't use it
to copy or to close the tab of a browser. Claude suggested that I edit the
standard Karabiner.edn code that the author had suggested so that I would use
the Hyper key instead.

I wrote to Chris May to ask for advice on 4/26/26 but then realized that I could
just work basically without the hammerspoon rigging - so just making changes to
karabiner.edn. So then on 4/25/26, I started using Claude to make the edits. For
the o-layer, I used the [ruby file
here](https://github.com/NylonDiamond/o-launcher-script/blob/master/CreateLauncherModeTemplate.rb#L28)
that was recommended by the maker of this good [Karabiner
Tutorial](https://youtu.be/PBPS2D9AKtI?t=1026) and used Claude to turn the Ruby
file into Goku.

On the possibility of a tool to switch applications AND cycle through windows. I
made a PRD with claude - see btt-window-cycling-prd.md but concluded that it was
a huge quagmire rife with potential pitfalls and probably not worth it right now.
I will come back to this later - for now just create another shortcut to cycle
through windows of application with another o-layer. It's also not clear that
the best solution ISN'T something that combines ALT+Tab's ability to do ths with
a given application with some other kind of shortcut. Maybe I could still jerry
rig this...

On 5/2/26, I made two PRDs with claude foa a spatial windows management feature
(to navigate around only visible windows) and an application activation AND
cycling shortcut (an alt tab + window selector baked into one). Both were super
duper complicated.

## Issue with Previous and Next Display with Rectangle

On 5/3/26, I noticed that the previous-display and the next-display behavior
were not maintaining the position relative to the display. None of the below
worked:

```clojure
[{:key :j :modi {:optional [:any]}} [:rect "previous-display"] ["hyper_sublayer_w" 1]]
[{:key :k :modi {:optional [:any]}} [:rect "next-display"]     ["hyper_sublayer_w" 1]]
[{:key :j :modi {:optional [:any]}} [:rect "move-to-previous-display"] ["hyper_sublayer_w" 1]]
[{:key :k :modi {:optional [:any]}} [:rect "move-to-next-display"]     ["hyper_sublayer_w" 1]]
[{:key :j :modi {:optional [:any]}} [:rect "previous-display-ratio"] ["hyper_sublayer_w" 1]]
[{:key :k :modi {:optional [:any]}} [:rect "next-display-ratio"]     ["hyper_sublayer_w" 1]]
```

It was also the case that even when I remapped the shortcuts in rectangle, which
DID work when I used the shortcuts directly (cmd+f9) didn't work when I remapped them like this:

```clojure
[{:key :j :modi {:optional [:any]}} :!Cf10 ["hyper_sublayer_w" 1]]
[{:key :k :modi {:optional [:any]}} :!Cf9  ["hyper_sublayer_w" 1]]
```

This is still unresolved as of 5/3/26 and I don't have a good workaround! Next
steps would be to see if I can find the explicit command that rectangle uses,
but this didn't exist in [the
documentation](https://github.com/rxhanson/rectangle) (there is nothing other
than next-display and previous-display!!!). I guess I could try using the free
version of raycast.

## To Do Notes as of 5/3/26

Consider configuring windows key to also have tab navigation and new tab creation.

1. Next Up
   - Vim-Navigation
   - Bookmarks
   - Other Alfred Actions
2. Spatial window management may just be a pipe dream, but it's
still possible and could be worth it!
3. Implement the following:

```clojure
{:des "simultaneous left-shift right-shift press to ctrl+[ held for 1 second"
:rules [{:type :basic
         :from {:simultaneous [{:key_code :left_shift} {:key_code :right_shift}]
                  :simultaneous_options {:key_up_when :any}}
         :to [{:key_code :open_bracket :modifiers [:left_control] :hold_down_milliseconds 1000}]}]}]
```
