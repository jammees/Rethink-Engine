type AvailableSymbols = {
	Property: any,
	Type: any,
	Tag: any,
	Rigidbody: any,
	Event: any,
}

-- 0 : default
-- 1 : function
local AVAILABLE_SYMBOLS = {
	Property = 0,
	Type = 0,
	Tag = 0,
	Rigidbody = 0,
	Event = 1,
}

local CollectionService = game:GetService("CollectionService")

local Rigidbody = require(script.Parent.Parent.Parent.Environment.Physics.Physics.RigidBody)
local Types = require(script.Parent.Types)

local function IsRigidbody(object: any): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == Rigidbody
end

local function CreateSymbol(symbolName: string, symbolData: any?): Types.Symbol
	return {
		Type = "Symbol",
		Name = symbolName,
		SymbolData = {
			Symbol = symbolData,
			Attached = "Not assigned",
		},

		-- This exists only to make each symbol unique
		__identifier = game:GetService("HttpService"):GenerateGUID(false),
	}
end

local function IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name ~= nil then
		return true
	end

	return false
end

local Symbols = {}

-- New system for handling symbols,
-- previously the problem was that the symbols were created once and because of
-- that lua overwrote symbols that were technically the same.
-- This fixed the problem by creating a symbol if it was called like Symbols.Types.Event
local TypesHandle: AvailableSymbols = setmetatable({}, {
	__index = function(_, symbolName)
		if AVAILABLE_SYMBOLS[symbolName] == nil then
			error("Attempt to index non-existing symbol!", 2)
		end

		-- If it should be a function
		if AVAILABLE_SYMBOLS[symbolName] == 1 then
			return function(property: string)
				return CreateSymbol(symbolName, property)
			end
		end

		return CreateSymbol(symbolName)
	end,
})

Symbols.Types = TypesHandle

--[[
	Attachable symbols are symbols that attach some functionality to an object.
	Such as Tags, Events.
]]
Symbols.AttachableSymbols = {
	Event = function(object: Types.SceneObject, symbol: Types.Symbol)
		local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

		object.ObjectJanitor:Add(visualObject[symbol.SymbolData.Symbol]:Connect(function()
			symbol.SymbolData.Attached(object.Object)
		end))
	end,

	Tag = function(object: Types.SceneObject, symbol: Types.Symbol)
		local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

		if typeof(symbol.SymbolData.Attached) == "table" then
			for _, tag in ipairs(symbol.SymbolData.Attached) do
				CollectionService:AddTag(visualObject, tag)
			end
		else
			CollectionService:AddTag(visualObject, symbol.SymbolData.Attached)
		end
	end,

	-- For some reason the last Property entry gets processed.
	-- Most likely I won't fix this behaviour, because why would you do such thing? (Hopefully not because to try to break everything :) )
	Property = function(object: Types.SceneObject, symbol: Types.Symbol)
		local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

		for propertyName, propertyValue in pairs(symbol.SymbolData.Attached) do
			if IsSymbol(propertyName) == true or typeof(visualObject[propertyName]) == "nil" then
				continue
			end

			visualObject[propertyName] = propertyValue
		end
	end,
}

-- If callback is not provided, it will return the symbol and it's value
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

function Symbols.AttachToInstance(object: Types.SceneObject, symbols: { [string]: { [number]: Types.Symbol } })
	-- There is no need to check if it exists in the AttachableSymbols,
	-- because it already loops over this table and checks for each of the symbols
	for symbolName: string, collectedSymbols: { [number]: Types.Symbol } in pairs(symbols) do
		for _, symbol: Types.Symbol in ipairs(collectedSymbols) do
			Symbols.AttachableSymbols[symbolName](object, symbol)
		end
	end
end

return Symbols
