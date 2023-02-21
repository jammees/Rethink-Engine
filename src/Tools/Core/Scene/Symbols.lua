type Rigidbody = { [string]: any }

type AvailableSymbols = {
	Property: any,
	Type: any,
	Tag: any,
	Rigidbody: any,
	Event: (propertyName: string) -> Instance | Rigidbody,
	ShouldFlush: any,
}

-- 0 : default
-- 1 : function
local AVAILABLE_SYMBOLS = {
	Property = 0,
	Type = 0,
	Tag = 0,
	Rigidbody = 0,
	Event = 1,
	ShouldFlush = 0,
}

local HttpService = game:GetService("HttpService")
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
		__identifier = HttpService:GenerateGUID(false),
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
	--[=[
		Event

		A symbol used to run code when the specified event gets fired.

		```lua
		-- Scene data
		MyObject = {
			[Symbols.Event("MouseButton1Click")] = function()
				print("MyObject clicked!")
			end
		}
		```
	]=]
	Event = function(object: Types.SceneObject, symbol: Types.Symbol)
		local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

		object.ObjectJanitor:Add(visualObject[symbol.SymbolData.Symbol]:Connect(function()
			symbol.SymbolData.Attached(object.Object)
		end))
	end,

	--[=[
		Tag

		A symbol used to attach a tag to the given UI element, that can
		be collected with `CollectionService`.

		For rigidbodies `Scene.GetBodyFromTag` is recommended.

		```lua
		-- Scene data
		MyObject = {
			[Symbols.Tag] = "Hello world!"
		}

		-- If it's not a rigidbody:
		-- This will print the first object that is tagged with Hello world!
		game:GetService("CollectionService"):GetTagged("Hello world!")[1]

		-- If it's a rigidbody:
		-- This will print all of the rigidbodies that are tagged with `Hello world!`.
		print(Rethink.Scene.GetBodyFromTag("Hello world!"))
		```
	]=]
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

	--[=[
		Property

		A symbol used to apply properties to an object.

		```lua
		-- Scene data
		MyObject = {
			[Symbols.Property] = {
				BackgroundColor3 =  Color3.fromRGB(36, 175, 180)
			}
		}
		```

		In this example, MyObject's background will become blue instead
		of the default white.
	]=]
	Property = function(object: Types.SceneObject, symbol: Types.Symbol)
		local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

		for propertyName, propertyValue in pairs(symbol.SymbolData.Attached) do
			if IsSymbol(propertyName) == true or typeof(visualObject[propertyName]) == "nil" then
				continue
			end

			visualObject[propertyName] = propertyValue
		end
	end,

	--[=[
		ShouldFlush

		A symbol used to prevent `Scene` from deleting the object(s).
		
		```lua
		-- Scene data
		MyObject = {
			[Symbols.ShouldFlush] = false
		}
		```
		
		However if it is required to clear out everything, then when calling `Scene.Flush()`
		include a `true` argument:

		```lua
		-- This will result in Scene ignoring the ShouldFlush symbol and it's
		-- value
		Scene.Flush(true)
		```
	]=]
	ShouldFlush = function(object: Types.SceneObject, symbol: Types.Symbol)
		object.ShouldFlush = symbol.SymbolData.Attached
	end,
}

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

function Symbols.AttachToInstance(object: Types.SceneObject, symbols: { [string]: { [number]: Types.Symbol } })
	-- There is no need to check if it exists in the AttachableSymbols,
	-- because it already loops over this table and checks for each of the symbols
	for symbolName: string, collectedSymbols: { [number]: Types.Symbol } in pairs(symbols) do
		for _, symbol: Types.Symbol in ipairs(collectedSymbols) do
			local symbolProcessor = Symbols.AttachableSymbols[symbolName]

			-- If it is not an attachable symbol just skip it and move to the next one
			-- no need to notify the user of it being skipped, because it is very less likely
			-- for someone to use a custom symbol outside of the `Symbols` module
			if symbolProcessor == nil then
				continue
			end

			Symbols.AttachableSymbols[symbolName](object, symbol)
		end
	end
end

return Symbols
