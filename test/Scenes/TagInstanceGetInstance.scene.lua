---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.GetModules().Scene.Symbols

return {
	Name = "Tag-, GetInstance symbol",

	{
		[Symbols.Type] = "UIBase",
		[Symbols.Property] = {
			[Symbols.LinkTag] = "test",
		},

		SelectionObject = {
			[Symbols.LinkTag] = "hello world",
		},

		Base = {
			BackgroundColor3 = Color3.fromRGB(150, 50, 255),

			[Symbols.LinkGet("hello world")] = function(thisObject: Frame, selectionObject: Frame)
				thisObject.Name = selectionObject.Name
				thisObject.SelectionImageObject = selectionObject
			end,
		},
	},
}
