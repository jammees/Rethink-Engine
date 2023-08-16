--[=[
	Tag

	Gives object the specified `tag(s)` using CollectionService.
	Can be retrieved using CollectionService or
	[Scene.GetFromTag()](#getfromtagtag).

	```lua
	MyObject = {
		[Symbols.Tag] = "Hello world!"
	}
	```

	```lua
	local result1 = CollectionService:GetTagged("Hello world!")[1]
	local result2 = Rethink.Scene.GetFromTag("Hello world!")[1]

	print(result1 == result2) --> true
	```

	Results in the same object being returned. However, one key
	difference between CollectionService and GetFromTag
	is that GetFromTag returns the Rigidbody class whilst CollectionService
	would have just returned the gui instance (e.g. Frame) itself.

	@since 0.6.0
]=]

local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.string(symbol.SymbolData.Attached))

	local visualObject = Utility.GetVisualObject(object)

	if typeof(symbol.SymbolData.Attached) == "table" then
		for _, tag in symbol.SymbolData.Attached do
			CollectionService:AddTag(visualObject, tag)
		end

		object.SymbolJanitor:Add(function()
			for _, tag in symbol.SymbolData.Attached do
				CollectionService:RemoveTag(visualObject, tag)
			end
		end, nil, Utility.CreateUUID(object))

		return
	end

	CollectionService:AddTag(visualObject, symbol.SymbolData.Attached)

	object.SymbolJanitor:Add(function()
		CollectionService:RemoveTag(visualObject, symbol.SymbolData.Attached)
	end, nil, Utility.CreateUUID(object))
end
