local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "devforum_load_example.scene",

	Interactibles = {
		[Symbols.Type] = "UIBase",
		[Symbols.Property] = {
			BackgroundColor3 = Color3.fromRGB(255, 125, 25),
			Transparency = 0.5,
			[Symbols.Tag] = "Interactibles",
			[Symbols.Tag] = "UniversalTag",
			[Symbols.Class] = "ImageButton",
		},

		Box = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(250, 250),

			[Symbols.Tag] = "Box",
			[Symbols.Permanent] = true,

			[Symbols.Event("MouseButton1Click")] = function(thisObject: ImageButton)
				thisObject.BackgroundColor3 =
					Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
			end,

			[Symbols.Event("MouseButton2Click")] = function(thisObject: ImageButton)
				Scene.Cleanup(thisObject)
			end,
		},
	},
}
