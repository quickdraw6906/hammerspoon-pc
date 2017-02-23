-- -------------------------------------------------------------------------------------
-- Goals:
-- Augment cut/copy/paste functions with shortcuts that are more efficient
-- Launch favorite browser with hyper+space (or bring forward already open window)
-- Allow paste into password fields that block paste operation
-- Use PC shortcut behavior including inside the Microsoft Remote Desktop (RDP) app (cut/copy/paste, cursor movement)
-- Add a convenient function to lock the Mac, displaying the user menu without sleeping first
-- -------------------------------------------------------------------------------------
hs.console.clearConsole()
require 'functions_pckeys'
require 'config_pckeys'

-- -------------------------------------------------------------------------------------
-- Launch Chrome or focus it if already running
-- -------------------------------------------------------------------------------------
-- Go get the following file and put in ~/.hammerspoon,
-- Source: https://github.com/vic/.hammerspoon/blob/master/ext/application.lua
-- Then, uncomment the rest of the lines in the paragraph for powerful goodness
local module = {}
local smartLaunchOrFocus = require('application').smartLaunchOrFocus
-- Launch Chrome or cycle through open windows
hs.hotkey.bind(ultra, 'space', function() smartLaunchOrFocus('Google Chrome') end)

-- -------------------------------------------------------------------------------------
-- General
-- -------------------------------------------------------------------------------------
-- Hotkey binding only works for mac only stuf. Don't use for things you hope to have happen
-- on a VM or remote desktop session

