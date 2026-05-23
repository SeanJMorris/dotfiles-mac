# Dotfiles

## To Do

### BTT

1. When switching between windows, it might seem like it selects the next window but doesn't actually. Happens specifically when in an insert mode (e.g. Notes open in Firefox, or a terminal window with Claude running).
2. Doesn't appropriately select windows with right Shift + x for Excel — even though you select one, it doesn't actually become active. Maybe related to insert mode?
3. Create a SHIFT option with the right shift BTT tools to open a new instance of the app (so you don't have to navigate to the app and then do cmd+N).
4. When any key other than the current app-switcher key is pressed, stop the current switcher and allow switching to another.
5. Use right shift + o to cycle through non-otherwise-specified apps.

### Alt-Tab

1. Implement a fix to go forward and back with hyper+i and hyper+u.
2. Find better shortcut for tab creation and tab closing — hyper+t/w conflict with alt-tab.

### Alfred

1. The shortcut to go to a specific tab brings all windows to the front.
2. Fix Alfred not showing same options as standard Spotlight.
3. Banner be gone doesn't work with Granola and Zoom messages.
4. Make the modal appear on all windows instead of just one.

```clojure
  ;; TRIED TO IMPLEMENT THIS, BUT REALIZED IT CONFLICTS WITH WINDOW MANAGEMENT (W) AND ALT-TAB (T)
  ;;{:des "Hyper+t/w for new tab creation and tab closing"
  ;; :rules [[:t :!St ["hyper" 1]]]
  ;;         [:w :!Sw ["hyper" 1]]]}```
