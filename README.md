# Dotfiles - Mac

This repository contains my dotfiles, my karabiner customization files, my excel and
Google Sheets customizations files, and any other files which, if my Mac were
hit by an asteroid, I would want set up on a new machine first thing. I cannot
imagine working professionally without these files.

## Why I Do This

I don't spend time configuring shortcuts because it makes me more efficient per
se. I spend time configuring shortcuts because it's fun, because it makes me
think critically about how I accomplish my work, and because I like thinking of
my computer like an instrument that I can play to make awesome things happen.

An inspiring treatment of the topic of getting better at something, I refer to
this fascinating article: [The Physical
Genius](https://www.newyorker.com/magazine/1999/08/02/the-physical-genius).

## Making Use of What's Here - Beginners

If you're interested in getting started with configuring your shortcuts, I
recommend starting with downloading a free browser extension called [Vimium
C](https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?hl=en),
which is a browser extension that embeds shortcuts on browser pages and makes it
faster for you to scroll, click, and navigate around the web. The benefit of
learning this is that you'll indirectly be learning a lot of Vim shortcuts (see
the **Why Vim** section below).  Watch [this
tutorial for Vimium C's cousin,
Vimium](https://youtu.be/jeRSReSbxjw?si=6yLO9h7AM3vbNc2N) (I prefer Vimium C
over Vimium because it can do even more than Vimium) - this has been HUGE for
me. There is a learning curve but, for me it's been well worth it.

Similar to Vimium C is [AutoHotKey](https://www.autohotkey.com/), which is free
and puts shortcuts on your entire screen (even outside of your browser).

Other game changers that I pay for are:

- Alfred for a enhanced version of Mac's spotlight search.
- BetterTouchTool (for custom scripts to cycle between windows, this is the driver behind a custom application that I produced that lets me cycle through windows of a specific application with the right-shift key which I otherwise don't use -- right shift+G = Granola; right shift+S = Slack; right shift+C = Claude, etc).
- Rectangle (for moving windows)

All of these have their own configurable shortcuts and can open worlds of
possibilities.

### Why Vim?

It's hard to imagine, but in the early days of computing **there was no mouse**,
which meant that users had to do everything from the keyboard. Navigating around
text, accessing files, selecting text, copying and pasting -- everything had to
be done without a mouse. Vim was a text editor that helped give you quick access
to different ways of doing things faster. The key part about Vim is that it's
**modal**. You know how if you press the `c` key with and without `command` then
its behavior changes That `cmd` key is **modal**; it changes the **mode** of the
keyboard such that all keys behave differently than their normal default.

Vim already had an extremely sophisticated and integrated way of doing most
key operations. That's important because it means that you don't need to
reinvent the wheel with YOUR shortcut configurations. Instead, it makes more
sense to just borrow from a coherent and comprehensive system that already
exists!

With my karabiner setup, I extend this concept of modality such that I can
create wholly new modes by pressing other keys in combination. The key
organizing feature is how I use my `Caps Lock` key. Normally to me, `Caps Lock`
is pretty useless and it takes up valuable real estate on your keyboard, so in
my `karabiner.edn`, I've set up the `Caps Lock` key to have one behavior if I
tap it quickly (it becomes the escape key, which I use extremely often) and a
different behavior if I hold it down (it becomes what's called a **hyper** key
which is that it acts as if I'm pressing down cmd, ctrl, shift, and alt all
together). My hyper key can be used in combination with other keys to make whole
new modes in other parts of my keyboard. People sometimes call these
combinations 'chords' because it's like making different sounds on an instrument
by holding down different keys in combination. It's just that, with my setup,
it's an instrument that **you** make.

## Making Use of What's Here - Advanced Users

If you are:
A) Comfortable with some basic software development concepts
B) Ready to spend a weekend (even with Claude) fooling around to get things set up
C) Just very enthusiastic about shortcuts

Then you are well suited to use the patterns that I employ here to set up the
key workhorses of my setup: `goku`, `karabiner-elements`, and `hyperspoon`. Read
more in the following section.

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

## Dotfiles & Dotbot

For how to set up and use dotbot to backup your dotfiles, I refer to Patrick McDonald's [Udemy
course](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/) on how
to set up dotfiles. Patrick's course uses [Dotbot](https://github.com/anishathalye/dotbot),
which was developed by Anish Athalye.

For an overview of the dotfiles structure, see video 81 of Patrick's course,
"Cultivate Skills Section Conclusion."

`install.conf.yaml` is the source of truth for what gets symlinked where.

Note: dotbot is a submodule in this repository. To clone this repo fresh
elsewhere, use:

`git clone --recurse-submodules`

Practically speaking though, I've never thought it makes sense to copy someone
else's dotfiles. It'd be like trying to copy someone's haircut by cutting their
hair off and putting it on your own head. It's a personal thing and it matters
that YOU are the one to set it up in a way that works for you (see the [Making
Use of What's Here - Beginners](#making-use-of-whats-here---beginners) section).