-- Force paste - sometimes cmd + v is blocked by some apps (herky jerks) so can't paste password from password manager
hs.hotkey.bind({'cmd', 'shift'}, 'V', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Lock the screen (don't sleep, show select-user/sign-in page)
hs.hotkey.bind({'alt', 'ctrl'}, 'L', function() hs.caffeinate.lockScreen() end)

-- Tools for writing Hammerspoon script
hs.hotkey.bind({'cmd', 'shift'}, 'R', function() hs.reload() end)
hs.hotkey.bind({'cmd', 'shift'}, 'C', function() hs.console.clearConsole() end)
hs.hotkey.bind({'alt'}, 'A', function() hs.alert(hs.application.frontmostApplication():name()) end)
hs.hotkey.bind({'alt'}, 'B', function() hs.alert(hs.application.frontmostApplication():bundleID()) end)

-- -------------------------------------------------------------------------------------
-- Quick and easy screen capture
-- -------------------------------------------------------------------------------------
-- Launch a screen capture that will copy the result to the pastboard
-- Great for quick snips to paste into another app
-- (Wanted to kill grabber (kill9) so it didn't prompt to save file, but alas
-- doing that lost the image from the pastboard, and Hammerspoon couldn't read
-- the image into a variable for some reason.
maxTimer = 20
timerNum = 0
checkForCaptureTimer = nil
GRABBUNDLEID = 'com.apple.Grab'
capturedImage = nil
hs.hotkey.bind({'alt'}, 'G', function()
  -- Stop any previous timer checking for a Grab window
  if checkForCaptureTimer ~= nil then
    checkForCaptureTimer:stop()
  end
  -- Launch Grab app
  hs.application.launchOrFocusByBundleID(GRABBUNDLEID)
  log(hs.inspect(hs.application.applicationsForBundleID(GRABBUNDLEID)))
  grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
  if grabApp == nil then
    hs.alert('Grab app not found.')
    return
  end
  -- If Grab already running, bail (nee no windows open in Grab so can detect when a new one opens)
  wins = grabApp:mainWindow()
  if win ~= nil then
      hs.alert('Existing window found. Aborting. Dismiss window and try again.')
      return
  end

  log('Reqesting selection capture')
  grabApp:selectMenuItem({'Capture', 'Selection'})

  -- Wait for user to make the selection (Grab to open a new window)
  timerNum = 0
  checkForCaptureTimer = hs.timer.doEvery(1, function()
    timerNum = timerNum + 1
    grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
    if grabApp == nil then
      hs.alert('Grab app not found. Did you quit before making a selection?')
      checkForCaptureTimer:stop()
      return
    end
    wins = grabApp:mainWindow()
      if wins == nil then
        log('No Grab window yet')
        if timerNum > maxTimer then
          hs.alert('You waited to long to make your selection. Please try again.')
          checkForCaptureTimer:stop()
        end
        return
      end
      checkForCaptureTimer:stop()
      grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
      grabApp:selectMenuItem({'Edit', 'Copy'})
      hs.alert('Selection copied')
    end)
end)

-- -------------------------------------------------------------------------------------
-- Trap flagsChanged
-- -------------------------------------------------------------------------------------
-- Map keys for cut/copy/paste that are in the same physical location on the keyboard as a PC keyboard (for the right hand)
-- That is, make ctrl+fn, shift+fn do stuff (shift+forwarddelete is handled in the keyDown event tap below)

-- Have to trap flagsChanged event instead of keyDown because holding only modifier keys doesn't trigger a keyDown event on Macs

-- Note: by trapping flag changes, with no actual event to shunt, any key events created here will prop to the OS of VM and RDP
-- windows (VitualBox and Microsoft Remote Desktop). So, these shortcuts won't work in those contexts
hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (e)
  --log('flagsChanged event: flags=' .. hs.inspect(e:getFlags()))

  if e:getFlags().fn then
    if hs.eventtap.checkKeyboardModifiers().ctrl then -- Ctrl + Fn is same position physically as Ctrl + Insert on PC keyboard

      keyEvents.menuCopy()
    end
    if hs.eventtap.checkKeyboardModifiers().shift then -- Shift + Fn is same position physically as Shift + Insert on a PC keyboard
      keyEvents.menuPaste()
    end
  end
end):start()

-- -------------------------------------------------------------------------------------
-- Trap keyDown
-- -------------------------------------------------------------------------------------
etKeyDown = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (e)
  local cancel = false

  local kc = e:getKeyCode() -- Key user pressed
  local flags = hs.eventtap.checkKeyboardModifiers() -- Modifier keys user was pressing
  local data = e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)

  log('keyDown event: keycode=' .. tostring(kc) .. '; userdata=' .. tostring(data) .. '; semaphore=' ..  tostring(semaphore) .. '; flags=' .. hs.inspect(e:getFlags()))

  -- Only do if not an event generated by another script (which sets
  -- the userdata of the event to distinguish itself from user/OS key events)
  -- See getKeyEvent()
  if data ~= 55555 then

    -- -------------------------------------------
    -- SHIFT COMBOS
    -- -------------------------------------------
    if flags.shift then
      -- If ctrl+home|end pressed, strip off ctrl and send home|end Flip what mac does with what pc does)
      if kc == 115 then -- Home = home (strip ctrl flag)
        return keyEvents.shiftHome(e) -- Pass through keycode sans modifiers for mac context
      end

      if kc == 117 then -- forwarddelete = cut
        keyEvents.menuCut()
        return true
      end

      if kc == 119 then -- End = end (strip ctrl flag)
        return keyEvents.shiftEnd(e) -- Pass through keycode sans modifiers for mac context
      end
    end

    -- -------------------------------------------
    -- CTRL COMBOS
    -- -------------------------------------------
    if flags.ctrl then

      if semaphore == 1 then
        log('Semaphore set. Skipping event for keycode ' .. tostring(e:getKeyCode()))
        return true
      end

      if kc == 0 then -- A = select all
        return keyEvents.selectAll()
      end

      if kc == 1 then -- S = save
        return keyEvents.menuSave()
      end

      if kc == 6 then -- Z = undo
        return keyEvents.menuUndo()
      end

      if kc == 7 then -- X = cut
        return keyEvents.menuCut()
      end

      if kc == 8 then -- C = copy
        return keyEvents.menuCopy()
      end

      if kc == 9 then -- V = paste
        return keyEvents.menuPaste()
      end

      if kc == 13 then -- W = close
        return keyEvents.menuClose()
      end

      if kc == 16 then -- Y = redo
        return keyEvents.menuRedo()
      end

      -- If ctrl+home|end pressed, strip off ctrl and send home|end Flip what mac does with what pc does)
      if kc == 115 then -- Home = home (strip ctrl flag)
        return sendCtrlEndHome(e) -- Pass through keycode sans modifiers for mac context
      end

      if kc == 119 then -- End = end (strip ctrl flag)
        return sendCtrlEndHome(e) -- Pass through keycode sans modifiers for mac context
      end

      -- Warning: Overrides control+arrows for navigating desktops
      -- This doesn't quite work right yet. If you repeat too fast the OS will get
      -- the event and you will switch desktops if you have multiple open. Sigh.
      -- This is an attempt to map control+arrows to option+arrows to "select to beginning
      -- of next word" like on a PC.
      -- Running into issues with rapid repeat (and auto repeat for that matter). The
      -- sequencing is tricky. Will probably take a queue mechanism to store all repeats for
      -- sequential playback, with shunting of other mapping operations and cancelling events
      -- at the OS level to make it all work. Very tricky business. Sigh.
      if kc == 124 then -- right arrow
      	log('Right arrow')
        moveBeginingOfNextWord()
        cancel = true
      end
      if kc == 123 then -- right arrow
      	log('Left arrow')
        moveBeginingOfPreviousWord()
        cancel = true
      end
    end
  end
  -- Cancel event or app will do what a normal key press does
  return cancel

