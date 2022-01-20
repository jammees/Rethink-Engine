--!strict

--[[

  Roactive is a lightweight and fast reactive state
  library made specifically for use in Roblox.

  Inspiration taken from Vue.js and Fusion.

]]

local State = require(script.State)
local Delay = require(script.Delay)
local Stopwatch = require(script.Stopwatch)
local Watcher = require(script.Watcher)

type Dependency = {
  Get: (asDependency: boolean?) -> any,
}

type Dependent = {
  Update: () -> boolean,
}

export type State = Dependency & {
  type: string,
  Set: () -> (),
  Destroy: () -> (),
}

export type Delay = Dependency & Dependent & {
  type: string,
  Destroy: () -> (),
}

export type Stopwatch = Dependency & Dependent & {
  type: string,
  Destroy: () -> (),
}

export type Watcher = Dependent & {
  type: string,
  Destroy: () -> ()
}

export type StopwatchSettings = Stopwatch.StopwatchSettings

return {
  State = State,
  Delay = Delay,
  Stopwatch = Stopwatch,
  Watcher = Watcher,
}


