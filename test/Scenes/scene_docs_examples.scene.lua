---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.GetModules().Scene.Symbols

return {
	Name = "docs",

	{
		TextObject = {
			Text = "Something something...",

			[Symbols.LinkTag] = "text",
			[Symbols.Class] = "TextLabel",
		},

		ChildObject1 = {
			[Symbols.LinkTag] = "child",
		},

		ChildObject2 = {
			[Symbols.LinkTag] = "child",
		},

		ChildObject3 = {
			[Symbols.LinkTag] = "child",
		},

		MyObject = {
			[Symbols.Class] = "TextLabel",
			[Symbols.LinkGet({ "text", "child" })] = function(
				thisObject: TextLabel,
				text: TextLabel,
				childObjects: { Frame }
			)
				thisObject.Text = text.Text

				for _, object in childObjects do
					object.Parent = thisObject
				end
			end,
		},
	},
}
