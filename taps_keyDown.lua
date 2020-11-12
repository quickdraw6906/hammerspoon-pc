

etNSKeyDown = hs.eventtap.new({hs.eventtap.event.types.NSSystemDefined}, function (e)
--[[
   log ('===================================================')
   log('NSKeyDown event: keycode=' .. tostring(e:getKeyCode()) ..
    '; userdata=' .. userData ..
    '; semaphore=' ..  tostring(semaphore) ..
    '; repeat=' .. tostring(repeatMode) ..
    '; flags=' .. hs.inspect(e:getFlags()) )

  dump(hs.eventtap.event.types)
  ]]

end)
etNSKeyDown:start()


etKeyDown = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (e)
  -- local flags = hs.eventtap.checkKeyboardModifiers() -- Modifier keys user was pressing
  local flags = e:getFlags()
  log ('===================================================')
  log('keyDown event: keycode=' .. tostring(e:getKeyCode()) ..
    '; userdata=' .. userData ..
    '; semaphore=' ..  tostring(semaphore) ..
    '; repeat=' .. tostring(repeatMode) ..
    '; flags=' .. hs.inspect(e:getFlags()) )

  --print(hs.inspect(hs.eventtap.event.properties['keyboardEventAutorepeat']))


  local userData = ''
  if e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) == nil then
    userData = 'nil'
  else
    userDate = tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA))
  end

  if skipToggle then
    log('skipToggle on. Skipping shortcut.')
    return false -- Way to minimize env reloads when something going wrong
  end

  -- Never pass these to the OS. hs.hotkey.bind() should handle
  --if flags.ctrl and (e:getKeyCode() == 124 or e:getKeyCode() == 123) then
  --  log('Shunting ctrl+arrow event tap to let hotkey.bind() handle the event')
  --  e:setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, 55555)
  --  return true
  --end

  -- Only do if not an event generated by another script- which sets the user data
  -- of the event to distinguish itself from user/OS key events. See getKeyEvent()
  -- This ensures that hs.hotkey.bind (using functions in keyEvent table) won't
  -- fire a recursion.
  if e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) == 55555 and not repeatMode then
    log('Skipping keyDown event. User data 55555 present')
    return false
  end

  -- Experimental
  if semaphore == 1 then
    log('Semaphore set. Skipping event for keycode ' .. tostring(e:getKeyCode()))
    return true
  end

  if not flags.ctrl and not flags.shift and not flags.alt and not flags.cmd then
    return execKeyFunction('noMods', e:getKeyCode(), e)
  end

  if flags.alt then
    return execKeyFunction('altMods', e:getKeyCode(), e)
  end

  if flags.ctrl and not flags.shift then
    return execKeyFunction('ctrlMods', e:getKeyCode(), e)
  end

  if flags.shift and not flags.ctrl then
    return execKeyFunction('shiftMods', e:getKeyCode(), e)
  end

  if flags.shift and flags.ctrl then
    return execKeyFunction('ctrlShiftMods', e:getKeyCode(), e)
  end

  -- Could add additional modifier combos like w/ command key (but this project for PC keystrokes, mostly)

  return false -- Cancel event (see docs for hs.eventtap.newKeyEvent()) or app will get the orig event

end)
etKeyDown:start()
-- -------------------------------------------------------------------------------------
-- Expirimental: Cancel any other keyboard events while another binding action (script) is working
ekKeyDownShuntCtrl = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (e)
  --print('keyDown (shunt) event userdata=' .. tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)) .. "; Semaphore=" ..  tostring(semaphore))
  if e:getFlags().ctrl == true
      and e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) < 55555
      and semaphore == 1 then
    print('Shunting ctrl event')
    return true --
  end
end)