end)
etKeyDown:start()

-- -------------------------------------------------------------------------------------
-- Cancel any other keyboard events while another binding action (script) is working
ekKeyDownShuntCtrl = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (e)
  --print('keyDown (shunt) event userdata=' .. tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)) .. "; Semaphore=" ..  tostring(semaphore))
  if e:getFlags().ctrl == true
      and e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) < 55555
      and semaphore == 1 then
    print('Shunting ctrl event')
    return true
  end
end)


-- -------------------------------------------------------------------------------------
-- Trap keyUp
-- -------------------------------------------------------------------------------------
-- This eventtap is set by binding scripts that need to block other keyboard events the
-- user or the OS generates while script is executing
etKeyUp = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function (e)
  --log('keyUp event: keycode=' .. tostring(e:getKeyCode()) .. '; userdata=' .. tostring(e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA)) .. "; semaphore=" ..  tostring(semaphore) .. '; flags=' .. hs.inspect(e:getFlags()))

  -- If a scripted action needed to block other keyboard events, then look
  -- for a key up event from the last event in the scripted chain of events
  -- and disable the event shunt eventtap and this eventtap
  if e:getProperty(EVENTPROPERTY_EVENTSOURCEUSERDATA) == 55556 then
    log('Disabling shunt')
    ekKeyDownShuntCtrl:stop()
    etKeyUp:stop()
  end
end)



-- -------------------------------------------------------------------------------------
hs.alert.show('Config loaded')


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

-- -------------------------------------------------------------------------------------
-- Why all these maps?
-- -------------------------------------------------------------------------------------
--[[
	For keyboards with this layout:
		|	               Function keys                  | | [prt scr] [scroll lock] [pause/break] | | 			    |
		|	                 Main keys		                | |   [Ins]       [Home]       [Pg Up]    | | 		    	|
		|	                 Main keys		                | |   [Del]       [Home]       [Pg Dn]    | |  10 key 	|
		|	                 Main keys		                | |			                  							  | |			      |
		|	                 Main keys		                | |               [Up]                    | |  			    |
		|  [Ctrl] [Win] [Alt] [Space] [Alt] [Win] [Ctrl]| |       [Left] [Down] [Right]           | |			      |

	On a PC, in all but Adobe applications (which is a Mac First software house), cut/copy/paste operations can be
	done with shift, control, insert and home keys:
		shift+delete	=	cut
		ctrl+insert		=	copy
		shift+insert	=	paste

	Using the left hand for the mouse allows max efficiency if control, shift, insert and delete keys used for
	cut/copy/paste operations (Right hand movement is minimized).

	Using right hand for mouse allows efficiency for cut/copy/past operations, but this is super-inefficent for
	arrows and ten key work.

	On a Mac, problems are compounded because the command key is directly under the X key, requiring either
	a slight shift of the left hand to position for comand+x, contorted use of the thumb to strike the command key,
	or a different finger striking the comand key than for command+c or command+v. The position of the command key
	next to the space bar (directly under x,c,v) makes the use of the command key a poor choice for cut/copy/paste ops,
	from the standpoint of wanting a conservation of motion when typing with wrists at rest.
]]

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
