local Types = require(script.Parent.Types)

local HttpService = game:GetService("HttpService")

local Promise = require(script.Parent.Parent.Parent.Vendors.Promise)
local SymbolConfig = require(script.SymbolConfig)
local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)

local function CreateSymbol(symbolName: string, symbolData: any?): Types.Symbol
	return {
		Type = "Symbol",
		Name = symbolName,
		SymbolData = {
			Symbol = symbolData,
			Attached = "Not assigned",
		},

		__identifier = HttpService:GenerateGUID(false),
	}
end

local Symbols = {}

-- New system for handling symbols,
-- previously the problem was that the symbols were created once and because of
-- that lua overwrote symbols that were technically the same.
-- This fixed the problem by creating a symbol if it was called like Symbols.Types.Event

local TypesHandle: Types.AvailableSymbols = setmetatable({}, {
	__index = function(_, symbolName)
		if SymbolConfig.TypeLookup[symbolName] == nil then
			Log.Error(`Attempt to index non-existent symbol with {tostring(symbolName)}!`)
		end

		-- If it should be a function
		if SymbolConfig.TypeLookup[symbolName] == 1 then
			return function(property: string)
				return CreateSymbol(symbolName, property)
			end
		end

		return CreateSymbol(symbolName)
	end,

	__newindex = function(_, index)
		Log.Error(`Attempt to create new index({tostring(index)}) in TypesHandle!`)
	end,
})

Symbols.Types = TypesHandle

-- If callback is not provided, it will return the symbol and it's value
-- Does not account for multiple symbols being the same type in the same table.
-- Won't fix most likely, since why would you do that?
function Symbols.FindSymbol(array: { any }, targetSymbol: string)
	if typeof(array) ~= "table" then
		return
	end

	for index, value in pairs(array) do
		if typeof(index) == "table" and index.Type == "Symbol" then
			if index.Name == targetSymbol then
				return index, value
			end
		end
	end

	return nil
end

function Symbols.AttachToInstance(object: Types.ObjectReference, symbols: { [string]: { [number]: Types.Symbol } })
	for symbolName: string, collectedSymbols: { [number]: Types.Symbol } in pairs(symbols) do
		for _, symbol: Types.Symbol in ipairs(collectedSymbols) do
			local symbolProcessor = SymbolConfig.SymbolHandlers[symbolName]

			-- If it is not an attachable symbol just skip it and move to the next one
			if symbolProcessor == nil then
				continue
			end

			Promise.try(function()
				symbolProcessor(object, symbol)
			end):catch(warn)
		end
	end
end

function Symbols.RegisterCustomSymbol(
	name: string,
	returnKind: number,
	controller: (object: Types.ObjectReference, symbol: Types.Symbol) -> ()
)
	if SymbolConfig[name] then
		Log.Error(`Attempted to register custom symbol named "{name}": Already exists!`)
	end

	SymbolConfig.TypeLookup[name] = returnKind
	SymbolConfig.SymbolHandlers[name] = controller
end

function Symbols.IsSymbol(tableIndex: any): boolean
	return t.table(tableIndex) and t.string(tableIndex.Name)
end

return Symbols
