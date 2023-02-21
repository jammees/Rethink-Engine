local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local Type = Rethink.Scene.Symbols.Type
local Property = Rethink.Scene.Symbols.Property
local Tag = Rethink.Scene.Symbols.Tag
local Rigidbody = Rethink.Scene.Symbols.Rigidbody

return {
	Name = "Alias scene test",
	Interactibles = {
		[Type] = "Layer",
		[Property] = {
			Class = "ImageButton",
			BackgroundColor3 = Color3.fromRGB(255, 125, 25),

			[Tag] = "UniversalTag",
		},

		My_group = {
			[Property] = {
				Transparency = 0.5,
				[Tag] = "Interactibles",
			},

			Box = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(250, 250),
				Image = "rbxassetid://30115084",

				[Tag] = "Box",
			},

			HelloWorld = {
				Class = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.4, 0.5),
				Size = UDim2.fromOffset(50, 100),

				[Tag] = "AnimationTag",
			},

			Empty = {},
		},
	},

	TestStatic = {
		[Type] = "Static",

		Group = {
			Empty = {},
		},
	},

	Rigidbodies = {
		[Type] = "Dynamic",
		[Property] = {
			Class = "ImageButton",
			BackgroundColor3 = Color3.fromRGB(25, 190, 255),

			[Tag] = "UniversalTag",
			[Rigidbody] = {
				Anchored = false,
			},
		},

		My_group = {
			[Property] = {
				[Rigidbody] = {
					Anchored = false,
				},
			},

			RigidBox = {
				-- Class = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.8, 0.5),
				BackgroundColor3 = Color3.fromRGB(222, 245, 16),

				Size = UDim2.fromOffset(101, 101),

				[Tag] = "MyRigidbody",
				[Rigidbody] = {
					KeepInCanvas = true,
				},
			},
		},
	},
}
