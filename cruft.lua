
-- All these didn't work because it appears the OS is capturing the event and not passing onto Hammerspoon (on to apps)
-- key = hs.eventtap.keyStroke
--hs.hotkey.bind({'ctrl'}, 'right', function() key({'alt'}, 'right') end) -- Move to beginning of previous word
--hs.hotkey.bind({'ctrl'}, 'left', function() key({'alt'}, 'left') end) -- Move to end of next word
--hs.hotkey.bind({'ctrl', 'shift'}, 'right', function() key({'alt', 'shift'}, 'right') end) -- Select to beginning of previous word
--hs.hotkey.bind({'ctrl', 'shift'}, 'left', function() key({'alt', 'shift'}, 'left') end)  -- Select to end of next word
--hs.hotkey.bind({'shift'}, 'forwarddelete', function() selectMenuItem(cut) end) -- PC keyboard old stand-by

-- hotkey.bind just doesn't work across non-apple contexts (VirtualBox, Microsoft Remote Desktop)
-- so you have to handle them manually in an event tap (see below)
--hs.hotkey.bind({'shift'}, 'home', function() keyEvents.shiftHome() end)-- Select to begining of line
--hs.hotkey.bind({'shift'}, 'end', function() keyEvents.shiftEnd() end) -- Select to end of line
--hs.hotkey.bind({'ctrl'}, 'home', function() keyEvents.ctrltHome() end)-- Select to begining of line
--hs.hotkey.bind({'ctrl'}, 'end', function() keyEvents.ctrlEnd() end) -- Select to end of line
--hs.hotkey.bind({'ctrl'}, 'C', function() keyEvents.menuCopy() end)
--hs.hotkey.bind({'ctrl'}, 'X', function() keyEvents.menuCut() end)
--hotkey.bind({'shift'}, 'forwarddelete', function() keyEvents.menuCut() end)
--hs.hotkey.bind({'ctrl'}, 'V', function() keyEvents.menuPaste() end)
--hs.hotkey.bind({'ctrl'}, 'S', function() keyEvents.menuSave() end)
--hs.hotkey.bind({'ctrl'}, 'Z', function() keyEvents.menuUndo() end)
--hs.hotkey.bind({'ctrl'}, 'Y', function() keyEvents.menuRedo() end)
--hs.hotkey.bind({'ctrl'}, 'A', function() keyEvents.selectAll() end)

--[[

-- For future fun
-- Source: https://gist.github.com/auser/d4924fbe08e6ea2ac68b
function applicationRunning(name)
  apps = application.runningApplications()
  found = false
  for i = 1, #apps do
    app = apps[i]
    if app:title() == name and (#app:allWindows() > 0 or app:mainWindow()) then
      found = true
    end
  end
  return found
end

-- -------------------------------------------------------------------------------------
MORE TO CONSIDER:

Great examples of script that always opens app on a certain monitor
https://github.com/rtoshiro/hammerspoon-init/blob/master/init.lua

]]
