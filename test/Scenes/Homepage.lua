local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.Scene.Symbols

Rethink.Ui.RenderFrame.BackgroundColor3 = Color3.fromRGB(37, 37, 37)

return {
	Name = "Homepage",

	{
		--[Symbols.Type] = "UiBase",
		{
			Logo = {
				Class = "ImageLabel",

				Size = UDim2.fromOffset(250, 50),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://9799761830",
				ZIndex = 1,
			},

			Container = {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			},
		},
	},
}
