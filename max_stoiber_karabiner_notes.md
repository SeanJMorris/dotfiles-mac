# Max Stoiber Karabiner Config — Notes

## Core Concept: Hyper Key + Sublayers

The entire config is built around **caps_lock as a Hyper key** that unlocks a two-level chord system.

**Layer 1 — Hyper key:**

- Holding caps_lock sets `hyper=1`
- Tapping it alone sends Escape

**Layer 2 — Sublayers:** While hyper is held, pressing a second letter activates
*a sublayer variable (`hyper_sublayer_X=1`), cleared on key-up. A third keypress
*executes the action. Each sublayer's activation rule checks that all other
*sublayers are `0` (mutex), so only one sublayer can be active at a time.

This gives a **three-key chord** system (caps + sublayer key + action key), vs.
a two-key chord, providing much more namespace.

---

## Sublayers

| Key | Purpose | Example actions |
| --- | ------- | --------------- |
| `spacebar` | Direct action | Opens a Notion Raycast command |
| `b` | Bookmarks | Opens URLs (Twitter, HN, Reddit, Facebook, Hashnode, calendar) |
| `o` | Open apps | Chrome, Slack, Zoom, Notion, Terminal, Spotify, Discord, Finder… |
| `w` | Window management | Rectangle half/maximize, move between displays, next tab/window, back/forward |
| `s` | System controls | Volume, brightness, lock screen, play/pause, DND toggle, dark mode, camera |
| `v` | Vim-like navigation | hjkl arrows, page up/down, scroll |
| `c` | Media controls | Play/pause, fast-forward, rewind |
| `r` | Raycast commands | Bluetooth devices, color picker, clipboard history, emoji, AI chat, notifications |

### Sublayer `o` — Open Apps (full list)

| Key | App |
| --- | --- |
| `1` | 1Password |
| `g` | Google Chrome |
| `c` | Notion Calendar |
| `v` | Zed |
| `d` | Discord |
| `s` | Slack |
| `e` | Superhuman |
| `n` | Notion |
| `t` | Terminal |
| `h` | Notion (specific page) |
| `z` | Zoom |
| `m` | Reflect |
| `r` | Reflect |
| `f` | Finder |
| `i` | Texts |
| `p` | Spotify |
| `a` | iA Presenter |
| `w` | Texts (shell command) |
| `l` | Raycast short link opener |

### Sublayer `w` — Window Management (full list)

**Positioning** (via Rectangle URL scheme) — spatial keys mirror vim directions:

- `h` / `l` → left half / right half
- `k` / `j` → top half / bottom half
- `f` → maximize
- `y` / `o` → previous display / next display (via Rectangle)
- `d` → next display via keyboard shortcut (`ctrl+opt+cmd+right`) — a second
binding for the same action, likely for a different window manager or as a
fallback

**Tab & window navigation:**

- `u` / `i` → previous tab / next tab (`ctrl+shift+tab` / `ctrl+tab`) — adjacent keys mirroring the left/right relationship
- `n` → next window within the same app (`cmd+backtick`)
- `b` / `m` → browser back / forward (`cmd+[` and `cmd+]`)

**Other:**

- `;` → hide window (`cmd+h`) — corner key, out of the way for a destructive-ish action

The spatial positioning keys (`h`/`j`/`k`/`l`/`f`) deliberately reuse vim
directions. Rectangle is required for the half-screen and display-move actions
since those are triggered via its `rectangle://execute-action` URL scheme rather
than keyboard shortcuts.

| Key | Action |
| --- | ------ |
| `;` | Hide window (cmd+h) |
| `y` | Previous display |
| `o` | Next display |
| `k` | Top half |
| `j` | Bottom half |
| `h` | Left half |
| `l` | Right half |
| `f` | Maximize |
| `u` | Previous tab (ctrl+shift+tab) |
| `i` | Next tab (ctrl+tab) |
| `n` | Next window (cmd+`) |
| `b` | Back (cmd+[) |
| `m` | Forward (cmd+]) |
| `d` | Next display (ctrl+opt+cmd+right) |

### Sublayer `s` — System Controls (full list)

| Key | Action |
| --- | ------ |
| `u` | Volume up |
| `j` | Volume down |
| `i` | Brightness up |
| `k` | Brightness down |
| `l` | Lock screen (ctrl+cmd+q) |
| `p` | Play/pause |
| `;` | Fast-forward |
| `e` | Toggle Elgato key light |
| `d` | Toggle Do Not Disturb |
| `t` | Toggle dark/light mode |
| `c` | Open camera |
| `v` | opt+space (Raycast?) |

### Sublayer `v` — Vim Navigation (full list)

The spatial keys mirror vim directions for cursor movement. Scrolling bindings
use Emacs-style control chords (`ctrl+f`, `ctrl+j`) whose exact behavior is
app-dependent — they work well in Terminal, browser scroll views, and similar.

| Key | Action |
| --- | ------ |
| `h` | ← left arrow |
| `j` | ↓ down arrow |
| `k` | ↑ up arrow |
| `l` | → right arrow |
| `u` | Page Down |
| `i` | Page Up |
| `m` | ctrl+f (Emacs forward-page scroll) |
| `s` | ctrl+j (Emacs scroll-down-line) |
| `d` | shift+cmd+d (bookmark in Chrome / Desktop in Finder) |

### Sublayer `r` — Raycast Commands (full list)

| Key | Action |
| --- | ------ |
| `1` | Connect Bluetooth device 1 |
| `2` | Connect Bluetooth device 2 |
| `c` | Color picker |
| `n` | Dismiss notifications |
| `l` | Create short link |
| `e` | Emoji picker |
| `p` | Confetti |
| `a` | AI chat |
| `s` | Silent mention |
| `h` | Clipboard history |

---

## Outside the Sublayer System

- **Minecraft rule:** backspace → space bar when Minecraft's JVM process is front most
- **fn_function_keys:** F1–F12 remapped to standard macOS media/system keys (brightness, Mission Control, Spotlight, dictation, media playback, volume)

---

## Device Config

Three devices configured:

- Apple keyboard (vendor 1452, product 835) — caps lock LED managed
- Third-party keyboard (vendor 10730, product 864) — caps lock LED managed
- Logitech mouse (vendor 1133, product 45088) — ignored
