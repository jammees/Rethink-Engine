--[[

    Scene

	Scene does not support custom rigidbodies yet.

]]

local Types = require(script.Types)

type CompiledObject = {
	Object: GuiBase2d | Types.Rigidbody,
	Symbols: any,
}

type Tag = { [number]: string } | string?

type SceneConfig = { Name: string }

local CollectionService = game:GetService("CollectionService")
local HTTPService = game:GetService("HttpService")

local RigidBody = require(script.Parent.Nature2D.Physics.RigidBody)
local Template = require(script.Parent.Template)
local DebugStrings = require(script.Parent.Parent.Strings)
local Signal = require(script.Parent.Parent.Vendors.goodsignal)
local Compiler = require(script.Compiler)
local Symbols = require(script.Symbols)
local Janitor = require(script.Parent.Parent.Vendors.Janitor)
local t = require(script.Parent.Parent.Vendors.t)
local Log = require(script.Parent.Parent.Library.Log)

local sceneObjects: { [string]: SceneObject.SceneObject } = {}

local Scene = {}

--[=[
	Symbols __must__ be wrapped with `[ ]`. Reason is
	that without the `[ ]` lua would just treat the index as
	a simple string and not as a table.

	Symbols are an easy way to add additional extra functionality to an
	object. This feature was inspired by Fusion. Rethink allows the creation
	of custom symbols. See: `Scene.RegisterCustomSymbol()`

	@since 0.6.0
	@readonly
]=]
Scene.Symbols = table.freeze(Symbols.Types)

--[=[
	Reports the current state of Scene:

	- Loading
	- Flushing
	- Standby

	@since 0.6.2
	@readonly
]=]
Scene.State = "Standby"

--[=[
	Events are simple ways to run certain behaviour at certain times.

	__List of all available events__

	| Name:                     | Description:
	| ------------------------- | ------------------------------------
	| LoadStarted               | Fires before the scene gets loaded
	| LoadFinished              | Fires after the scene got loaded
	| FlushStarted              | Fires before the scene gets flushed/deleted
	| FlushFinished             | Fires after the scene got flushed/deleted
	| ObjectAdded               | Fires when an object got added to the scene, returns object
	| ObjectRemoved             | Fires when an object got removed from the scene, returns object

	@since 0.5.3
	@readonly
]=]
Scene.Events = table.freeze({
	LoadStarted = Signal.new(),
	LoadFinished = Signal.new(),
	FlushStarted = Signal.new(),
	FlushFinished = Signal.new(),
	ObjectAdded = Signal.new(),
	ObjectRemoved = Signal.new(),
})

--[=[
	Loads in a scene using the sceneData table. A name field must be provided, otherwise
	it will default to "Unnamed scene", which could cause unintended behaviours.
	The compiler does not check if a scene already exists with that name, meaning it will
	overwrite it. It is a good practice to have each container's type defined, even if
	it is supposed to be an `UIBase`! Otherwise, an error will be thrown!

	### Example

	```lua
	return {
		Name = "My scene",

		My_Container = {
			[Type] = "Layer",
			[Property] = {
				Transparency = 0.5
				[Tag] = "Container!"
			}
			
			My_Object = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(100, 100),

				[Tag] = "Object!"
			}
		},
	}
	```

	How a scene module is typically structured:

	| Level  | Name       | Description
	| ------ | ---------- | ------------------------------
	| 0      | Main body  | Defines the `Containers` as well as the `Name`
	| 1      | Containers | Defines the `Type` of the objects and the `Properties` that objects may share
	| 2      | Objects    | Defines object properties and their symbols based on previous `Property` symbols present in `Containers` and the data inside the table itself

	Objects always have higher priority when applying properties.

	@since 0.3.0
	@param sceneData `Dictionary`
	@fires LoadStarted
	@fires LoadFinished
]=]
function Scene.Load(sceneData: { Name: string })
	Log.TAssert(t.table(sceneData))

	if Scene.State == "Loading" then
		return Log.Warn(DebugStrings.Scene.CallBlockedProcessOngoing:format("load", "loading"))
	end

	if Scene.State == "Flushing" then
		return Log.Warn(DebugStrings.Scene.CallBlockedProcessOngoing:format("load", "flushing"))
	end

	Scene.Events.LoadStarted:Fire()

	Scene.State = "Loading"

	sceneData.Name = if sceneData.Name then sceneData.Name else "Unnamed scene"

	Compiler.Compile(sceneData):catch(Log.Warn):await()

	Scene.State = "Standby"

	Scene.Events.LoadFinished:Fire()
end

