---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

return {
	Name = "ChildrenSymbol.scene",

	{
		[Symbols.Type] = "UIBase",

		Test = {
			[Symbols.Children] = {
				a = {
					BackgroundColor3 = Color3.fromRGB(150, 50, 42),

					[Symbols.Class] = "TextButton",
					[Symbols.Event("MouseButton1Click")] = function(object)
						object.BackgroundColor3 = Color3.new(math.random() / 1, math.random() / 1, math.random() / 1)
					end,
					[Symbols.Children] = {
						b = {
							BackgroundColor3 = Color3.fromRGB(42, 50, 150),
							Position = UDim2.fromOffset(100, 0),

							[Symbols.Class] = "TextButton",
							[Symbols.Event("MouseButton2Click")] = function(object)
								object.BackgroundColor3 =
									Color3.new(math.random() / 1, math.random() / 1, math.random() / 1)
							end,
						},
					},
				},

				rigid = {
					BackgroundColor3 = Color3.fromRGB(255, 255, 0),

					[Symbols.Class] = "ImageLabel",
					[Symbols.Type] = "Rigidbody",
					[Symbols.Rigidbody] = {
						Mass = 5,
						Collidable = true,
						-- Anchored = true,
					},
					[Symbols.Children] = {
						corner = {
							[Symbols.Class] = "UICorner",
						},
					},
				},
			},
		},
	},
}
