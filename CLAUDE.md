# Dotfiles

## To Do

1. With BTT, it's the case that when i switch between windows, it might seem like it selects the next window but doesn't actually. I've noticed it before specifically when I'm in an app where I am in an insert mode (like when I have Notes open in Firefox and want to switch to another window of Firefox).
2. Implement a fix for Alt-tab to be able to go forward and back with hyper+r and hyper+t.
3. The Alfred Shortcut to go to a specific tab brings all windows to the front.
4. Fix Alfred not showing same options as standard spotlight.
5. BTT doesn't appropriately select windows with right Shift + x for excel. even though you select one, it doesn't actually become active. Maybe this has to do with when you're in an insert mode?
6. Alfred - banner be gone doesn't work with Granola and Zoom messages.
7. Alfred - make the modal appear on all windows instead of just one.
8. Find better shortcut for tab creation and tab closing bc hyper t/w conflict with alt-tab.

```clojure
  ;; TRIED TO IMPLEMENT THIS, BUT REALIZED IT CONFLICTS WITH WINDOW MANAGEMENT (W) AND ALT-TAB (T)
  ;;{:des "Hyper+t/w for new tab creation and tab closing"
  ;; :rules [[:t :!St ["hyper" 1]]]
  ;;         [:w :!Sw ["hyper" 1]]]}```
