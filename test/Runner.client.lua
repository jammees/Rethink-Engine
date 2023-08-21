---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene

local DebugConsole = require(script.Parent.DebugConsole)

Scene.RegisterCustomSymbol("testSymbol", 0, function(object, symbol)
	object.Symbols.testSymbol = symbol.SymbolData.Attached
end)

Rethink.Init()
DebugConsole.Start()
