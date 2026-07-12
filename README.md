# Dotfiles - Mac

This repository contains my dotfiles and my karabiner.edn file, which contains a
suite of shortcut configurations for basically everything I do on my Mac.

## Dotfiles & Dotbot

Thanks to Patrick McDonald for guidance offered in his [Udemy
course](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/) for how
to set up dotfiles and use [Dotbot](https://github.com/anishathalye/dotbot),
developed by Anish Athalye.

For an overview of the dotfiles structure, see Patrick's video, see video 81:
"Cultivate Skills Section Conclusion" from Patrick's course.

Note: dotbot is a submodule in this repository, if you need to clone this repo
fresh elsewhere, then use

`git clone --recurse-submodules`

## Karabiner & Hammerspoon Shortcuts

First, I have to thank the incredible [Chris
May](https://everydaysuperpowers.dev/) - a true computer whisperer - who
inspired me to take up this initiative , turned me on to the resources below,
and opened my eyes to the incredibly powerful world of customizing your
keyboard.

The shortcut configuration setup used in this repo is inspired by the work of
Andrew Morgan as shared in this blog post: [How To Train Your
Keyboard](https://tighten.com/insights/how-to-train-your-keyboard/) Andrew makes
use of the following Hammerspoon Spoons in this [Hyperspoon Github
Repo](https://github.com/andrewmile/hyperspoon), which I have downloaded into my
Hammerspoon Spoons directory.

- `~/.hammerspoon/Spoons/Hyper.spoon`
- `~/.hammerspoon/Spoons/Helpers.spoon`

### Karabiner Shortcut Files Overview

Basically, the karabiner.edn file captures the keystrokes and Hammerspoon acts
on it. Here's the symlink structure and the general picture.

| File | Symlink Reference | Summary | Description |
| ----- | ---- | ----- | ----------- |
| `./karabiner.edn` | `~/.config/karabiner.edn` | Goku File -> Karabiner JSON | Where layers and mappings are specified (symlinked from ./karabiner.edn) |
| `./init.lua` | `~/.hammerspoon/init.lua` | Hammerspoon Lua File | Defines what the signals from Karabiner actually do. |
