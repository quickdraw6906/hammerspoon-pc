DEBUG = true
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
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {}
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
  cut = { -- No default key here will signal a menu command instead. See sendKeyOrMenu()
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'X'}
  },
  copy = {
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'C'}
  },
  paste = {
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'V'}
  },
  save = {
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'S'}
  },
  undo = {
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'Z'}
  },
  redo = {
    Microsoft_Remote_Desktop = {},
    VirtualBox_VM = {{'ctrl'}, 'Y'}
  },
  altLeft = {
    default = {{'alt'}, 'left'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  altRight = {
    default = {{'alt'}, 'right'},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  homeKey = {
    default = {{'cmd'}, 'left'},
    Terminal = {{'ctrl'}, 'a'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  endKey = {
    default = {{'cmd'}, 'right'},
    Terminal = {{'ctrl'}, 'e'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  shiftHome = {
    default = {{'cmd', 'shift'}, 'left'},
    Terminal = {{'ctrl'}, 'a'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  shiftEnd = {
    default = {{'cmd', 'shift'}, 'right'},
    Terminal = {{'ctrl'}, 'e'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  close = {
    default = {{'cmd'}, 'W'},
    Microsoft_Remote_Desktop = {{'ctrl'}, 'W'}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {{'ctrl'}, 'W'}
  },
  selectAll = {
    --default = {{'cmd'}, 'a'}, -- Deprecated. For an unknown reason, cmd+a would not send! Sending menu command instead
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
  }

}

keyEvents = {
  altLeft   = function(finish) return sendKey(getCombo('altLeft'), finish) end,
  altRight  = function(finish) return sendKey(getCombo('altRight'), finish) end,
  endKey    = function() return sendKey(getCombo('endKey')) end,
  homeKey   = function() return sendKey(getCombo('homeKey')) end,
  shiftHome = function() return sendKey(getCombo('shiftHome')) end,
  shiftEnd  = function() return sendKey(getCombo('shiftEnd')) end,
  ctrlHome  = function(e) return sendCtrlEndHome(e) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  ctrlEnd   = function(e) return sendCtrlEndHome(e) end, -- Not handling for Microsoft Remote Desktop (who the heck does this anyway?)
  menuCut   = function() return sendKeyOrMenu('cut') end,
  menuCopy  = function() return sendKeyOrMenu('copy') end,
  menuPaste = function() return sendKeyOrMenu('paste') end,
  menuSave  = function() return sendKeyOrMenu('save') end,
  menuUndo  = function() return sendKeyOrMenu('undo') end,
  menuRedo  = function() return sendKeyOrMenu('redo') end,
  selectAll = function() return sendKeyOrMenu('selectAll') end,
  --selectAll = function() return sendKey(getCombo('selectAll')) end
  bold      = function() return sendKey(getCombo('bold')) end,
  italic    = function() return sendKey(getCombo('italic')) end,
  underline = function() return sendKey(getCombo('underline')) end
}
