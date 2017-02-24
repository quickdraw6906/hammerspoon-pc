DEBUG = false
CLEAR_LOG_ON_HYPER_KEY = true
EVENTPROPERTY_EVENTSOURCEUSERDATA = 42 -- print(hs.inspect(hs.eventtap.event.properties))

-- For bindings that require canceling the current key event and spawing a new event with a delay
keySendDelay =.01

-- Used to prevent recurison
semaphore = 0
userData = 55555

hs.hotkey.alertDuration=0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

ultra = { 'ctrl', 'alt', 'cmd' }

-- Menu item paths
menuPath = {
  cut = {
    default = {'Edit', 'Cut'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  copy = {
    default = {'Edit', 'Copy'},
    Microsoft_Remote_Desktop = {}
  },
  paste = {
    default = {'Edit', 'Paste'},
    TextMate = {'Edit', 'Paste', 'Paste'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  save = {
    default = {'File', 'Save'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  undo = {
    default = {'Edit', 'Undo'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  redo = {
    default = {'Edit', 'Redo'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  selectAll = {
    default = {'Edit', 'Select All'},
    TextMate = {'Edit', 'Select', 'All'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  }
}

combo = {

  find = {
    default = {{'cmd'}, 'f'},
    Microsoft_Remote_Desktop = {}, -- Non Mac OS contexts need this so a menu item isn't attempted by sendKeyOrMenu()
    VirtualBox_VM = {}
  },
  cut = { -- No default key here will signal a menu command instead. See sendKeyOrMenu()
    default = {{'cmd'}, 'x'},
    Microsoft_Remote_Desktop = {}, -- Non Mac OS contexts need this so a menu item isn't attempted by sendKeyOrMenu()
    VirtualBox_VM = {}
  },
  copy = {
    default = {{'cmd'}, 'c'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  paste = {
    default = {{'cmd'}, 'v'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  copyFn = { -- Used by ctrl+fn which can't pass that combo through to non-mac contexts
    default = {{'cmd'}, 'c'},
    Microsoft_Remote_Desktop = {{'ctrl'}, 'c'},
    VirtualBox_VM = {{'ctrl'}, 'c'}
  },
  pasteFn = { -- Used by ctrl+fn which can't pass that combo through to non-mac contexts
    default = {{'cmd'}, 'v'},
    Microsoft_Remote_Desktop = {{'ctrl'}, 'p'},
    VirtualBox_VM = {{'ctrl'}, 'p'}
  },
  save = {
    default = {{'cmd'}, 's'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  undo = {
    default = {{'cmd'}, 'z'},
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
  },
  redo = {
    default = {{'cmd'}, 'y'}, -- No always implemented by apps. Try removing to have a menu item attempted
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'y'}
  },

  nextWord = {
    default = {{'alt'}, 'right'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  selectNextWord = {
    default = {{'alt', 'shift'}, 'right'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },

  prevWord = {
    default = {{'alt'}, 'left'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  selectPrevWord = {
    default = {{'alt', 'shift'}, 'left'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },

  endLine = {
    default = {{'cmd'}, 'right'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  selectEndLine = {
    default = {{'cmd', 'shift'}, 'right'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  beginLine = {
    default = {{'cmd'}, 'left'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  selectBeginLine = {
    default = {{'cmd', 'shift'}, 'left'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  docBegin = { -- This won't do what it says in "smart" editors. Add a combo for your real app (like Atom) in this block
    default = {{'cmd'}, 'up'},
    Microsoft_Remote_Desktop = {}, -- NOOP. User should type ctrl+home
    VirtualBox_VM = {}
  },
  selectDocBegin = { -- This won't do what it says in "smart" editors. Add a combo for your real app (like Atom) in this block
    default = {{'cmd','shift'}, 'up'},
    Microsoft_Remote_Desktop = {}, -- NOOP. User should type ctrl+shift+home
    VirtualBox_VM = {}
  },

  docEnd = { -- This won't do what it says in "smart" editors. Add a combo for your real app (like Atom) in this block
    default = {{'cmd'}, 'down'},
    Microsoft_Remote_Desktop = {}, -- NOOP. User should type ctrl+end
    VirtualBox_VM = {}
  },
  selectDocEnd = { -- This won't do what it says in "smart" editors. Add a combo for your real app (like Atom) in this block
    default = {{'cmd', 'shift'}, 'down'},
    Microsoft_Remote_Desktop = {}, -- NOOP. User should type ctrl+end
    VirtualBox_VM = {}
  },

  close = {
    default = {{'cmd'}, 'W'},
    Microsoft_Remote_Desktop = {{'ctrl'}, 'W'}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {{'ctrl'}, 'W'}
  },
  selectAll = {
    --default = {{'cmd'}, 'a'}, -- Deprecated. For an unknown reason, cmd+a would not send! Since no default here, sendKeyOrMenu() will look to send a menu command instead
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  bold = {
    default = {{'cmd'}, 'b'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  italic = {
    default = {{'cmd'}, 'i'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  underline = {
    default = {{'cmd'}, 'u'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  reload = {
    default = {{'cmd'}, 'r'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  }
}

keyEvents = {
  ctrlLeft       = function() return sendKey(getCombo('nextWord')) end,
  ctrlShiftLeft  = function() return sendKey(getCombo('selectNextWord')) end,

  ctrlRight      = function() return sendKey(getCombo('prevWord')) end,
  ctrlShiftRight = function() return sendKey(getCombo('selectPrevWord')) end,

  home           = function(e) return sendKey(getCombo('beginLine')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  shiftHome      = function(e) return sendKey(getCombo('selectBeginLine')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)

  ctrlHome       = function() return sendKey(getCombo('docBegin')) end,
  ctrlShiftHome  = function() return sendKey(getCombo('selectDocBegin')) end,

  endKey         = function() return sendKey(getCombo('endLine')) end,
  shiftEnd       = function() return sendKey(getCombo('selectEndLine')) end,

  ctrlEnd        = function(e) return sendKey(getCombo('docEnd')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  ctrlShiftEnd   = function(e) return sendKey(getCombo('selectDocEnd')) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)

  find           = function() return sendKey(getCombo('find')) end,

  ctrlX          = function() return sendKeyOrMenu('cut') end,
  ctrlC          = function()
    ret = sendKeyOrMenu('copy')
    hs.timer.delayed.new(1, function()
      dump('Regular copied. pasteboard=' .. hs.pasteboard.getContents())
    end):start()
    return ret
  end,
  ctrlP          = function() return sendKeyOrMenu('paste') end,
  ctrlS          = function() return sendKeyOrMenu('save') end,
  ctrlZ          = function() return sendKeyOrMenu('undo') end,
  ctrlY          = function() return sendKeyOrMenu('redo') end,

  ctrlFn         = function()
    ret = sendKey(getCombo('copy'))
      hs.timer.delayed.new(1, function()
    	dump('Copied. pasteboard=' .. hs.pasteboard.getContents())
    end):start()
    return ret
  end,
  --function() return sendKey(getCombo('copyFn')) end,
  shiftFn        = function() return sendKey(getCombo('pasteFn')) end,
  shiftFwdDelete = function()
    --hs.alert(hs.application.frontmostApplication():name())
    ret = sendKey(getCombo('cut'))
    hs.timer.delayed.new(1, function()
      dump('Special cut. pasteboard=' .. hs.pasteboard.getContents())
    end):start()
    return ret
  end,
  --return sendKey(getCombo('cut')) end,

  ctrlA          = function() return sendKeyOrMenu('selectAll') end,

  ctrlB          = function() return sendKey(getCombo('bold')) end,
  ctrlI          = function() return sendKey(getCombo('italic')) end,
  ctrlU          = function() return sendKey(getCombo('underline')) end,

  ctrlW          = function() return sendKey(getCombo('close')) end,

  ctrlR          = function() return sendKey(getCombo('reload')) end
}
