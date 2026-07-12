async function coreWindowSwitcher() {
  let result = undefined;

  const appName = await get_string_variable({ variable_name: 'btt_ws_app_name' });

  // Per-app "junk" patterns: extra regex fragments (matched against the
  // window/app name) that should ALSO be excluded for a given app. These
  // filter out helper processes and blank "phantom" windows that share the
  // app's name prefix but aren't real windows you'd want to switch to.
  // Add more apps/patterns here if you find the same issue elsewhere.
  const extraExcludesByApp = {
    // Excel creates blank phantom windows whose title is just the app name
    // (optionally followed by a dangling "-"/":" separator).
    'Microsoft Excel': [`^${appName}(\\s*[-:]\\s*)?$`],
    // Firefox spawns background helper processes that macOS exposes as
    // separate apps ("FirefoxCP Privileged Content", "FirefoxCP RDD
    // Process", etc.) — all prefixed "FirefoxCP". The real browser is just
    // "Firefox", so excluding this prefix leaves the real windows intact.
    Firefox: ['^FirefoxCP'],
    Granola: ['^Granola Helper'],
  };

  // Base rule (used for every app): only show windows belonging to the
  // currently focused app (i.e. exclude anything NOT starting with appName).
  // Then append any app-specific junk patterns from the map above.
  const excludeParts = [`^(?!${appName})`, ...(extraExcludesByApp[appName] || [])];
  const excludeRegex = excludeParts.join('|');

  const windowSwitcherConfig = {
    BTTWindowSwitcherHeight: 500,
    BTTWindowSwitcherItemHeight: 30,
    BTTWindowSwitcherWidth: 380,
    BTTMenuScreenUUID: '4D7B1C18-A580-479E-8C5B-1E6E30914A89',
    BTTWindowSwitcherOverrideDefaultShortcuts: false,
    BTTMenuAnchorRelation: 4,
    BTTMenuPositionRelativeTo: 2,
    BTTWindowSwitcherShowThumbnail: 1,
    BTTWindowSwitcherExcludeHiddenAndMinimizedWindows: false,
    BTTWindowSwitcherDisableMouseHover: false,
    BTTWindowSwitcherExcludeAllButHiddenAndMinimizedWindows: false,
    BTTWindowSwitcherSelectNextOnRepeat: true,
    BTTWindowSwitcherExcludeSpecific: true,
    BTTWindowSwitcherInitialFocus: 1,
    BTTWindowSwitcherTriggerOnRelease: true,
    BTTWindowSwitcherFocus: 0,
    BTTWindowSwitcherShowPopover: 4,
    BTTWindowSwitcherAppearance: 0,
    BTTWindowSwitcherExcludeVisibleWindows: false,
    BTTWindowSwitcherFontSize: 12,
    BTTWindowSwitcherExclude: excludeRegex,
    BTTMenuPositioningType: 3,
    BTTMenuAnchorMenu: 4,
    BTTWindowSwitcherSort: 4,
    BTTWindowSwitcherExcludeWindowsFromOtherSpaces: true,
    BTTWindowSwitcherMousePos: 4,
  };

  result = await trigger_action({
    json: JSON.stringify({
      BTTIsPureAction: 1,
      BTTPredefinedActionType: 100,
      BTTPredefinedActionName: 'Show Window Switcher for All Open Apps',
      BTTAdditionalActionData: JSON.stringify(windowSwitcherConfig),
    }),
    wait_for_reply: true,
  });

  return true;
}
