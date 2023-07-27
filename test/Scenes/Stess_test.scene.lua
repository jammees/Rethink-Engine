local OBJECT_NUMBER = 2000

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.GetModules().Scene.Symbols

local viewportSize = workspace.CurrentCamera.ViewportSize

local function createObjects(amount: number)
	local groupTable = {}

	for _ = amount, 1, -1 do
		table.insert(groupTable, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(math.random(0, viewportSize.X), math.random(0, viewportSize.Y)),
			Size = UDim2.fromOffset(100, 100),
			Image = "rbxassetid://30115084",

			[Symbols.Tag] = "Box",
			[Symbols.Event("MouseMoved")] = function() end,
		})
	end

	return table.unpack(groupTable)
end

return {
	Name = "Stress test",

	Interactibles = {
		[Symbols.Type] = "UiBase",
		[Symbols.Property] = {
			Class = "ImageButton",
			BackgroundColor3 = Color3.fromRGB(255, 125, 25),

			[Symbols.Tag] = "UniversalTag",
		},

		createObjects(OBJECT_NUMBER / 2),
	},

	Rigidbodies = {
		[Symbols.Type] = "Rigidbody",
		[Symbols.Property] = {
			Class = "ImageButton",
			BackgroundColor3 = Color3.fromRGB(25, 190, 255),

			[Symbols.Tag] = "UniversalTag",
			[Symbols.Rigidbody] = {
				Collidable = true,
				Anchored = false,
				KeepInCanvas = false,
				CanRotate = false,
				LifeSpan = 5,
				Gravity = Vector2.new(1, 1),
				Friction = 1,
				AirFriction = 1,
				Mass = 5,
			},
		},

		createObjects(OBJECT_NUMBER / 2),
	},
}
