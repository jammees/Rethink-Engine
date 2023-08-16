--[=[
	LinkTag

	Adds a "tag" to object, which can be fetched using the
	[LinkGet](#linkget) symbol.

	```lua
	MyObject = {
		[Symbols.LinkTag] = "Hello world!"
	}
	```

	@since 0.6.2
]=]

local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.string(symbol.SymbolData.Attached))

	if not t.table(object.Symbols.LinkIDs) then
		object.Symbols.LinkIDs = {}
	end

	if object.Symbols.LinkIDs[symbol.SymbolData.Attached] then
		return Log.Warn(`{symbol.SymbolData.Attached} already added to object!`)
	end

	table.insert(object.Symbols.LinkIDs, symbol.SymbolData.Attached)
end
