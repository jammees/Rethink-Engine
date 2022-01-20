--!strict

--[[

  Stopwatches increment/decrement repeatedly based on
  the provided interval in seconds.

]]

local RunService = game:GetService('RunService')

local Dependents = require(script.Parent.Util.Dependents)
local isStateful = require(script.Parent.Util.isStateful)

local Stopwatch = {}

export type StopwatchSettings = {
  interval: number?,
  increment: number?,
  startPosition: number?,
  goal: number?,
  playing: any?,
}

--[[
  Returns the current value of the stopwatch.
  Optional second argument to determine if
  the object can be a dependency.
]]
function Stopwatch:Get(asDependency: boolean?)
  if asDependency ~= false then
    Dependents:AsDependency(self)
  end

  return self._position
end

--[[
  Updates a stopwatch's playing value if playing
  is a state object.
]]
function Stopwatch:Update()
  self._playing = if self._playingIsState then self._playingState:Get(false) else self._playing

  if not self._connection then
    return false
  end

  return true
end

--[[
  Destroys a stopwatch object by removing all
  dependents therefore making updates useless.
  All connections are also disconnected.
]]
function Stopwatch:Destroy()
  for dependent in pairs(self._dependents) do
    Dependents:DestroyDependent(dependent, function()
      self._dependents[dependent] = nil
    end)
  end

  if self._connection then
    self._connection:Disconnect()
    self._connection = nil
  end
end

return function(settings: StopwatchSettings?)
  settings = settings or {}

  local interval = settings.interval or 1
  local increment = settings.increment or 1
  local startPos = settings.startPosition or 0
  local goal = settings.goal
  local playing = settings.playing == nil and true or settings.playing

  local playingIsState = false

  -- Determine if `playing` is a state object
  -- if typeof(playing) == 'table' and (playing.type == 'State' or playing.type == 'Delay') then
  if isStateful(playing) then
    playingIsState = true
  end

  local self = setmetatable({
    type = 'Stopwatch',

    _dependents = {} :: Dependents.Set<() -> () | { any }>,
    _position = startPos,
    _playing = if playingIsState then playing:Get(false) else playing,
    _playingState = if playingIsState then playing else nil,
    _playingIsState = playingIsState,
    _connection = nil,
  }, {
    __index = Stopwatch,
    __tostring = function(this)
      return string.format('Stopwatch(%d)', this._position)
    end
  })

  if playingIsState then
    playing._dependents[self] = true
  end

  local last = os.clock()
  self._connection = RunService.Heartbeat:Connect(function()
    if not self._playing then
      return
    end

    local now = os.clock()
    if now - last >= interval then
      last = now
      self._position += increment
      
      -- Update all dependents
      for dependent in pairs(self._dependents) do
        local success = Dependents:UpdateDependent(dependent)

        -- Remove dependent if it is no longer updating
        if not success then
          self._dependents[dependent] = nil
        end
      end

      if goal then
        if self._position >= goal then
          self:Destroy()
          self._position = goal
        end
      end
    end
  end)

  return self
end