---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "ChildrenSymbol.scene",

	{
		[Symbols.Type] = "UIBase",

		Test = {
			[Symbols.Children] = {
				a = {
					Class = "TextButton",
					BackgroundColor3 = Color3.fromRGB(150, 50, 42),

					[Symbols.Event("MouseButton1Click")] = function(object)
						object.BackgroundColor3 = Color3.new(math.random() / 1, math.random() / 1, math.random() / 1)
					end,
				},
			},
		},
	},
}
