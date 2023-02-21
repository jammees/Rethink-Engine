local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.Scene.Symbols

return {
	Name = "Test",

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
					object.ImageColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
				end,
				[Symbols.ShouldFlush] = false,
			},

			HelloWorld = {
				Class = "ImageLabel",
				AnchorPoint = Vector2.new(0.4, 0.5),
				Position = UDim2.fromScale(0.4, 0.5),
				Size = UDim2.fromOffset(100, 100),

				[Symbols.Tag] = "AnimationTag",
				[Symbols.ShouldFlush] = false,
			},

			Empty = {},
		},
	},

	Rigidbodies = {
		[Symbols.Type] = "Rigidbody",
		[Symbols.Property] = {
			Class = "ImageButton",
			BackgroundColor3 = Color3.fromRGB(50, 236, 33),

			[Symbols.Tag] = "UniversalTag",
			[Symbols.Rigidbody] = {
				KeepInCanvas = false,
				Collidable = true,
			},
		},

		My_group = {
			RigidBox = {
				-- Class = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.8, 0.5),
				BackgroundColor3 = Color3.fromRGB(16, 161, 245),

				Size = UDim2.fromOffset(101, 101),

				[Symbols.Tag] = "MyRigidbody",
				[Symbols.Event("MouseButton1Click")] = function(object)
					object:Destroy()
				end,
			},

			Ground = {
				Class = "Frame",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromOffset(1500, 50),
				BackgroundColor3 = Color3.fromRGB(126, 126, 126),
				[Symbols.Rigidbody] = {
					Anchored = true,
				},
				--[Symbols.ShouldFlush] = false,
			},
		},
	},
}