--[=[
	Internally used by scene when the compiler has finished gathering and building up the
	objects in the scene. Sets up a cleanup method for the object, creates a new entry
	in the sceneObjects array saving an `ObjectReference` table associated with
	the object and calls `Scene.AddSymbols()`.

	```lua
	type ObjectReference = {
		Object: GuiObject | Rigidbody,
		Janitor: Janitor,
		SymbolJanitor: Janitor,
		ID: string,
		Symbols: {
			IDs: { UUID }?,
			Permanent: boolean?,
			LinkIDs: { string }?,
		},
	}
	```

	@since 0.5.3
	@param object `GuiObject | Rigidbody`
	@param symbols `{[Symbol]: any}`
	@fires ObjectAdded
]=]
function Scene.Add(object: GuiBase2d | Types.Rigidbody, symbols: { [Types.Symbol]: any }?)
	Log.TAssert(t.union(t.Instance, t.table)(object))
	Log.TAssert(t.optional(t.table)(symbols))

	local Object = SceneObject.new(object)

	-- Allocate object
	sceneObjects[Object.ID] = Object

	Scene.AddSymbols(object, symbols)

	Scene.Events.ObjectAdded:Fire(object)
end

--[=[
	Attaches symbols to an object. Used by `Scene.Add()`.
	Does not support custom objects, due to symbols need to have the reference to
	the object to access data such as the object's Janitor.

	@since 0.6.0
	@param object `GuiObject | Rigidbody`
	@param symbols `{[Symbol]: Any}`
]=]
function Scene.AddSymbols(object: GuiBase2d | Types.Rigidbody, symbols: { [Types.Symbol]: any }?)
	Log.TAssert(t.union(t.Instance, t.table)(object))
	Log.TAssert(t.optional(t.table)(symbols))

	if symbols == nil then
		return
	end

	local attachedSymbols = {}

	-- Pack symbols
	for symbol, value in pairs(symbols) do
		if typeof(attachedSymbols[symbol.Name]) == "nil" then
			attachedSymbols[symbol.Name] = {}
		end

		symbol.SymbolData.Attached = value

		table.insert(attachedSymbols[symbol.Name], symbol)
	end

	Symbols.AttachToInstance(Scene.GetSceneObjectFrom(object), attachedSymbols)
end

--[=[
	Removes the object from the scene without destroying it nor cleaning up the Janitor.
	If stripSymbols is set to true it will cleanup the symbols.

	@since 0.6.0
	@param object `GuiObject | Rigidbody`
	@param stripSymbols `Boolean`
	@default stripSymbols `False`
	@fires ObjectRemoved
]=]
function Scene.Remove(object: GuiBase2d | Types.Rigidbody, stripSymbols: boolean?)
	Log.TAssert(t.union(t.Instance, t.table)(object))
	Log.TAssert(t.optional(t.boolean)(stripSymbols))

	local Object = Scene.GetSceneObjectFrom(object)

	-- Return it to the pool
	Template.FetchGlobal("__Rethink_Pool"):Retire(Scene.IsRigidbody(object) and object:GetFrame() or object)

	if not stripSymbols and t.table(Object.Symbols.IDs) then
		for _, symbolID in Object.Symbols.IDs do
			Object.SymbolJanitor:RemoveNoClean(symbolID)
		end
	end

	sceneObjects[Object.ID] = nil

	Object.Janitor:RemoveNoClean(Object.ID)
	Object:CleanUp()

	Scene.Events.ObjectRemoved:Fire(object)
end

--[=[
	Cleans up the provided object.

	@since 0.6.2
	@param object `GuiObject | Rigidbody`
]=]
function Scene.Cleanup(object: GuiBase2d | Types.Rigidbody)
	Log.TAssert(t.union(t.Instance, t.table)(object))

	Scene.GetSceneObjectFrom(object):CleanUp()
end

