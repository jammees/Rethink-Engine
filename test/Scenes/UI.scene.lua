---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "UI",

	{
		[Symbols.Type] = "UIBase",
		[Symbols.Property] = {
			Parent = Rethink.GetModules().Ui.Ui,
		},

		Text = {
			Text = "Hello world!",
			BackgroundTransparency = 1,
			TextSize = 21,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromScale(0.3, 0.5),

			[Symbols.Class] = "TextLabel",
			[Symbols.LinkTag] = "Text",
		},

		TextField = {
			BackgroundTransparency = 1,
			TextSize = 21,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromScale(0.3, 0.6),
			PlaceholderText = "Input text here",

			[Symbols.Class] = "TextBox",
			[Symbols.LinkTag] = "Field",
		},

		Button = {
			BackgroundTransparency = 1,
			TextSize = 21,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromScale(0.5, 0.6),
			Text = "Confirm",

			[Symbols.Class] = "TextButton",
			[Symbols.LinkGet({ "Field", "Text" })] = function(thisObject: TextButton, field: TextBox, text: TextLabel)
				local thisRef = Scene.GetSceneObjectFrom(thisObject)
				thisRef.Janitor:Add(thisObject.MouseButton1Click:Connect(function()
					text.Text = field.Text
				end))
			end,
		},
	},
}
