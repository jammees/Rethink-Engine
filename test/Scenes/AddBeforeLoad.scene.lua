---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local RethinkModules = Rethink.GetModules()
local Symbols = RethinkModules.Scene.Symbols

---@module src.Library.ObjectPool-v2
local ObjectPool = RethinkModules.Template.FetchGlobal("__Rethink_Pool")

local myObject = ObjectPool:Get("TextButton")
myObject.Size = UDim2.fromOffset(100, 100)
myObject.Position = UDim2.fromScale(0.5, 0.5)
myObject.AnchorPoint = Vector2.new(0.5, 0.5)
myObject.Parent = RethinkModules.Ui.Viewport

RethinkModules.Scene.Add(myObject, {
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

warn("Test Tag symbol(Hello world!):", RethinkModules.Scene.GetFromTag("Hello world!"))
warn("Test Tag symbol(world! Hello):", RethinkModules.Scene.GetFromTag("world! Hello"))

return { Name = "AddBeforeLoad" }
