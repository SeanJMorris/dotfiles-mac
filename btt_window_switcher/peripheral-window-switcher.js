async function peripheralWindowSwitcher() {
  let result = undefined;

  // This "unassigned apps" switcher should show every OTHER app that's not in
  // the list below, so we exclude any window belonging to one of these. BTT
  // matches this regex against each window entry, which begins with the app
  // name.
  const assignedApps = [
    'Google Meet',
    //hello from sean
    'Granola',
    'iTerm',
    'Google Calendar',
    'Slack',
    'Google Chrome',
    'Firefox',
    'Snagit',
    'zoom.us',
    'Microsoft Excel',
    'Claude',
    'Code',
    'Notes',
    'Messages',
  ];

  // Escape any regex-special characters (e.g. the "." in "zoom.us") so the
  // app names are matched literally.
  const escapeRegex = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

  // Exclude any window whose title starts with one of the assigned app names.
  // The leading `[^A-Za-z]*` skips any non-letter decoration that web apps
  // prepend to the title — e.g. an unread badge count like "(3) Google
  // Calendar" — which would otherwise defeat a strict start-of-string match.
  // Because we still require the app name immediately after that leading
  // junk (not anywhere mid-title), a real window merely *containing* one of
  // these words (e.g. a document named "Meeting Notes") is NOT excluded.
  const excludeRegex = `^[^A-Za-z]*(${assignedApps.map(escapeRegex).join('|')})`;

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
