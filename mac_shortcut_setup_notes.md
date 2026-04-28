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

`brew install --cask hammerspoon`
Then follow instructions on this great Youtube Video by Diego Zamboni
(<https://youtu.be/s9MfRDBriVs?t=68>) to download <https://www.hammerspoon.org/Spoons/SpoonInstall.html>
with which you can install other spoons from the spoon community more quickly and easily.
which you can do via the terminal with:
I could have tried to do this all with the terminal (see below), but it didn't seem worth it, so I downloaded it manually from
<https://www.hammerspoon.org/Spoons/SpoonInstall.html>, then unzipped the file and updated init.lua ✅.
Maybe later attempt to download SpoonInstall Spoon via the terminal
`cd ~/.hammerspoon/Spoons`
`curl -LO https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip`

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

I wrote to Chris May to ask for advice on 4/26/26 but then realized that I could just work basically without the hammerspoon rigging - so just making changes to karabiner.edn. So then on 4/25/26, I started using Claude to make the edits. For the o-layer, I used the [ruby file here](https://github.com/NylonDiamond/o-launcher-script/blob/master/CreateLauncherModeTemplate.rb#L28) that was recommended by the maker of this good [Karabiner Tutorial](https://youtu.be/PBPS2D9AKtI?t=1026) and used Claude to turn the Ruby file into Goku.
