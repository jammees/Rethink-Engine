--[=[
	LinkGet

	Gets all of the objects with the specified tag.
	If the symbol has been applied during loading of the scene,
	the execution will be delayed until [LoadFinished](#events) has been fired
	else, when [ObjectAdded](#events) fires.

	Accepts an array of strings or a string as a parameter. If
	the given link name has more than one object tied to
	it, will return an array of the objects in the `Callback`
	function. Otherwise, the object itself will get returned.

	```lua
	MyObject = {
		[Symbols.LinkTag] = "Hello world!"
	},

	NamedAfterMyobject = {
		Name = "Something totally different!",

		[Symbols.LinkGet({ "Hello world!" })] = function(thisObject, myObject: Frame)
			thisObject.Name = myObject.Name
		end
	}
	```

	From the example above, after the scene has finished loading `NamedAfterMyobject`
	will rename itself from "Something totally different!" to "MyObject".

	@since 0.6.2
	@param Tag `String | { String }`
	@param Callback `(Object, ...) -> ()`
]=]

local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.union(t.table, t.string)(symbol.SymbolData.Symbol))
	Log.TAssert(t.callback(symbol.SymbolData.Attached))

	local Scene = require(script.Parent.Parent.Parent) --> Avoid modules being recursively required

	local function GetLinkedObjects(linkName: string)
		local linkedObjects = {}

		for _, objectReference in Scene.GetObjects() do
			if not objectReference.Symbols.LinkIDs then
				continue
			end

			if not (table.find(objectReference.Symbols.LinkIDs, linkName)) then
				continue
			end

			table.insert(linkedObjects, objectReference.Object)
		end

		if #linkedObjects == 1 then
			return linkedObjects[1]
		end

		return linkedObjects
	end

	local function RunSymbol()
		local linkedObjects = {}

		if t.table(symbol.SymbolData.Symbol) then
			for _, linkName: string in symbol.SymbolData.Symbol do
				table.insert(linkedObjects, GetLinkedObjects(linkName))
			end
		else
			table.insert(linkedObjects, GetLinkedObjects(symbol.SymbolData.Symbol))
		end

		if #linkedObjects == 0 then
			Log.Error(`{symbol.SymbolData.Symbol} failed to locate any object!`)
		end

		symbol.SymbolData.Attached(object.Object, table.unpack(linkedObjects))
	end

	if Scene.State == "Loading" then
		local connection = nil
		connection = Scene.Events.LoadFinished:Connect(function()
			connection:Disconnect()
			RunSymbol()
		end)

		return
	end

	local connection = nil
	connection = Scene.Events.ObjectAdded:Connect(function(addedObject: Types.ObjectReference)
		if not (Scene.GetObjectReference(addedObject) == object) then
			return
		end

		connection:Disconnect()
		RunSymbol()
	end)
end
