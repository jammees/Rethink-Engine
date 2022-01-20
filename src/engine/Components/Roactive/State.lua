--!strict

--[[

  State objects will take a value (or tuple of values) and
  await updates. You can provide custom functionality by
  adding a function or some table with an :Update() method
  to the state object's dependent set.

]]

local Dependents = require(script.Parent.Util.Dependents)

local State = {}

--[[
  Set the value of a state object.
]]
function State:Set(...)
  local changed = false
  local newValue = {...}

  -- Determine if value has changed
  if #newValue ~= #self._value then
    changed = true
  else
    for index in pairs(newValue) do
      if newValue[index] ~= self._value[index] then
        changed = true
        break
      end
    end
  end

  -- Update dependents if value has changed
  if changed then
    self._value = newValue

    for dependent in pairs(self._dependents) do
      local success = Dependents:UpdateDependent(dependent)

      -- Remove dependent if it is no longer updating
      if not success then
        self._dependents[dependent] = nil
      end
    end
  end
end

--[[
  Returns the current value of the state object.
  Optional second argument to determine if the
  object can be a dependency.
]]
function State:Get(asDependency: boolean?)
  if asDependency ~= false then
    Dependents:AsDependency(self)
  end

  return unpack(self._value)
end

--[[
  Destroys a state object by removing all
  dependents therefore making updates useless.
]]
function State:Destroy()
  for dependent in pairs(self._dependents) do
    Dependents:DestroyDependent(dependent, function()
      self._dependents[dependent] = nil
    end)
  end
end

return function(...)
  return setmetatable({
    type = 'State',

    _value = {...},
    _dependents = {} :: Dependents.Set<() -> () | { any }>,
  }, {
    __index = State,
    __tostring = function(this)
      return if #this._value == 1 then string.format('State(%d)', this._value[1]) else 'State(...)'
    end
  })
end
