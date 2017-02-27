function dump(var, fAlert)
  out = 'DUMP: '  .. hs.inspect(var)
  if fAlert then
      hs.alert(out)
  else
    print(out)
  end
end

function log(message)
  if DEBUG == true then print(message) end
end

function execKeyFunction(mods, kc, triggeringEvent)
  local keyFunction = nil
  if mods == 'nil' then return false end

  log('EXECKEYFUNCTION mods=' .. mods .. '; kc=' .. tostring(kc) .. '; flags=' .. hs.inspect(triggeringEvent:getFlags()))

  ret = false
  if not pcall(function() ret = keyFuncs[mods][kc]() end) then
    log('No key function for ' .. mods .. '+' .. tostring(kc))
    return false -- Pass original key event through
  end
  log('SHUNT ORIGINAL EVENT: ' .. tostring(ret))
  return ret
end

-- Send keyDown and keyUp events for a combo.
function sendKey(combo, finishOfSequence)
  -- If not passed a valid combo, just signal for the event to pass
  -- through to the OS (for apps that already behave like a PC (i.e., Microsoft Remote Desktop))
  if combo == nil or combo == false then return false end
  if finishOfSequence == nil then finishOfSequence = true end

  local modifiers = combo[1]
  local key = combo[2]
  if key == nil then return false end -- No combo for current app, just send event as is

  log('SENDING KEY: ' .. key .. ' w/ mods: ' .. hs.inspect(modifiers))

  -- keyDown event
  hs.timer.delayed.new(.005, function()
    log('Sending keyDown')
    getKeyEvent(modifiers, key, true):post()
    hs.timer.usleep(1000) -- tenth of a millisecond
    -- See comment at moveBeginingOfNextWord() below
    if finishOfSequence == true then
      --log('Enabling keyUp event')
      etKeyUp:start()
      semaphore = 0
    end
    -- keyUp event
    hs.timer.delayed.new(.005, function()
      log('sending keyUp')
      getKeyEvent(modifiers, key, false, finishOfSequence):post()
    end):start()
  end):start()

  return true -- Don't prop the current event
end

-- Make keyboard events to send to OS
-- Trying to go low level to get the right things to happen in VMs. A work in progress.
function getKeyEvent(modifiers, key, keyDownEvent, finish)
  local data = userData
  if finish == true then data = 55556 end -- Signal keyUp eventtrap to unset semaphore
  return hs.eventtap.event.newKeyEvent(modifiers, key, keyDownEvent):setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, data)
end

-- Lookup a named combo from a structure (see config_pckeys.lua) and return a table of the modifiers + key to send
function getCombo(strCombo)
  -- Look up combo from combo table
  local app = string.gsub(hs.application.frontmostApplication():name(), ' ', '_')
  --log('Getting combo ' .. strCombo .. ' with subkey ' .. app)
  local comboNode = combo[strCombo]
  if comboNode == nil then
    --log('Combo node not found: ' .. comboNode)
    return {}
  end
  local keyCombo = comboNode[app]
  if keyCombo == nil then
    --log('No combo node for ' .. app .. '. Looking for default combo...')
    keyCombo = comboNode['default']
  end
  if keyCombo == nil then
    log('No defined or default combo for ' .. strCombo )
    return {} -- No valid combo in table. Pass through event to OS.
  end
  return keyCombo
end

-- Lookup a name menu path from a table structure (see config_pckeys.lua) and return
-- a table with the menu path
function getMenuPath(strMenuName)
  -- Look up combo from combo table
  local app = string.gsub(hs.application.frontmostApplication():name(), ' ', '_')
  log('Getting menu path ' .. strMenuName .. ' for app ' .. app)
  local menuNode = menuPath[strMenuName]
  if menuNode == nil then return {} end
  local menuPth = menuNode[app]
  if menuPth == nil then
    log('No combo found for ' .. app .. '. Looking for default combo...')
    menuPth = menuNode['default']
  end
  if next(menuPth) == nil then
    log('No menu item found with path')
    return {} -- No valid combo in table. Pass through event to OS.
  end
  return menuPth
end

