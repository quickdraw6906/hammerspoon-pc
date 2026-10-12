-- See README for known issues!

-- -------------------------------------------------------------------------------------
-- Goals:
--
-- GTD = Extension of Getting Things Done (trying to get organized)
--        (http://lifehacker.com/productivity-101-a-primer-to-the-getting-things-done-1551880955)
--
-- Augment cut/copy/paste functions with shortcuts that are more efficient
-- Launch favorite browser with hyper+space (or bring forward already open window)
-- Open a new terminal window
-- Allow paste into password fields that block paste operation
-- Use PC shortcut behavior including inside the Microsoft Remote Desktop (RDP) app (cut/copy/paste, cursor movement) (a work in progress)
-- Add a convenient function to lock the Mac, displaying the user menu without sleeping first
-- GTD: Open a Grab selection session and copy the result to the clipboard
-- -------------------------------------------------------------------------------------
hs.console.clearConsole()

hs.hotkey.alertDuration=0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

local startup = require 'startup'

-- Compile every module before executing any of them. A syntax error must never leave a
-- partially loaded configuration intercepting keyboard or mouse input.
local configModules = {
  'application',
  '3rdparty',
  'functions',
  'screen_grab',
  'actions',
  'config',
  'taps_keyDown',
  'taps_keyUp',
  'taps_primaryClickDown',
  'taps_flagsChanged',
  'bindings'
}

inputHotkeys = {}

function bindInputHotkey(...)
  local hotkey = hs.hotkey.bind(...)
  table.insert(inputHotkeys, hotkey)
  return hotkey
end

local function disableInputHooks()
  local hooks = {
    etNSKeyDown,
    etKeyDown,
    etKeyUp,
    etRtClickDown,
    etFlags
  }

  for _, hotkey in ipairs(inputHotkeys) do
    table.insert(hooks, hotkey)
  end

  startup.stopHooks(hooks)
end

local loaded, loadError = startup.run(
  configModules,
  nil,
  nil,
  require,
  function(message)
    disableInputHooks()
    print('FATAL: Configuration failed to load. All input hooks were disabled.\n' .. tostring(message))
    pcall(hs.alert.show, 'Configuration error: input hooks disabled. See the Hammerspoon console.')
  end
)

if loaded then
  hs.alert.show('Config loaded with console alpha level ' .. hs.console.alpha() .. '. Accessabilitity=' .. string.format("%s", hs.accessibilityState()))
else
  print(loadError)
end
