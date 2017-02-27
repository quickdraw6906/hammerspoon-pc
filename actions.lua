-- -------------------------------------------------------------------------------------
-- Key Combinations - See sendKey() and sendKeyOrMenu()
-- -------------------------------------------------------------------------------------

--[[

This is a description of every action you do on a keyboard for which you want some
other action than the printing of a character.

Examples of actions you might want:

Activate a menu item
Open a program and perform one or more actions in that programs
Add to the pasteboard and manipulate do something with its contents
Undo or Redo an application action
Move the cursor to a certain place
Stylize selected text
Reload the current browser page
Go to a URL

...and so on...

An issue arises when how an action is performed differs between applications, either
by way of a menu path difference (Edit->Paste vs. Edit-Paste(submenu)->Paste) or because
the function has a different shortcut. A third class of issue woiuld be how to handle
remote computer control software, either a remote server or a virtual machine.

In the third class of actions, there needs to be a way to have the action be simply passing
through the keystroke(s) you entered.

Below, add all action to application mappings needed. Use an empty table to have the
straight keystroke/combo sent unaltered.

]]


-- Any apps that should get sent the typed shortcut unaltered (not the default) should have an entry for that shortcut
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
    Microsoft_Remote_Desktop = {{'ctrl'}, 'v'},
    VirtualBox_VM = {{'ctrl'}, 'v'}
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
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  selectNextWord = {
    default = {{'alt', 'shift'}, 'right'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  prevWord = {
    default = {{'alt'}, 'left'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  selectPrevWord = {
    default = {{'alt', 'shift'}, 'left'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  endLine = {
    default = {{'cmd'}, 'right'},
    Terminal = {'ctrl', 'e'},
    VirtualBox_VM = {},
    Microsoft_Remote_Desktop = {} -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
  },
  selectEndLine = {
    default = {{'cmd', 'shift'}, 'right'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  beginLine = {
    default = {{'cmd'}, 'left'},
    Terminal = {'ctrl', 'a'},
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

  open = {
    default = {{'cmd'}, 'o'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  new = {
    default = {{'cmd'}, 'n'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },
  close = {
    default = {{'cmd'}, 'w'},
    Microsoft_Remote_Desktop = {}, -- NOOP. Pass through key as typed (bound function returns false (don't cancel event))
    VirtualBox_VM = {}
  },

  selectAll = {
    --default = {{'cmd'}, 'a'}, -- Deprecated. For an unknown reason, cmd+a would not send! Since no default here, sendKeyOrMenu() will look to send a menu command instead
    Terminal = {'ctrl', 'a'},
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

-- -------------------------------------------------------------------------------------
-- Menu item paths - See selectMenuItem()
-- -------------------------------------------------------------------------------------
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
  rename = {
    Finder = {'File', 'Rename'},
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
