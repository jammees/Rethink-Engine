--!strict

--[[

  Provides utility functions to be
  used by Roactive objects and their
  reactive graphs.

]]

local Dependents = {}

export type Set<T> = { [T]: boolean }

--[[
  Captures the dependencies of a given dependent.
]]
function Dependents:CaptureDependencies(dependent)
  self._target = dependent

  if typeof(dependent) == 'function' then
    dependent()
  elseif typeof(dependent) == 'table' and dependent.Update then
    dependent:Update()
  end

  self._target = nil
end

--[[
  Updates a dependent based on
  its type.
]]
function Dependents:UpdateDependent(dependent)
  -- Dependents can be a function or table
  if typeof(dependent) == 'function' then
    dependent()
  elseif typeof(dependent) == 'table' and dependent.Update then
    return dependent:Update()
  end

  return true
end

--[[
  Destroys a dependent based on
  its type. Cleanup method should
  also be provided to do additional
  cleaning after destruction has occured.
]]
function Dependents:DestroyDependent(dependent, cleanup: () -> ())
  -- Table dependents can implement their own cleanup functionality
  if typeof(dependent) == 'table' then
    if dependent.Destroy then
      dependent:Destroy()
      task.defer(cleanup)
    end
  else
    cleanup()
  end
end

--[[
  Turns an object into a dependency by adding
  to its dependent set.
]]
function Dependents:AsDependency(dependency)
  local target = self._target

  if target and not dependency._dependents[target] then
    dependency._dependents[target] = true
  end
end

return Dependents