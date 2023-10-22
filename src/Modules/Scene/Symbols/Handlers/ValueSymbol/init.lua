local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)
local SceneObject = require(script.Parent.Parent.Parent.SceneObject)
local Value = require(script.Value)

return function(object: SceneObject.SceneObject, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.string(symbol.SymbolData.Symbol))

	if not t.table(object.Symbols.Values) then
		object.Symbols.Values = {}
	end

	if object.Symbols.Values[symbol.SymbolData.Symbol] then
		return Log.Warn(`{symbol.SymbolData.Symbol} with value {symbol.SymbolData.Attached} already added to object!`)
	end

	local ValueClass = Value.new(symbol.SymbolData.Attached)
	object.Symbols.Values[symbol.SymbolData.Symbol] = ValueClass
	object.Janitor:Add(ValueClass)
end
