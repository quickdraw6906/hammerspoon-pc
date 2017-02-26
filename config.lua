DEBUG = true
CLEAR_LOG_ON_HYPER_KEY = true
EVENTPROPERTY_EVENTSOURCEUSERDATA = 42 -- print(hs.inspect(hs.eventtap.event.properties))
-- For bindings that require canceling the current key event and spawing a new event with a delay
keySendDelay =.05
-- Used to prevent recurison
semaphore = 0
userData = 55555

ultra = { 'ctrl', 'alt', 'cmd' }

-- Map keys entered to corresponding action
keyEvents = {
  -- See actions.lua for the actions (param to getCombo) and for mapping them to specific applications
  ctrlLeft       = function()  return sendKey(getCombo('nextWord')) end,
  ctrlShiftLeft  = function()  return sendKey(getCombo('selectNextWord')) end,
  ctrlRight      = function()  return sendKey(getCombo('prevWord')) end,
  ctrlShiftRight = function()  return sendKey(getCombo('selectPrevWord')) end,
  home           = function(e) return sendKey(getCombo('beginLine')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  shiftHome      = function(e) return sendKey(getCombo('selectBeginLine')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  ctrlHome       = function()  return sendKey(getCombo('docBegin')) end,
  ctrlShiftHome  = function()  return sendKey(getCombo('selectDocBegin')) end,
  endKey         = function()  return sendKey(getCombo('endLine')) end,
  shiftEnd       = function()  return sendKey(getCombo('selectEndLine')) end,
  ctrlEnd        = function(e) return sendKey(getCombo('docEnd')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  ctrlShiftEnd   = function(e) return sendKey(getCombo('selectDocEnd')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  ctrlF          = function()  return sendKey(getCombo('find')) end,
  ctrlX          = function()  return sendKeyOrMenu('cut') end,
  ctrlA          = function()  return sendKeyOrMenu('selectAll') end,
  ctrlB          = function()  return sendKey(getCombo('bold')) end,
  ctrlI          = function()  return sendKey(getCombo('italic')) end,
  ctrlU          = function()  return sendKey(getCombo('underline')) end,
  ctrlO          = function()  return sendKey(getCombo('open')) end,
  ctrlW          = function()  return sendKey(getCombo('close')) end,
  ctrlR          = function()  return sendKey(getCombo('reload')) end,
  ctrlV          = function()  return sendKeyOrMenu('paste') end,
  ctrlS          = function()  return sendKeyOrMenu('save') end,
  ctrlZ          = function()  return sendKeyOrMenu('undo') end,
  ctrlY          = function()  return sendKeyOrMenu('redo') end,

  -- Thse are being monitored special because of issue where taps (keyDown) are inexplicably stopping
  -- Goal: Store eventtaps as variables, if I find taps are not trapping events, hit a shortcut to log
  -- out the eventtap variables. If they are still there, then that will help narrow down the problem
  -- (i.e., get as much data as possible before filing the issue).
  ctrlC          = function()
                        ret = sendKeyOrMenu('copy')
                        hs.timer.delayed.new(1, function()
                          log('Regular copied. pasteboard=' .. hs.pasteboard.getContents())
                        end):start()
                        return ret
  end,

  ctrlFn         = function()
                        ret = sendKey(getCombo('copyFn'))
                        hs.timer.delayed.new(.5, function()
                        	log('Special copy. pasteboard=' .. hs.pasteboard.getContents())
                        end):start()
                        return ret
  end,

  shiftFn        = function()
                        ret = sendKey(getCombo('pasteFn'))
                        hs.timer.delayed.new(.5, function()
                          log('Special paste. pasteboard=' .. hs.pasteboard.getContents())
                        end):start()
                        return ret
  end,

  shiftFwdDelete = function()
                        --hs.alert(hs.application.frontmostApplication():name())
                        ret = sendKey(getCombo('cut'))
                        hs.timer.delayed.new(.51, function()
                          log('Special cut. pasteboard=' .. hs.pasteboard.getContents())
                        end):start()
                        return ret
  end

}

keyFuncs = {
  noMods = {
    [96] = keyEvents.ctrlR,
    [115] = keyEvents.home,
    [119] = keyEvents.endKey
  },
  ctrlMods = {
    [0] = keyEvents.ctrlA,
    [1] = keyEvents.ctrlS,
    [3] = keyEvents.ctrlF,
    [6] = keyEvents.ctrlZ,
    [7] = keyEvents.ctrlX,
    [8] = keyEvents.ctrlC,
    [9] = keyEvents.ctrlV,
    [11] = keyEvents.ctrlB,
    [13] = keyEvents.ctrlW,
    [15] = keyEvents.ctrlR, -- F5
    [16] = keyEvents.ctrlY,
    [32] = keyEvents.ctrlU,
    [34] = keyEvents.ctrlI,
    [115] = keyEvents.ctrlHome,
    [119] = keyEvents.ctrlEnd,
    [123] = keyEvents.ctrlRight,
    [124] = keyEvents.ctrlLeft
  },
  shiftMods = {
    [115] = keyEvents.shiftHome,
    [117] = keyEvents.shiftFwdDelete,
    [119] = keyEvents.shiftEnd
  },
  ctrlShiftMods = {
    [115] = keyEvents.ctrlShiftHome,
    [119] = keyEvents.ctrlShiftEnd,
    [123] = keyEvents.ctrlShiftRight,
    [124] = keyEvents.ctrlShiftLeft
  },
  cmdMods = {
    -- For future fun with Microsoft Remote Desktop and VirtualBox
    -- On those apps, controling a Windoz machine|VM, command is the
    -- host key (Windows key).

    -- Also here would go any function mappings you want for Shortcuts
    -- where you want to map a command+key to something besides its
    -- native action.
  }
}
