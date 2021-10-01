DEBUG = true
CLEAR_LOG_ON_HYPER_KEY = true
EVENTPROPERTY_EVENTSOURCEUSERDATA = 42 -- print(hs.inspect(hs.eventtap.event.properties))
-- For bindings that require canceling the current key event and spawing a new event with a delay
keySendDelay =.05
-- Used to prevent recurison
semaphore = 0
userData = 55555
skipToggle = false

ultra = { 'ctrl', 'alt', 'cmd' }

-- Map keys entered to corresponding action
keyEvents = {
  clear          = function()  return sendKey(getCombo('clear')) end,
  zero           = function()  return sendKey({{}, '0'}) end,
  one            = function()  return sendKey({{}, '1'}) end,
  two            = function()  return sendKey({{}, '2'}) end,
  three          = function()  return sendKey({{}, '3'}) end,
  four           = function()  return sendKey({{}, '4'}) end,
  five           = function()  return sendKey({{}, '5'}) end,
  six            = function()  return sendKey({{}, '6'}) end,
  seven          = function()  return sendKey({{}, '7'}) end,
  eight          = function()  return sendKey({{}, '8'}) end,
  nine           = function()  return sendKey({{}, '9'}) end,
  -- See actions.lua for the actions (param to getCombo) and for mapping them to specific applications
  --ctrlLeft       = function()  return sendKey(getCombo('nextWord')) end,
	ctrlLeft       = function()  return moveBeginingOfNextWord() end,
  ctrlShiftLeft  = function()  return sendKey(getCombo('selectNextWord')) end,
  --ctrlRight      = function()  return sendKey(getCombo('prevWord')) end,
	ctrlRight      = function()  return moveBeginingOfPreviousWord() end,
  ctrlShiftRight = function()  return sendKey(getCombo('selectPrevWord')) end,
  home           = function(e) return sendKey(getCombo('beginLine')) end,
  shiftHome      = function(e) return sendKey(getCombo('selectBeginLine')) end,
  ctrlHome       = function()  return sendKey(getCombo('beginDoc')) end,
  ctrlShiftHome  = function()  return sendKey(getCombo('selectDocBegin')) end,
  endKey         = function()  return sendKey(getCombo('endLine')) end,
  shiftEnd       = function()  return sendKey(getCombo('selectEndLine')) end,
  ctrlEnd        = function()  return sendKey(getCombo('endDoc')) end,
  ctrlShiftEnd   = function(e) return sendKey(getCombo('selectDocEnd')) end,
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
  ctrlN          = function()  return sendKeyOrMenu('new') end,
  ctrlS          = function()  return sendKeyOrMenu('save') end,
  ctrlY          = function()  return sendKeyOrMenu('redo') end,
  ctrlZ          = function()  return sendKey(getCombo('undo')) end,
  f2             = function()  return sendKeyOrMenu('rename') end,
  f3             = function()  return sendKeyOrMenu('findagain') end,

  -- These are being monitored special because of issue where taps (keyDown) are inexplicably stopping
  -- Goal: Store eventtaps as variables, if I find taps are not trapping events, hit a shortcut to log
  -- out the eventtap variables. If they are still there, then that will help narrow down the problem
  -- (i.e., get as much data as possible before filing the issue).
  ctrlC          = function()
                      ret = sendKeyOrMenu('copy')
                      hs.timer.delayed.new(1, function()
                      if DEBUG and not hs.pasteboard.getContents() == nil then
                        log('Regular copied. pasteboard=' .. hs.pasteboard.getContents())
                      end
                    end):start()
                    return ret
  end,

  ctrlFn         = function()
                      ret = sendKey(getCombo('copyFn'), true, true)
                      hs.timer.delayed.new(.5, function()
                        if DEBUG and not hs.pasteboard.getContents() == nil then
                          log('Special copy. pasteboard=' .. hs.pasteboard.getContents())
                        end
                      end):start()
                    return ret
  end,

  shiftFn        = function()
                      ret = sendKey(getCombo('pasteFn'), true, true)
                      hs.timer.delayed.new(.5, function()
                        if DEBUG and not hs.pasteboard.getContents() == nil then
                          log('Special paste. pasteboard=' .. hs.pasteboard.getContents())
                        end
                    end):start()
                    return ret
  end,

  shiftFwdDelete = function()
                      --hs.alert(hs.application.frontmostApplication():name())
                      ret = sendKey(getCombo('cut'))
                      hs.timer.delayed.new(.51, function()
                        if DEBUG and not hs.pasteboard.getContents() == nil then
                          log('Special cut. pasteboard=' .. hs.pasteboard.getContents())
                        end
                    end):start()
                    return ret
  end

}

-- Map keycodes to corresponding custom events
keyFuncs = {
  noMods = {
    --[71] = keyEvents.clear,
    --[82] = keyEvents.zero,
    --[83] = keyEvents.one,
    --[84] = keyEvents.two,
    --[85] = keyEvents.three,
    --[86] = keyEvents.four,
    --[87] = keyEvents.five,
    --[88] = keyEvents.six,
    --[89] = keyEvents.seven,
    --[91] = keyEvents.eight,
    --[92] = keyEvents.nine,
    [96] = keyEvents.ctrlR, -- F5 (reload)
    [99] = keyEvents.f3, -- F3
    [114] = keyEvents.insert,
    [115] = keyEvents.home,
    [119] = keyEvents.endKey,
    [120] = keyEvents.f2 -- F2 (edit cell/ Finder: rename)
  },
  altMods = {
    [125] = keyEvents.ctrlEnd,
    [126] = keyEvents.ctrlHome
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
    [15] = keyEvents.ctrlR,
    [16] = keyEvents.ctrlY,
    [31] = keyEvents.ctrlO,
    [32] = keyEvents.ctrlU,
    [34] = keyEvents.ctrlI,
    [45] = keyEvents.ctrlN,
    [114] = keyEvents.ctrlC,
    [115] = keyEvents.ctrlHome,
    [119] = keyEvents.ctrlEnd,
    [123] = keyEvents.ctrlRight,
    [124] = keyEvents.ctrlLeft
  },
  shiftMods = {
    [114] = keyEvents.ctrlV,
    [115] = keyEvents.shiftHome,
    [117] = keyEvents.shiftFwdDelete,
    [119] = keyEvents.shiftEnd
  },
  ctrlShiftMods = {
    [114] = keyEvents.shiftCtrlInsert,
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
