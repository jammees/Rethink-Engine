--[=[
	Event

	Listens to the given event, firing the provided callback
	function with the object.

	```lua
	MyObject = {
		[Symbols.Event("MouseEnter")] = function(thisObject)
			print("Mouse entered", thisObject.Name)
		end,
	}
	```

	@since 0.6.0
]=]

local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.string(symbol.SymbolData.Symbol))
	Log.TAssert(t.callback(symbol.SymbolData.Attached))

	local visualObject = Utility.GetVisualObject(object)

	object.SymbolJanitor:Add(
		visualObject[symbol.SymbolData.Symbol]:Connect(function()
			symbol.SymbolData.Attached(object.Object)
		end),
		nil,
		Utility.CreateUUID(object)
	)
end
