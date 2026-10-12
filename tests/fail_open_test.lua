package.path = './?.lua;' .. package.path

local startup = require('startup')

local function assertEqual(actual, expected, message)
  if actual ~= expected then
    error((message or 'values differ') .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
  end
end

local function testPreflightFailurePreventsModuleExecution()
  local loadedModules = 0
  local failureMessage = nil

  local ok = startup.run(
    {'valid', 'broken'},
    function(name)
      return '/config/' .. name .. '.lua'
    end,
    function(path)
      if path == '/config/broken.lua' then
        return nil, "unexpected symbol near 'end'"
      end
      return function() end
    end,
    function()
      loadedModules = loadedModules + 1
    end,
    function(message)
      failureMessage = message
    end
  )

  assertEqual(ok, false, 'startup should fail')
  assertEqual(loadedModules, 0, 'no module should execute before every module compiles')
  assert(failureMessage:match('broken.lua'), 'failure should identify the broken module')
end

local function testFailureStopsEveryInputHook()
  local stopped = {}
  local hooks = {
    first = {stop = function() stopped.first = true end},
    broken = {stop = function() error('stop failed') end},
    last = {stop = function() stopped.last = true end}
  }

  startup.stopHooks(hooks)

  assertEqual(stopped.first, true, 'first hook should stop')
  assertEqual(stopped.last, true, 'cleanup should continue after one hook fails to stop')
end

testPreflightFailurePreventsModuleExecution()
testFailureStopsEveryInputHook()
print('fail-open startup tests passed')
