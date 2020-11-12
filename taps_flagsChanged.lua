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
  log('flagsChanged event flags=' .. hs.inspect(flags) .. ';keycode=' .. e:getKeyCode())

  if flags.fn then
    local keyCombo = {}
    if hs.eventtap.checkKeyboardModifiers().ctrl then -- Ctrl + Fn is same position physically as Ctrl + Insert on PC keyboard
      keyCombo = getCombo('copyFn')
    elseif hs.eventtap.checkKeyboardModifiers().shift then -- Shift + Fn is same position physically as Shift + Insert on a PC keyboard
      keyCombo = getCombo('pasteFn')
    else
      return false -- Don't shunt, send as is
    end
    if keyCombo == nil or keyCombo == false then return false end
    local modifiers = keyCombo[1]
    local key = keyCombo[2]
    if key == nil then return false end -- No combo for current app, just send event as is
    event = sendKey(keyCombo, false, true)
    --events = hs.eventtap.event.newKeyEventSequence(modifiers, key)
    hs.timer.delayed.new(.3, function()
      event:post()
      -- for k, event in next, events do
      --   event:post()
      -- end
    end):start()
    return false
  end

  --- Clear the console on hyperkey (only cmd+alt+ctrl)
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
