local Type = { Type = "Symbol", Name = "Type" }
local Property = { Type = "Symbol", Name = "Property" }
local Tag = { Type = "Symbol", Name = "Tag" }
local Rigidbody = { Type = "Symbol", Name = "Rigidbody" }

return {
	{ Name = "Test" },
	{
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
					Size = UDim2.fromOffset(100, 100),
					Image = "rbxassetid://30115084",

					[Tag] = "Box",
				},

				HelloWorld = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.4, 0.5),
					Size = UDim2.fromOffset(100, 100),
				},

				Empty = {},
			},
		},

		Rigidbodies = {
			[Type] = "Rigidbody",
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
						Anchored = true,
					},
				},

				Box = {
					-- Class = "ImageLabel",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.8, 0.5),
					BackgroundColor3 = Color3.fromRGB(222, 245, 16),

					[Tag] = "MyRigidbody",
					[Rigidbody] = {
						KeepInCanvas = true,
					},
				},
			},
		},
	},
}
