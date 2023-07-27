local CollectionService = game:GetService("CollectionService")
local HTTPService = game:GetService("HttpService")

local Rigidbody = require(script.Parent.Parent.Parent.Physics.Physics.RigidBody)
local Types = require(script.Parent.Parent.Types)

local function IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name ~= nil then
		return true
	end

	return false
end

local function IsRigidbody(object: any): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == Rigidbody
end

local function CreateUUID(object: Types.ObjectReference)
	local uuid = HTTPService:GenerateGUID(false)

	if not object.Symbols.IDs then
		object.Symbols.IDs = {}
	end

	object.Symbols.IDs[#object.Symbols.IDs + 1] = uuid

	return uuid
end

return {
	-- 0 : default
	-- 1 : function
	TypeLookup = {
		Property = 0,
		Type = 0,
		Tag = 0,
		Rigidbody = 0,
		Event = 1,
		ShouldFlush = 0,
	},

	SymbolHandlers = {
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
		Event = function(object: Types.ObjectReference, symbol: Types.Symbol)
			local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

			object.SymbolJanitor:Add(
				visualObject[symbol.SymbolData.Symbol]:Connect(function()
					symbol.SymbolData.Attached(object.Object)
				end),
				nil,
				CreateUUID(object)
			)

			object.SymbolJanitor:Add(function()
				print("Event symbol cleaned up!")
			end, nil, CreateUUID(object))
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
		Tag = function(object: Types.ObjectReference, symbol: Types.Symbol)
			local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

			if typeof(symbol.SymbolData.Attached) == "table" then
				for _, tag in symbol.SymbolData.Attached do
					CollectionService:AddTag(visualObject, tag)
				end

				object.SymbolJanitor:Add(function()
					for _, tag in symbol.SymbolData.Attached do
						CollectionService:RemoveTag(visualObject, tag)
					end
				end, nil, CreateUUID(object))
			else
				CollectionService:AddTag(visualObject, symbol.SymbolData.Attached)

				object.SymbolJanitor:Add(function()
					CollectionService:RemoveTag(visualObject, symbol.SymbolData.Attached)
				end, nil, CreateUUID(object))
			end

			object.SymbolJanitor:Add(function()
				print("Tag symbol cleaned up!")
			end, nil, CreateUUID(object))
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
		Property = function(object: Types.ObjectReference, symbol: Types.Symbol)
			local visualObject = IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object

			for propertyName, propertyValue in symbol.SymbolData.Attached do
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
		ShouldFlush = function(object: Types.ObjectReference, symbol: Types.Symbol)
			object.Symbols.ShouldFlush = symbol.SymbolData.Attached
		end,
	},
}
