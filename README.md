# Dotfiles - Mac

This repository contains my dotfiles and my `karabiner.edn` file, which holds a
suite of shortcut configurations for basically everything I do on my Mac.

## A Note for Normal, Sane People 🙃

I don't worry about shortcuts because I want to use my computer more efficiently
(although I certainly hope that that's true). I spend time configuring shortcuts
because it's fun, because it makes me think critically about how I accomplish my
work, and because I like thinking of my computer like an instrument that I can
play to make awesome things happen.

If you're either:
A) not comfortable with basic software development concepts or
B) not ready to spend a weekend (even with Claude) fooling around with setting
up `goku`, `karabiner-elements`, and `hyperspoon` (the key workhorses of my
setup), I wouldn't recommend starting with the setup that I have here.

Instead, probably the single thing that I've done to make using my computer more fun and
(at least subjectively, faster) is to start using [Vimium
C](https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?hl=en),
which is a browser extension that embeds shortcuts on browser pages. Watch [this
tutorial for Vimium C's cousin,
Vimium](https://youtu.be/jeRSReSbxjw?si=6yLO9h7AM3vbNc2N) (I prefer Vimium C
over Vimium because it can do even more than Vimium) - this has been HUGE for
me.

Other game changers have been:

- Alfred for a enhanced version of Mac's spotlight.
- BetterTouchTool (for custom scripts to cycle between windows, this is the driver behind a custom application that I produced that lets me cycle through windows of a specific application with the right-shift key which I otherwise don't use -- right shift+G = Granola; right shift+S = Slack; right shift+C = Claude, etc).
- Rectangle (for moving windows)

All of these have their own configurable shortcuts and can open worlds of possibilities.

## Dotfiles & Dotbot

Thanks to Patrick McDonald for the guidance and inspiration in his [Udemy
course](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/) on how
to set up dotfiles. Patrick's course uses [Dotbot](https://github.com/anishathalye/dotbot),
which was developed by Anish Athalye.

For an overview of the dotfiles structure, see video 81 of Patrick's course,
"Cultivate Skills Section Conclusion."

`install.conf.yaml` is the source of truth for what gets symlinked where.

Note: dotbot is a submodule in this repository. To clone this repo fresh
elsewhere, use:

`git clone --recurse-submodules`

## Karabiner & Hammerspoon Shortcuts

First, I have to thank the incredible [Chris
May](https://everydaysuperpowers.dev/) — a true computer whisperer — who
inspired me to take up this initiative, turned me on to the resources below,
and opened my eyes to the incredibly powerful world of customizing your
keyboard 🙏.

The setup in this repo is inspired by Andrew Morgan's blog post [How To Train
Your Keyboard](https://tighten.com/insights/how-to-train-your-keyboard/).
Andrew uses the Hammerspoon Spoons in his [Hyperspoon
repo](https://github.com/andrewmile/hyperspoon); I have `Hyper.spoon` and
`Helpers.spoon` downloaded in `~/.hammerspoon/Spoons/`, but `init.lua` does not
currently load them — the layer logic lives in `karabiner.edn` instead.

### How the pieces fit together

Karabiner-Elements stores its config as JSON, which gets unreadable fast. So
instead of editing that JSON, I write the config in EDN (a Clojure-flavored
syntax) and let [goku](https://github.com/yqrashawn/GokuRakuJoudo) compile it
down. The chain:

1. I edit `karabiner.edn` — layers and mappings in readable EDN.
2. Hammerspoon watches that file. On save it runs `goku`, which compiles the
   EDN into `karabiner.json`. Hammerspoon only *triggers* the compile; goku
   does the translating.
3. Karabiner-Elements reads the JSON and does all the key interception itself.
   A chord like caps+w+i fires a `rectangle-pro://` URL straight from
   Karabiner — Hammerspoon is not involved.
4. Hammerspoon handles only what Karabiner can't see, since Karabiner has no
   idea what browser tab you're on. For the Google Sheets rules, Karabiner
   emits F17/F18 and Hammerspoon checks the tab URL before acting.

Practical consequence: if a chord stops working, the problem is almost always
Karabiner (or its permissions), not Hammerspoon. See the troubleshooting
section in `CLAUDE.md`.

### Karabiner Shortcut Files Overview

| File | Symlinked to | Role |
| ----- | ----- | ----- |
| `./karabiner.edn` | `~/.config/karabiner.edn` | Goku source file — where layers and mappings are specified |
| `./init.lua` | `~/.hammerspoon/init.lua` | Hammerspoon config — recompiles the EDN on save, plus the URL-aware rules Karabiner can't express |