-- Shortcuts that represent cut/copy/paste could either be sent as another keystroke,
-- or as a direct firing of a menu item. One or the other approaches works better in
-- certain apps (some apps don't have keyboard combo for these functions but have a menu)
-- See functions_pckeys.lua to determine which approach will be used for a certain app
function sendKeyOrMenu(operation)
  -- First look to see if there is a combo defined for pasteboard opp and/or app
  local combo = getCombo(operation)

  if next(combo) ~= nil then
      -- Key combo found, returning that
      return sendKey(combo, true)
  end
  log('Looking for menu...')
  -- No combo found. Look for menu path
  local menuPth = getMenuPath(operation)
  if next(menuPth) == nill then
    return false
  end -- No menu found, pass event onto OS unaltered
  log('Activating menu path ' .. hs.inspect(menuPth))
  return selectMenuItem(menuPth)
end

-- Half baked attempt to get VM and RDP contexts to work
function unsetSemaphore()
  hs.timer.delayed.new(keySendDelay, function()
    --log('Unsetting semaphore')
    semaphore=0
  end):start()
end

-- Select a menu item
-- Used instead of straight keyboard mapping for cut/copy/paste and undo operations
-- Whatever is passed, look for a nested menu (up to one level deep)
-- For example, in TextMate, a paste command is Edit->Paste->Paste becuase the Paste
-- under the Edit menu is a fly out menu.
function selectMenuItem(tblMenuItem)
  local menuPath = {table.unpack(tblMenuItem)}
  local app = hs.application.frontmostApplication()
  local len = 1
  for i,v in ipairs(menuPath) do len = len + 1 end
   -- Copy the last item in the menu path and add to end
   -- (look one time for a one level deep nested menu item)
  menuPath[len] = menuPath[len - 1]
  local menu = app:findMenuItem(menuPath)
  if menu ~= nil then
    app:selectMenuItem(menuPath)
    return true -- Don't prop the current event
  else
    log('Menu path not found:  ' .. hs.inspect(menuPath))
	  menu = app:findMenuItem(tblMenuItem)
	  if menu ~= nil then
      log('Sending menu item:  ' .. hs.inspect(tblMenuItem))
	    app:selectMenuItem(tblMenuItem)
      return true -- Don't prop the current event
	  end
  end
  return false -- No menu found. Prop the current event down to the OS
end


-- Challenge here is to handle rapid repeats of ctrl+left|right without
-- the event falling through to the OS (which switches desktops).
--
-- On a mac, option(alt)+right jumps to end of current word and option+right jumps
-- to beginning of current word. PC word jumping alternates from current word end
-- to beginning of next work (left arrow) or current word begining to end of previous
-- word (left arrow). For brains that aren't plastic enough to work the change to
-- mac, let's keep it the same as PC.
moveBeginingOfNextWord = function(flags)
  --semaphore = 1
  --ekKeyDownShuntCtrl:start()
  if flags == 'shift' then
    sendKey(getCombo('altShiftRight'))
    sendKey(getCombo('altShiftRight'))
    sendKey(getCombo('altShiftLeft'), true)
  else
    sendKey(getCombo('altRight'))
    sendKey(getCombo('altRight'))
    sendKey(getCombo('altLeft'), true)
  end
  return true
end

moveBeginingOfPreviousWord = function(flags)
  --semaphore = 1
  --ekKeyDownShuntCtrl:start()
  if flags == 'shift' then
    sendKey(getCombo('altShiftLeft'), true)
    return true
  else
    sendKey(getCombo('altLeft'), true)
  end
  return true
end


function openNewTerminalWindow()
  -- Long time PC users take issue with not having a robust alias (being able to pass CL args
  -- to programs), and the fact that most (all?) apps run in one instance so launching from
  -- icon will never produce two of something. Which is a good thing! But without having a
  -- command-invocation based alias, versus a pointer-based alias means there needs to be
  -- apps like Apptivate (hat's to those guys).
  smartLaunchOrFocus('Terminal')
  hs.eventtap.keyStroke({'cmd'}, 'n')
  -- Could have also fired an OS 'open' command using hs.task.new(...):start()
end


-- Doesn't work, issue created
-- Intention: Hammerspoon console window clears whenever it gets focus
hs.application.watcher.new(
  function(name, type, app)
    if app == 'Hammerspoon' and type == hs.application.watcher.activated then
      hs.console.clearConsole()
    end
  end
):start()
