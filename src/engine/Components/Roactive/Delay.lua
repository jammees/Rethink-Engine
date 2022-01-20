--!strict

--[[

  Delay objects take a state object and
  constant duration in seconds and delay
  state changes by that duration.

]]

local Dependents = require(script.Parent.Util.Dependents)

local Delay = {}

--[[
  Returns the current value of the delay object. Optional second
  argument to determine if the object can be a dependency.
]]
function Delay:Get(asDependency: boolean?)
  if asDependency ~= false then
    Dependents:AsDependency(self)
  end

  return unpack(self._currentValue)
end

--[[
  Uses the task library to delay a state change on the delay
  object's state dependency based on given duration.
]]
function Delay:Update()
  local goal = { self._state:Get(false) }

  task.delay(
    self._duration,
    function()
      self._currentValue = goal

      for dependent in pairs(self._dependents) do
        Dependents:UpdateDependent(dependent)
      end
    end
  )

  return true
end

--[[
  Destroys a delay object by removing all
  dependents therefore making updates useless.
]]
function Delay:Destroy()
  for dependent in pairs(self._dependents) do
    Dependents:DestroyDependent(dependent, function()
      self._dependents[dependent] = nil
    end)
  end
end

return function(state, duration: number)
  local self = setmetatable({
    type = 'Delay',

    _dependents = {} :: Dependents.Set<() -> () | { any }>,
    _state = state,
    _currentValue = { state:Get(false) },
    _duration = duration,
  }, {
    __index = Delay,
    __tostring = function(this)
      return if #this._currentValue == 1 then string.format('Delay(%s, %d)', this._currentValue[1], this._duration) else string.format('Delay(..., %d)', this._duration)
    end
  })

  state._dependents[self] = true

  return self
end