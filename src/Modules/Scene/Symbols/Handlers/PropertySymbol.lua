--[=[
	Property

	Adds properties and symbols to object. Mainly used in
	containers.

	```lua
	MyContainer = {
		[Symbols.Property] = {
			Name = "Hello world!"
		},

		MyObject = {
			Name = "Something totally different!"
		}
	}
	```

	From the example above, it is a normal behaviour that MyObject's name
	property was applied instead of the property symbol's. The reason is the
	Compiler always prioritizes objects more than containers.

	@since 0.6.0
]=]

local Types = require(script.Parent.Parent.Parent.Types)
local Promise = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.Promise)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.table(symbol.SymbolData.Attached))

	local visualObject = Utility.GetVisualObject(object)

	for propertyName, propertyValue in symbol.SymbolData.Attached do
		if Utility.IsSymbol(propertyName) then
			continue
		end

		Promise.try(function()
			visualObject[propertyName] = propertyValue
		end):catch(Log.Warn)
	end
end
