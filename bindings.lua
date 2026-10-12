-- Hotkey binding only works for mac only stuf. Don't use for things you hope to have happen
-- on a VM or remote desktop session.

-- Force paste - sometimes cmd + v is blocked by some apps (herky jerks) so can't paste password from password manager
bindInputHotkey({'cmd', 'shift'}, 'v', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Lock the screen (don't sleep, show select-user/sign-in page)
bindInputHotkey({'alt', 'ctrl'}, 'l', function() hs.caffeinate.lockScreen() end)

-- If Chrome already open, cycle through open windows
bindInputHotkey(ultra, 'c', function() launchAppAndTractorBeamToMouseScreen('Google Chrome') end)

-- START Open Grab. Edit->Selection, [user selects an area], Edit->Copy, END (user left to close Grab app)
bindInputHotkey({'alt'}, 'g', function() startNewGrabThenCopy() end)
--bindInputHotkey({'alt'}, 't', function() openNewTerminalWindow() end)

-- -----------------------------------------------------------------------------
-- Tools for writing Hammerspoon script
bindInputHotkey({'alt'}, 'a', function() hs.alert(hs.application.frontmostApplication():name()) end)
bindInputHotkey({'alt'}, 'b', function() hs.alert(hs.application.frontmostApplication():bundleID()) end)
bindInputHotkey({'alt'}, 'h', function() flipSkipToggle() end)

-- For debugging the loss of event taps at weird times
-- (ctrl+fn and shift+fn bound on flagsChanged tap just stop working)
--bindInputHotkey({'alt'}, 'f', function()
--  flagsEventTap = hs.inspect(etFlags)
--  hs.alert(flagsEventTap)
--  dump(flagsEventTap)
--  hs.pasteboard.setContents(flagsEventTap)
--end)
-- When taps drop, need to reload to get them back.
bindInputHotkey({'cmd', 'shift'}, 'r', function() hs.reload() end)

-- Nope. Was hoping the repeat function would keep events from falling through to the OS.
--bindInputHotkey({'ctrl'}, 'right', nil, function() log('hotkey') return pcall(keyEvents.ctrlRight) end, function() log('repeat') return repeatkey() end, function() return false end)

repeatMode = false
function repeatkey()
  log('Repeat ON')
  repeatMode = true
  return pcall(keyEvents.ctrlRight)
end
