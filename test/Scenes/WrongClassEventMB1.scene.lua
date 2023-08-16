---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "WrongClassEventMB1.scene",

	{
		[Symbols.Type] = "UIBase",

		WrongClass = {
			[Symbols.Event("MouseButton1Click")] = function(thisObject)
				print(thisObject)
			end,
		},

		RightClass = {
			[Symbols.Class] = "TextButton",
			[Symbols.Event("MouseButton1Click")] = function(thisObject)
				print(thisObject)
			end,
		},
	},
}
