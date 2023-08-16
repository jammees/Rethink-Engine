---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "event_wrong_args.scene",

	{
		MyObject = {
			[Symbols.Event(true)] = function() end,
			[Symbols.Event("MouseEnter")] = true,
			[Symbols.Event("MouseEnter")] = function() end,
		},
	},
}
