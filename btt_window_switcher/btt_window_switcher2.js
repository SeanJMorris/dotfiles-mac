async function transformedActions() {
  let result = undefined;

  result = await trigger_action({
    json: JSON.stringify({
      BTTIsPureAction: 1,
      BTTPredefinedActionType: 99,
      BTTPredefinedActionName: 'Show Window Switcher for Active App',
      BTTAdditionalActionData:
        '{\"BTTWindowSwitcherHeight\":0,\"BTTWindowSwitcherItemHeight\":30,\"BTTWindowSwitcherWidth\":380,\"BTTWindowSwitcherOverrideDefaultShortcuts\":false,\"BTTWindowSwitcherShowThumbnail\":1,\"BTTWindowSwitcherExcludeHiddenAndMinimizedWindows\":false,\"BTTWindowSwitcherDisableMouseHover\":true,\"BTTWindowSwitcherExcludeAllButHiddenAndMinimizedWindows\":false,\"BTTWindowSwitcherSelectNextOnRepeat\":true,\"BTTWindowSwitcherExcludeSpecific\":false,\"BTTWindowSwitcherInitialFocus\":1,\"BTTWindowSwitcherTriggerOnRelease\":true,\"BTTWindowSwitcherFocus\":0,\"BTTWindowSwitcherShowPopover\":4,\"BTTWindowSwitcherAppearance\":0,\"BTTWindowSwitcherExcludeVisibleWindows\":false,\"BTTWindowSwitcherFontSize\":12,\"BTTWindowSwitcherExclude\":\"\",\"BTTWindowSwitcherSort\":4,\"BTTWindowSwitcherExcludeWindowsFromOtherSpaces\":true,\"BTTWindowSwitcherMousePos\":0}',
    }),
    wait_for_reply: true,
  });

  return true;
}
