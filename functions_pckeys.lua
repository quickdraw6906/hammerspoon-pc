-- -------------------------------------------------------------------------------------
-- Helper functions
-- -------------------------------------------------------------------------------------

function dump(var) print(hs.inspect(var)) end

function log(message)
  if DEBUG == true then print(message) end
end


-- Make keyboard events to send to OS
function getKeyEvent(modifiers, key, keyDownEvent, finish)
  local data = userData
  if finish == true then data = 55556 end -- Signal keyUp eventtrap to unset semaphore
  e = hs.eventtap.event.newKeyEvent(modifiers, key, keyDownEvent):setProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA, data)
  return e
end

-- Lookup a named combo from a structure (see config_pckeys.lua) and return a table of the modifiers + key to send
function getCombo(strCombo)
  -- Look up combo from combo table
  local app = string.gsub(hs.application.frontmostApplication():name(), ' ', '_')
  log('Getting combo ' .. strCombo .. ' with subkey ' .. app)
  local comboNode = combo[strCombo]
  if comboNode == nil then
    log('Combo node not found: ' .. comboNode)
    return {}
  end
  local keyCombo = comboNode[app]
  if keyCombo == nil then
    log('No combo node for ' .. app .. '. Looking for default combo...')
    keyCombo = comboNode['default']
  end
  if keyCombo == nil then
    log('No default combo for ' .. strCombo )
    return {} -- No valid combo in table. Pass through event to OS.
  end
  return keyCombo
end

-- Lookup a name menu path from a structure (see config_pckeys.lua) and return
-- a table with the menu path
function getMenuPath(strMenuName)
  -- Look up combo from combo table
  local app = string.gsub(hs.application.frontmostApplication():name(), ' ', '_')
  log('Getting menu path ' .. strMenuName .. ' with subkey ' .. app)
  local menuNode = menuPath[strMenuName]
  if menuNode == nil then return {} end
  local menuPth = menuNode[app]
  if menuPth == nil then
    log('No combo found for ' .. app .. '. Looking for default combo...')
    menuPth = menuNode['default']
  end
  if next(menuPth) == nil then
    return {} -- No valid combo in table. Pass through event to OS.
  end
  return menuPth
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

  log('Sending key: ' .. key .. ' with modifiers: ' .. hs.inspect(modifiers))

  -- keyDown event
  getKeyEvent(modifiers, key, true):post()
  hs.timer.usleep(1000) -- tenth of a millisecond
  -- See comment at moveBeginingOfNextWord() below
  if finishOfSequence == true then
    log('Enabling keyUp event')
    etKeyUp:start()
    semaphore = 0
  end
  -- keyUp event
  getKeyEvent(modifiers, key, false, finishOfSequence):post()

  return true -- Don't prop the current event
end

-- Shortcuts that represent cut/copy/paste could either be sent as another keystroke,
-- or as a direct firing of a menu item. One or the other approaches works better in
-- certain apps (some apps don't have keyboard combo for these functions but have a menu)
-- See functions_pckeys.lua to determine which approach will be used for a certain app
function sendKeyOrMenu(pasteboardOperation)
  -- First look to see if there is a combo defined for pasteboard opp and/or app
  log('Sending pasteboardOperation: ' .. pasteboardOperation)
  local combo = getCombo(pasteboardOperation)

  if next(combo) ~= nil then
      -- Key combo found, returning that
      log('Sending combo ' .. hs.inspect(combo))
      return sendKey(combo, true)
  end
  -- No combo found. Look for menu path
  local menuPth = getMenuPath(pasteboardOperation)
  if next(menuPth) == nill then
    log('Passing event through.')
    return false
  end -- No menu found, pass event onto OS unaltered
  log('Found menu path ' .. hs.inspect(menuPth))
  return selectMenuItem(menuPth)
end


function unsetSemaphore()
  hs.timer.delayed.new(keySendDelay, function()
    --print('Unsetting semaphore')
    semaphore=0
  end):start()
end

-- For ctrl+home|end we want begin|end of doc behavior, like on a PC. This behavior
-- is what regular home|end does on a mac by default. So the PC user used to hitting
-- ctrl+home|end can still do it and get the expected begin|end of doc action.
-- But when in RDS, a ctrl+home|end does what we expect, so if that is the current
-- app, don't clear the ctrl flag- just sent event as is.
function sendCtrlEndHome(e) -- pass keyboard event (from hs.eventtrap.event)
  local app = hs.application.frontmostApplication():name()
  if app ~= 'Microsoft Remote Desktop' and app ~= 'VirtualBox_VM' then
    log('Flags stripped')
    e:setFlags({})
  end
  return false
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
moveBeginingOfNextWord = function()
  --semaphore = 1
  --ekKeyDownShuntCtrl:start()
  keyEvents.altRight()
  keyEvents.altRight()
  return keyEvents.altLeft(true)

end
moveBeginingOfPreviousWord = function()
  --semaphore = 1
  --ekKeyDownShuntCtrl:start()
  return keyEvents.altLeft(true)
end


--function selectMenuItemDelayed(tblMenuItem)
  --hs.timer.delayed.new(keySendDelay, function() selectMenuItem(tblMenuItem) end):start()
--end
