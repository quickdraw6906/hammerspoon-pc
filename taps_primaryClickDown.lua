etRtClickDown = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown}, function (e)
  -- Stop if current event was created by this function! (i.e., don't tap thine own events)
  if tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)) == '55555' then
    return false
  end

  --local flags = e:rawFlags() & 0xdffffeff
  --log('Flags: ' .. tostring(flags))
  --log('Command: ' .. tostring(hs.eventtap.event.rawFlagMasks['command']))
  --flags = flags - hs.eventtap.event.rawFlagMasks['command']
  --log('Flags: ' .. tostring(flags))
  --log('Control: ' .. tostring(hs.eventtap.event.rawFlagMasks['control']))
  --flags = flags + hs.eventtap.event.rawFlagMasks['command']
  --log('Flags: ' .. tostring(flags))

  local app = string.gsub(hs.application.frontmostApplication():name(), ' ', '_')

  --log(hs.inspect.inspect(hs.eventtap.event.rawFlagMasks))

  --log(hs.inspect.inspect(e:getRawEventData()))

  if app == "pGoogle_Chrome" then -- e:getFlags()['ctrl'] == true then
    --log('Control + Primary mouse click')
    -- Taking care to trap exceptions (could leave the system tricky to use otherwise!)
    local status, event = pcall(function ()
          return hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseDown, e:location(), {cmd})
        end
     )
    if status then
      -- Add signal so don't get recursion
      event:setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, '55555')

      -- Strip command, add control
      event = e:rawFlags(1048592) -- 1048592 (ctrl = 270336) 1048576
      --event = e:setFlags({cmd=true})
      --event = event:setKeyCode(54)

      -- At this point modifierFlags = 1048576
      -- but getRawEventData() reports 1048592 (in all apps) when command held
      --log(hs.inspect.inspect(event:getRawEventData()))

      if event:getFlags()['ctrl'] == true then
        --log('ctrl set')
      end
      if event:getFlags()['cmd'] == true then
        --log('cmd set')
      end

      return false, {event}
    else
      --log('Get left mouse event failed with error: ' .. event)
    end
  end
end)
etRtClickDown:start()
