export type Symbol = {
	Type: string,
	Name: string,
	Data: { any }?
}

type PackedSymbol = {
	Symbol: Symbol,
	Value: any
}

local IGNORED_SYMBOLS = {
	"Property",
	"Rigidbody",
}

local package = script.Parent.Parent.Parent

local Rigidbody = require(package.Environment.Physics.Physics.RigidBody)

local function CreateSymbol(symbolName: string, additionalData: any): Symbol
	return {
		Type = "Symbol",
		Name = symbolName,
		Data = additionalData
	}
end

local function IsRigidbody(object: any): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == Rigidbody
end

local Symbols = {}

Symbols.Types = {
	Property = CreateSymbol("Property"),
	Type = CreateSymbol("Type"),
	Children = CreateSymbol("Children"), -- UNUSED: Will get implemented hopefully in 1.1.0
	Tag = CreateSymbol("Tag"),
	Rigidbody = CreateSymbol("Rigidbody"),
	Event = function(property: string)
		return CreateSymbol("Event", property)
	end
}

Symbols.AttachableSymbols = {
	Event = function(object: Instance | { any }, visualObject: Instance, packedSymbol: PackedSymbol)
		visualObject[packedSymbol.Symbol.Data]:Connect(function()
			packedSymbol.Value(object)
		end)
	end
}

-- If callback is not provided, it will return the symbol and it's value
function Symbols.FindSymbol(array: { any }, targetSymbol: string, callback: ( any ) -> ( any )?)
	if typeof(array) ~= "table" then
		return
	end

	for index, value in pairs(array) do
		if typeof(index) == "table" and index.Type == "Symbol" then
			if index.Name == targetSymbol then
				if typeof(callback) == "function" then
					return callback(value)
				end

				return index, value
			end
		end
	end

	return nil
end

-- Attaches symbols to an object
-- This is currently a hard coded implementation
-- This means that if you would like to add a new symbol that can be attached
-- You have to expand the if stateement to account for that
function Symbols.AttachToInstance(object, packedSymbols: { [number]: PackedSymbol })
	for symbolName: string, packedSymbol: PackedSymbol in pairs(packedSymbols) do
		local visualObject = IsRigidbody(object) and object:getFrame() or object

		if Symbols.AttachableSymbols[symbolName] then
			Symbols.AttachableSymbols[symbolName](object, visualObject, packedSymbol)
		end
	end
end

function Symbols.IndexIsValid(index: Symbol, value: string, targetValue: string)
	if index.Type == "Symbol" then
		if table.find(IGNORED_SYMBOLS, index.Name) then
			return false
		end

		if string.lower(value) == string.lower(targetValue) then
			return true
		end
	end

	return false
end

return Symbols
