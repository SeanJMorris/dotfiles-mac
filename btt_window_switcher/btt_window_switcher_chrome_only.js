async function transformedActions() {
  let result = undefined;

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
    BTTWindowSwitcherExclude: '^(?!Google Chrome)',
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