--[=[
	Cleans up all of the objects in the scene if called. If ignorePermanent
	is set to true Scene will ignore objects which have the Permanent
	symbol attached with the value of true.

	@since 0.5.3
	@param ignorePermanent `Boolean`
	@default ignorePermanent `False`
	@fires FlushStarted
	@fires FlushFinished
]=]
function Scene.Flush(ignorePermanent: boolean?)
	Log.TAssert(t.optional(t.boolean)(ignorePermanent))
	-- if not (GetTableLenght(sceneObjects) > 0) then
	-- 	return warn((DebugStrings.MethodFailNoScene):format("flush"))
	-- end

	if Scene.State == "Loading" then
		return Log.Warn(DebugStrings.Scene.CallBlockedProcessOngoing:format("flush", "loading"))
	end

	if Scene.State == "Flushing" then
		return Log.Warn(DebugStrings.Scene.CallBlockedProcessOngoing:format("flush", "flushing"))
	end

	Scene.Events.FlushStarted:Fire()

	Scene.State = "Flushing"

	-- Remove the left references to the deleted objects from sceneObjects
	-- TaskDistributor
	-- 	:Distribute(
	-- 		TaskDistributor.GenerateChunk(sceneObjects, Settings.CompilerChunkSize),
	-- 		function(object: SceneObject.SceneObject)
	-- 			if object.Symbols.ShouldFlush == false and ignoreShouldFlush == false or ignoreShouldFlush == nil then
	-- 				return
	-- 			end

	-- 			-- Scene.Events.ObjectRemoved:Fire(object.Object)

	-- 			-- Destroy the object's Janitor
	-- 			-- This will result in having all of the events disconnected, Rigidbody being destroyed
	-- 			-- and the UI element getting returned to the Pool for later use
	-- 			object.Janitor:Destroy()
	-- 		end
	-- 	)
	-- 	:await()

	for _, object: SceneObject.SceneObject in Scene.GetObjects() do
		if
			(t.boolean(object.Symbols.Permanent) and object.Symbols.Permanent == true)
			and (not t.boolean(ignorePermanent) or ignorePermanent == false)
		then
			continue
		end

		Scene.Events.ObjectRemoved:Fire(object.Object)

		Scene.Cleanup(object.Object)
	end

	Scene.State = "Standby"

	Scene.Events.FlushFinished:Fire()
end

--[=[
	Registers a new custom symbol handler. The returnKind parameter accepts:

	- 0 - Returns the symbol
	- 1 - Returns a function, when called returns the symbol

	### Example

	This example prints the object's ID and the attached value of the symbol.

	```lua
	Scene.RegisterCustomSymbol("testSymbol", 0, function(object, symbol)
		print(object.ID, symbol.SymbolData.Attached)
	end)
	```

	@since 0.6.2
	@param name `String`
	@param returnKind `Number`
	@param controller `(object, symbol) -> ()`
]=]
function Scene.RegisterCustomSymbol(
	name: string,
	returnKind: number,
	controller: (object: SceneObject.SceneObject, symbol: Types.Symbol) -> ()
)
	Log.TAssert(t.string(name))
	Log.TAssert(t.number(returnKind))
	Log.TAssert(t.callback(controller))

	Symbols.RegisterCustomSymbol(name, returnKind, controller)

	Log.Debug(`Registered new symbol with name: {name}, kind: {returnKind}!`)
end

--[=[
	Returns all of the objects with the specified tag.

	@since 0.6.0
	@param tag `String`
	@returns Objects `{[Number]: GuiBase2d | Types.Rigidbody}`
]=]
function Scene.GetFromTag(tag: string): { [number]: GuiBase2d | Types.Rigidbody }
	-- assert(typeof(tag) == "string", string.format(DebugStrings.ExpectedNoArg, "string", typeof(tag)))
	Log.TAssert(t.string(tag))

	local taggedObjects = CollectionService:GetTagged(tag)
	local foundObjects = {}

	for _, Object: SceneObject.SceneObject in sceneObjects do

		if table.find(taggedObjects, object) then
			table.insert(foundObjects, sceneObject.Object)
		end
	end

	return foundObjects
end

--[=[
	Returns a boolean to indicate if object is a rigidbody or not.

	@since 0.6.0
	@param object `GuiObject | Rigidbody`
	@returns Result `Boolean`
]=]
function Scene.IsRigidbody(object: GuiBase2d | Types.Rigidbody): boolean
	Log.TAssert(t.union(t.Instance, t.table)(object))

	return getmetatable(typeof(object) == "table" and object or nil) == RigidBody
end

--[=[
	Returns the object's ObjectReference table used by Scene.

	Useful to add custom events or logic to the object and making it sure
	that, that event/logic gets disconnected upon the destruction of the object.

	Internally used by `Scene.AddSymbols()`.

	@since 0.6.0
	@param object `GuiObject | Rigidbody`
	@returns Reference `ObjectReference`
]=]
function Scene.GetSceneObjectFrom(object: GuiBase2d | Types.Rigidbody): SceneObject.SceneObject
	Log.TAssert(t.union(t.Instance, t.table)(object))

	for _, Object: SceneObject.SceneObject in sceneObjects do
			continue
		end

		return objectReference
	end

	Log.Error(DebugStrings.Scene.ObjectReferenceNotFound:format(tostring(object)))
end

--[=[
	Returns all of the objects wihin scene containing all
	of the `ObjectReferences`.

	@since 0.5.3
	@returns Objects `{ [Types.UUID]: SceneObject }
]=]
function Scene.GetObjects(): { [Types.UUID]: SceneObject.SceneObject }
	return sceneObjects
end

return Scene
