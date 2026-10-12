local module = {}

local function defaultSearchPath(name)
  return package.searchpath(name, package.path)
end

function module.preflight(moduleNames, searchPath, loadFile)
  searchPath = searchPath or defaultSearchPath
  loadFile = loadFile or loadfile

  for _, name in ipairs(moduleNames) do
    local path, searchError = searchPath(name)
    if path == nil then
      error("Unable to find module '" .. name .. "': " .. tostring(searchError), 0)
    end

    local chunk, syntaxError = loadFile(path)
    if chunk == nil then
      error('Unable to compile ' .. path .. ': ' .. tostring(syntaxError), 0)
    end
  end
end

function module.stopHooks(hooks)
  for _, hook in pairs(hooks) do
    if hook ~= nil then
      local stop = hook.stop or hook.disable
      if stop ~= nil then
        pcall(stop, hook)
      end
    end
  end
end

function module.run(moduleNames, searchPath, loadFile, loadModule, onFailure)
  loadModule = loadModule or require

  local ok, message = xpcall(function()
    module.preflight(moduleNames, searchPath, loadFile)
    for _, name in ipairs(moduleNames) do
      loadModule(name)
    end
  end, debug.traceback)

  if not ok and onFailure ~= nil then
    pcall(onFailure, message)
  end

  return ok, message
end

return module
