local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.Scene.Symbols

return {
	{ Name = "Test" },
	{
		Interactibles = {
			[Symbols.Type] = "UiBase",
			[Symbols.Property] = {
				Class = "ImageButton",
				BackgroundColor3 = Color3.fromRGB(255, 125, 25),

				[Symbols.Tag] = "UniversalTag",
			},

			My_group = {
				[Symbols.Property] = {
					Transparency = 0.5,
					[Symbols.Tag] = "Interactibles",
				},

				Box = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(250, 250),
					Image = "rbxassetid://30115084",

					[Symbols.Tag] = "Box",
					[Symbols.Event("MouseButton1Click")] = function(object: ImageButton)
						print("Box has been clicked!")
						object.ImageColor3 =
							Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
					end,
				},

				HelloWorld = {
					Class = "ImageLabel",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.4, 0.5),
					Size = UDim2.fromOffset(50, 100),

					[Symbols.Tag] = "AnimationTag",
				},

				Empty = {},
			},
		},

		Rigidbodies = {
			[Symbols.Type] = "Rigidbody",
			[Symbols.Property] = {
				Class = "ImageButton",
				BackgroundColor3 = Color3.fromRGB(25, 190, 255),

				[Symbols.Tag] = "UniversalTag",
				[Symbols.Rigidbody] = {
					Anchored = false,
				},
			},

			My_group = {
				[Symbols.Property] = {
					[Symbols.Rigidbody] = {
						Anchored = false,
					},
				},

				RigidBox = {
					-- Class = "ImageLabel",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.8, 0.5),
					BackgroundColor3 = Color3.fromRGB(222, 245, 16),

					Size = UDim2.fromOffset(101, 101),

					[Symbols.Tag] = "MyRigidbody",
					[Symbols.Event("MouseButton1Click")] = function(object)
						object:Destroy()
					end,
					[Symbols.Rigidbody] = {
						KeepInCanvas = true,
					},
				},
			},
		},
	},
}
