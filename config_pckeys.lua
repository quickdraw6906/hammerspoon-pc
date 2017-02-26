DEBUG = false
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
  find           = function()  return sendKey(getCombo('find')) end,
  ctrlX          = function()  return sendKeyOrMenu('cut') end,
  ctrlA          = function()  return sendKeyOrMenu('selectAll') end,
  ctrlB          = function()  return sendKey(getCombo('bold')) end,
  ctrlI          = function()  return sendKey(getCombo('italic')) end,
  ctrlU          = function()  return sendKey(getCombo('underline')) end,
  ctrlW          = function()  return sendKey(getCombo('close')) end,
  ctrlR          = function()  return sendKey(getCombo('reload')) end,
  ctrlP          = function()  return sendKeyOrMenu('paste') end,
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
                        ret = sendKey(getCombo('copy'))
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
