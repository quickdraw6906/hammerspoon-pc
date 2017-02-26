
-- -------------------------------------------------------------------------------------
-- Trap keyUp
-- -------------------------------------------------------------------------------------
-- This eventtap is set by binding scripts that need to block other keyboard events the
-- user or the OS generates while script is executing
etKeyUp = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function (e)
  log('keyUp event: keycode=' .. tostring(e:getKeyCode()) .. '; userdata=' .. tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)) .. "; semaphore=" ..  tostring(semaphore) .. '; flags=' .. hs.inspect(e:getFlags()))
  -- If a scripted action needed to block other keyboard events, then look
  -- for a key up event from the last event in the scripted chain of events
  -- and disable the event shunt eventtap and this eventtap
  if e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) == 55556 then
    --log('Disabling shunt')
    ekKeyDownShuntCtrl:stop()
    etKeyUp:stop()
  end
end):start()
