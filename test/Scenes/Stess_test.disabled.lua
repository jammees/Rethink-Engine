local AMOUNT_OF_OBJCECTS = 2000

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local Type = Rethink.Scene.Symbols.Type
local Property = Rethink.Scene.Symbols.Property
local Tag = Rethink.Scene.Symbols.Tag

local function createObjects(amount: number)
	local groupTable = {
		[Property] = {
			Transparency = 0.5,
			[Tag] = "Interactibles",
		},
	}

	for _ = amount, 1, -1 do
		table.insert(groupTable, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(100, 100),
			Image = "rbxassetid://30115084",

			[Tag] = "Box",
		})
	end

	return groupTable
end

return {
	{ Name = "Stress test" },
	{
		Interactibles = {
			[Type] = "UiBase",
			[Property] = {
				Class = "ImageButton",
				BackgroundColor3 = Color3.fromRGB(255, 125, 25),

				[Tag] = "UniversalTag",
			},

			createObjects(AMOUNT_OF_OBJCECTS / 2),
		},

		Rigidbodies = {
			[Type] = "Rigidbody",
			[Property] = {
				Class = "ImageButton",
				BackgroundColor3 = Color3.fromRGB(25, 190, 255),

				[Tag] = "UniversalTag",
			},

			createObjects(AMOUNT_OF_OBJCECTS / 2),
		},
	},
}
