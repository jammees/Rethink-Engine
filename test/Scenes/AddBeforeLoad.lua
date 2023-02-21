local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Symbols = Rethink.Scene.Symbols

local ObjectPool = Rethink.Pool

local myObject = ObjectPool:Get("TextButton")
myObject.Size = UDim2.fromOffset(100, 100)
myObject.Position = UDim2.fromScale(0.5, 0.5)
myObject.AnchorPoint = Vector2.new(0.5, 0.5)
myObject.Parent = Rethink.Ui.Viewport

Rethink.Scene.Add(myObject, {
	-- Test if mutliple Property symbols can be assigned
	[Symbols.Property] = {
		TextColor3 = Color3.fromRGB(145, 42, 14),
	},
	[Symbols.Property] = {
		BackgroundColor3 = Color3.fromRGB(34, 145, 14),
	},

	[Symbols.Tag] = "Hello world!",
	[Symbols.Tag] = "world! Hello",

	[Symbols.Event("MouseButton1Click")] = function()
		print("MouseButton1Click")
	end,
	[Symbols.Event("MouseButton2Click")] = function()
		print("MouseButton2Click")
	end,
})

warn("Test Tag symbol(Hello world!):", game:GetService("CollectionService"):GetTagged("Hello world!")[1])
warn("Test Tag symbol(world! Hello):", game:GetService("CollectionService"):GetTagged("world! Hello")[1])

return { Name = "AddBeforeLoad" }
