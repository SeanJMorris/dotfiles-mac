async function openNewAppInstance() {
  const appName = await get_string_variable({ variable_name: 'btt_ws_app_name_to_open' });
  const appPath = await get_string_variable({ variable_name: 'btt_ws_app_path_to_open' });
  const bundleId = await get_string_variable({ variable_name: 'btt_ws_app_bundle_id_to_open' });

  if (bundleId) {
    const isRunning = await runAppleScript(
      `do shell script "pgrep -f " & quoted form of "${appPath}" & " > /dev/null 2>&1 && echo true || echo false"`
    );

    if (isRunning.trim() !== 'true') {
      await runAppleScript(`do shell script "open -b " & quoted form of "${bundleId}"`);
    } else {
      await runAppleScript(`
        tell application id "${bundleId}" to activate
        delay 0.3
        tell application "System Events" to keystroke "n" using command down
      `);
    }
  } else {
    await runAppleScript(`do shell script "open -n -a " & quoted form of "${appName}"`);
  }

  return true;
}
