-- -------------------------------------------------------------------------------------
-- Trap flagsChanged
-- -------------------------------------------------------------------------------------
-- Map keys for cut/copy/paste that are in the same physical location on the keyboard as a PC keyboard (for the right hand)
-- That is, make ctrl+fn, shift+fn do stuff (shift+forwarddelete is handled in the keyDown event tap below)

-- Have to trap flagsChanged event instead of keyDown because holding only modifier keys doesn't trigger a keyDown event on Macs

-- Note: by trapping flag changes, with no actual event to shunt.
-- Any key events created here will NOT propagate from the OS of VM and RDP (I'm still working on this)
-- through VitualBox and Microsoft Remote Desktop.
etFlags = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (e)
  --log('flagsChanged event: flags=' .. hs.inspect(e:getFlags()))
  flags = e:getFlags()
  if flags.fn then
    if hs.eventtap.checkKeyboardModifiers().ctrl then -- Ctrl + Fn is same position physically as Ctrl + Insert on PC keyboard
      return keyEvents.ctrlFn()
    end
    if hs.eventtap.checkKeyboardModifiers().shift then -- Shift + Fn is same position physically as Shift + Insert on a PC keyboard
      return keyEvents.shiftFn()
    end
  end

  --- Clear the console on hyperkey (only cmd+alt+ctrl)
  if flags.cmd and flags.ctrl and flags.alt and CLEAR_LOG_ON_HYPER_KEY then
    hs.timer.delayed.new(.3, function()
      hs.console.clearConsole()
    end):start()
  end

end)
etFlags:start()

--[[
etFlagsTest = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (e)
  flags = e:getFlags()
  key = 'c'
  if next(flags) ~= nil then
    log('++++++++++++++++++++++++++++++++++++++++++++++++')
    log('flagsChanged event flags=' .. hs.inspect(flags) .. ';keycode=' .. e:getKeyCode())
  end
  if flags.fn and (flags.shift or flags.ctrl) then
    if flags.shift then key = 'v' end
    evKey = hs.eventtap.event.newKeyEvent({'ctrl'}, key, true)
     -- Shunt other eventtaps
    evKey:setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, 55555)
    log('================================================')
    dump(evKey:getFlags())
    evKey:post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent({'ctrl'}, key, false):setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, 55556):post()
  end
end):start()
]]
