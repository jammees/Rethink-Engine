---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "Test",

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
			Image = "rbxassetid://30115084",

			[Symbols.Tag] = "Box",
			[Symbols.Permanent] = true,
			[Symbols.testSymbol] = true,

			[Symbols.Event("MouseButton1Click")] = function(thisObject: ImageButton)
				print("Box has been clicked!")
				thisObject.ImageColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
			end,

			[Symbols.Event("MouseButton2Click")] = function(thisObject: ImageButton)
				Scene.Cleanup(thisObject)
			end,
		},

		HelloWorld = {
			AnchorPoint = Vector2.new(0.4, 0.5),
			Position = UDim2.fromScale(0.4, 0.5),
			Size = UDim2.fromOffset(100, 100),

			[Symbols.Class] = "ImageButton",
			[Symbols.Tag] = "AnimationTag",
			[Symbols.Permanent] = true,
		},

		Empty = {},
	},

	Rigidbodies = {
		[Symbols.Type] = "Rigidbody",
		[Symbols.Property] = {
			BackgroundColor3 = Color3.fromRGB(50, 236, 33),

			[Symbols.Class] = "ImageButton",
			[Symbols.Tag] = "UniversalTag",
			[Symbols.Rigidbody] = {
				KeepInCanvas = false,
				Collidable = true,
			},
		},

		RigidBox = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.8, 0.5),
			BackgroundColor3 = Color3.fromRGB(16, 161, 245),

			Size = UDim2.fromOffset(101, 101),

			[Symbols.Tag] = "MyRigidbody",
			[Symbols.Event("MouseButton1Click")] = function(thisObject: ImageButton)
				Scene.Cleanup(thisObject)
			end,
		},

		Ground = {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -50),
			Size = UDim2.fromOffset(1500, 50),
			BackgroundColor3 = Color3.fromRGB(126, 126, 126),

			[Symbols.Class] = "Frame",
			[Symbols.Rigidbody] = {
				Anchored = true,
			},
		},
	},
}
