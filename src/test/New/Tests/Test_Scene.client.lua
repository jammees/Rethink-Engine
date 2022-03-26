local rethinkEngine = require(game:GetService("ReplicatedStorage").RethinkEngine)
local scene = rethinkEngine.Scene

local testScene = {
	Data = {
		Name = "myTestMap",
	},
	Layers = {
		["1"] = {
			MyBlueObject = {
				BackgroundColor3 = Color3.fromRGB(7, 98, 151),
				Position = UDim2.fromScale(0.5, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(75, 75),
			},
		},
		["2"] = {
			MyRedObject = {
				BackgroundColor3 = Color3.fromRGB(151, 24, 7),
				Position = UDim2.fromScale(0.45, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(75, 75),
			},
		},
	},
	Rigidbodies = {
		Static = {
			Ground = {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.fromScale(0.5, 1),
				AnchorPoint = Vector2.new(0.5, 1),
				Size = UDim2.new(1, 0, 0, 45),
			},

			UpperGround = {
				BackgroundColor3 = Color3.fromRGB(159, 159, 159),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(0.3, 0.2),

				Collidable = false,
			},

			Coin = {
				Class = "ImageLabel",
				Size = UDim2.fromOffset(50, 50),
				Position = UDim2.fromScale(0.5, 0.25),
				Image = "rbxassetid://7058514483",
				AnchorPoint = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				Collidable = false,
				["Tag"] = "coin",
			},
		},
		Dynamic = {
			Box1 = {
				BackgroundColor3 = Color3.fromRGB(234, 123, 231),
				Position = UDim2.fromOffset(50, 60),
				Size = UDim2.fromOffset(100, 100),

				["Tags"] = { "box1" },
			},
			Box2 = {
				BackgroundColor3 = Color3.fromRGB(27, 189, 48),
				Position = UDim2.fromOffset(707, 60),
				Size = UDim2.fromOffset(100, 100),

				["Tags"] = { "box2" },
			},

			PlayerA = {
				BackgroundColor3 = Color3.fromRGB(33, 137, 255),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(850, 150),
				Size = UDim2.fromOffset(75, 75),

				["Tag"] = "playerA",
			},
		},
	},
}

local sceneData = {
	Structure = {
		Layers = {
			_Config = {
				Type = "Layer",
				UniversalProperty = {
					BackgroundColor3 = Color3.fromRGB(12, 206, 77),
				},
			},

			["My Epic Group:-1"] = {
				_UniversalProperty = {
					BackgroundColor3 = Color3.fromRGB(207, 45, 45),
				},
				MyRedObject = {
					BackgroundColor3 = Color3.fromRGB(27, 39, 209),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(75, 75),
				},
			},
			["My another epic group:2"] = {
				MyRedButOverridedGreenObject = {
					BackgroundColor3 = Color3.fromRGB(209, 27, 133),
					Position = UDim2.fromScale(0.5, 0.4),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(75, 75),
				},
			},
		},
		Rigidbodies = {
			_Config = {
				Type = "Rigidbody",
				UniversalProperty = {
					BackgroundColor3 = Color3.fromRGB(9, 113, 161),
					Anchored = true,
				},
			},

			["A rigidbody group"] = {
				Ground = {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Position = UDim2.fromScale(0.5, 1),
					AnchorPoint = Vector2.new(0.5, 1),
					Size = UDim2.new(1, 0, 0, 45),
				},
			},
			["Coins"] = {
				_UniversalProperty = {
					Tag = "coin",
					ImageColor3 = Color3.fromRGB(255, 0, 0),
				},
				Coin = {
					Class = "ImageLabel",
					Size = UDim2.fromOffset(50, 50),
					Position = UDim2.fromScale(0.5, 0.25),
					Image = "rbxassetid://7058514483",
					AnchorPoint = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
				},
				Coin2 = {
					Class = "ImageLabel",
					Size = UDim2.fromOffset(50, 50),
					Position = UDim2.fromScale(0.25, 0.25),
					Image = "rbxassetid://7058514483",
					AnchorPoint = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
				},
			},
		},
	},
}

scene:Load(sceneData)
