async function showWindowSwitcherForSpecificApp() {
  // Target application
  let targetApp = 'Google Chrome';

  let result = await trigger_action({
    json: JSON.stringify({
      BTTIsPureAction: 1,
      BTTPredefinedActionType: 100, // Code for Window Switcher
      BTTPredefinedActionName: 'Show Window Switcher for All Open Apps',
      BTTWindowSwitcherFilterRegex: `^(?!${targetApp}-).*$`,

      // Nested configuration for specific window switcher checkboxes
      BTTWindowSwitcherConfig: JSON.stringify({
        // 1. "On repeated Trigger: Select Next Window In List"
        //BTTWindowSwitcherRepeatedTriggerBehavior: 1,
        BTTWindowSwitcherSelectNextOnRepeat: true,

        // 2. "Activate Selected After Releasing Modifier Keys"
        //BTTWindowSwitcherActivateOnModifierRelease: true,
        BTTWindowSwitcherTriggerOnRelease: true,

        // 3. "Disable Selection By Mouse-Hover"
        //BTTWindowSwitcherDisableMouseHoverSelection: true,
        BTTWindowSwitcherDisableMouseHover: true,

        // 4. "Show preview of actual window"
        //BTTWindowSwitcherShowPreviews: true,
        BTTWindowSwitcherShowPopover: 4,

        // 5. Initial option for "Selected Item" set to "Currently Active Window"
        //BTTWindowSwitcherInitialSelectionMode: 1,
        BTTWindowSwitcherFocus: 0
      }),
    }),
  });
}
