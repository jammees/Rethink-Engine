--!strict

--[[

  Watchers will take a target function and
  capture any state dependencies used within
  the function. The target function will
  become a dependent of the state object
  and will be called whenever state updates.

]]

local Dependents = require(script.Parent.Util.Dependents)

local Watcher = {}

--[[
  Calls the target function whenever
  an update occurs.
]]
function Watcher:Update()
  if self._target then
    self._target()
    return true
  end

  return false
end

--[[
  Sets the target to nil so that updates
  stop occuring and the object is removed
  as a dependent of its dependencies.
]]
function Watcher:Destroy()
  self._target = nil
end

return function(target: () -> ())
  local self = setmetatable({
    type = 'Watcher',

    _target = target,
  }, {
    __index = Watcher,
    __tostring = function(this)
      return string.format('Watcher(%s)', tostring(this._target ~= nil))
    end,
  })

  Dependents:CaptureDependencies(self)

  return self
end
