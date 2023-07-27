---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local DebugConsole = require(script.Parent.DebugConsole)

Rethink.Init()
DebugConsole.Start()
