-- Hotkey binding only works for mac only stuf. Don't use for things you hope to have happen
-- on a VM or remote desktop session

-- Force paste - sometimes cmd + v is blocked by some apps (herky jerks) so can't paste password from password manager
hs.hotkey.bind({'cmd', 'shift'}, 'V', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
-- Lock the screen (don't sleep, show select-user/sign-in page)
hs.hotkey.bind({'alt', 'ctrl'}, 'L', function() hs.caffeinate.lockScreen() end)
-- If Chrome already open, cycle through open windows
hs.hotkey.bind(ultra, 'space', function() smartLaunchOrFocus('Google Chrome') end)
-- START Open Grab. Edit->Selection, [user selects an area], Edit->Copy, END (user left to close Grab app)
hs.hotkey.bind({'alt'}, 'G', function() startNewGrabThenCopy() end)
hs.hotkey.bind({'alt'}, 't', function() openNewTerminalWindow() end)

-- Tools for writing Hammerspoon script
hs.hotkey.bind({'cmd', 'shift'}, 'R', function() hs.reload() end)
hs.hotkey.bind({'cmd', 'shift'}, 'C', function() hs.console.clearConsole() end)
hs.hotkey.bind({'alt'}, 'A', function() hs.alert(hs.application.frontmostApplication():name()) end)
hs.hotkey.bind({'alt'}, 'B', function() hs.alert(hs.application.frontmostApplication():bundleID()) end)

-- For debugging the loss of event taps at weird times
-- (ctrl+fn and shift+fn bound on flagsChanged tap just stop working)
hs.hotkey.bind({'alt'}, 'F', function()
  flagsEventTap = hs.inspect(etFlags)
  hs.alert(flagsEventTap)
  hs.pasteboard.setContents(flagsEventTap)
end)
