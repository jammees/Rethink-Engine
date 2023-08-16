--[=[
	Permanent

	Tells Scene if object should get flushed, if value is set to true.
	Symbol is ignored if ignorePermanent argument is set to
	true in `Scene.Flush()`.

	```lua
	MyObject = {
		[Symbols.Permanent] = true
	}
	```

	```lua
	Scene.Flush(false)
	```

	From the example above, it can be observed that MyObject
	has not been flushed, since Permanent was set to true
	and ignorePermanent was set to false. Resulting in the object 
	staying in the scene. Leaving ignorePermanent as nil works the same
	way!

	@since 0.6.2
]=]

local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.boolean(symbol.SymbolData.Attached))

	object.Symbols.Permanent = symbol.SymbolData.Attached
end
