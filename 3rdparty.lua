-- -------------------------------------------------------------------------------------
-- Sample-Configurations
-- https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations

-- -------------------------------------------------------------------------------------
-- Thanks to vic for the smart app laucher
-- https://github.com/vic/.hammerspoon/blob/master/ext/application.lua
-- See also application.lua
-- Launch Chrome or focus it if already running
require 'application'
local module = {}
smartLaunchOrFocus = require('application').smartLaunchOrFocus

-- -------------------------------------------------------------------------------------
-- Thanks to gwww for these goodies"
-- https://github.com/gwww/dotfiles/blob/master/_hammerspoon/init.lua

local configFileWatcher = nil
local appWatcher = nil

-- Reload config automatically
function reloadConfig()
  configFileWatcher:stop()
  configFileWatcher = nil
  appWatcher:stop()
  appWatcher = nil
  hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- Callback function for application events
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
