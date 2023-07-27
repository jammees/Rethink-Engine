--[[

    Scene
	Last updated: 13/01/2023

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

local Settings = require(script.Parent.Parent.Settings)
local RigidBody = require(script.Parent.Physics.Physics.RigidBody)
local Template = require(script.Parent.Template)
local DebugStrings = require(script.Parent.Parent.Strings)
local Signal = require(script.Parent.Parent.Library.Signal)
local Compiler = require(script.Compiler)
local Symbols = require(script.Symbols)
local TypeCheck = require(script.Parent.Parent.Library.TypeCheck)
local TaskDistributor = require(script.Parent.Parent.Library.TaskDistributor).new()
local Janitor = require(script.Parent.Parent.Library.Janitor)
---@module src.Library.ObjectPool
local UiPool = Template.FetchGlobal("__Rethink_Pool")

local function GetTableLenght<T>(tbl: T)
	local lenght = 0

	for _ in tbl do
		lenght += 1
	end

	return lenght
end

-- TODO: Create a hash table to store the position of each object's index
local sceneObjects: { [string]: { [string]: any } } = {}

local Scene = {}

--[=[
	**Symbols**:

	| Name:				| Description:
	|--------------------------------------------------------------
	| Tag				| Gives the given object a `tag(s)` fetch it with `CollectionService` or `Scene:GetRigidbodyFromTag`
	| Property			| Applies `properties` or `symbols` to objects in the `group` or the `container`
	| Type				| How the compiler handles the object `UiBase` and `Rigidbody` or it's aliases
	| Event				| Hook events to the given object
	| ShouldFlush		| Determines if the object will get deleted on `.Flush()` (Delete After Flush)
	| Rigidbody			| Add rigidbody properties that later get fed into the Physics engine

	**Aliases with TYPE**

	There are a couple of aliases that are available to make indentifying the type easier.
	Additionally `UiBase` and `Rigidbody` can be used as well!
	
	| Alias:			| Base type:
	|--------------------------------------------------------------
	| Layer 			| UiBase
	| Static 			| UiBase
	| Dynamic 			| Rigidbody
]=]
Scene.Symbols = table.freeze(Symbols.Types)

-- Is the compiler still loading a scene in
Scene.IsLoading = false

-- Events that are useful to tell the state of Scene
Scene.Events = table.freeze({
	--	Fires before the scene gets loaded.
	LoadStarted = Signal.new(),
	--	Fires after the scene finished loading.
	LoadFinished = Signal.new(),
	--	Fires before the scene gets flushed.
	FlushStarted = Signal.new(),
	--	Fires after the scene got flushed.
	FlushFinished = Signal.new(),
	--	Fires after an object got added to the scene.
	--	@returns {Object} Can be a rigidbody class or a gui element
	ObjectAdded = Signal.new(),
	--	Fires after an object got removed from the scene.
	--	@returns {Object} Can be a rigidbody class or a gui element
	ObjectRemoved = Signal.new(),
})

--[=[
	Compiles a scene from a given data dictionary. Returns a `Promise`

	**Symbols**:

	| Name:				| Description:
	|--------------------------------------------------------------
	| Tag				| Gives the given object a `tag(s)` fetch it with `CollectionService` or `Scene:GetRigidbodyFromTag`
	| Property			| Applies `properties` or `symbols` to objects in the `group` or the `container`
	| Type				| How the compiler handles the object `UiBase` and `Rigidbody` or it's aliases
	| Event				| Hook events to the given object
	| ShouldFlush		| Determines if the object will get deleted on `.Flush()` (Delete After Flush)
	| Rigidbody			| Add rigidbody properties that later get fed into the Physics engine

	**Aliases with TYPE**

	There are a couple of aliases that are available to make
	indentifying the type easier.
	Additionally `UiBase` and `Rigidbody` can be used as well!
	
	| Alias:			| Base type:
	|--------------------------------------------------------------
	| Layer 			| UiBase
	| Static 			| UiBase
	| Dynamic 			| Rigidbody

	Symbols **must** be wrapped with `[]`. This is the reason
	that `Symbol`s are simple tables that hold data.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type
	local Property = Scene.Symbols.Property
	local Tag = Scene.Symbols.Tag

	Scene.Load({
		Name = "My scene",

		My_Container = {
			[Type] = "Layer",
			[Property] = {
				Transparency = 0.5
				[Tag] = "Container!"
			}
			
			Box = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(100, 100),
				Image = "rbxassetid://30115084",

				[Tag] = "Object!"
			}
		},
	})
	```

	@param {dictionary} sceneData
	@returns {promise} sceneTable
	@async
	@fires LoadStarted
	@fires LoadFinished
]=]
function Scene.Load(sceneData: { Name: string }): Types.Promise
	if Scene.IsLoading then
		return warn("[Scene] Already loading in a scene!")
	end

	assert(typeof(sceneData) == "table", string.format(DebugStrings.Expected, "table", typeof(sceneData), "2"))

	Scene.Events.LoadStarted:Fire()

	Scene.IsLoading = true

	if sceneData.Name == nil then
		sceneData.Name = "Unnamed scene"
	end

	-- Returns a promise to allow the function to
	-- In this Promise:
	-- Loop over the objects that the Compiler returned and add them to the scene
	-- After all fire the .LoadFinished event
	return Compiler.Prototype_Compile(sceneData)
		:andThen(function(compiledObjects)
			for _, object: CompiledObject in ipairs(compiledObjects) do
				-- Attach symbols
				Scene.Add(object.Object, object.Symbols)
			end

			Scene.IsLoading = false

			Scene.Events.LoadFinished:Fire()
		end)
		:catch(warn)
end

--[=[
	Can be used to add an instance into the scene, after it has been compiled.

	If ShouldFlush is false it will prevent the `:Flush` method to clean that object up.
	Supports adding symbols to the object.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local frame = Instance.new("Frame")
	frame.Size = Udim2.new(0, 100, 0, 100)

	Scene.Add(frame, {"Test1", "Test2"}, false)
	```

	@param {instance} object - The object to be added to the scene
	@param {array} tags - List of tags to add to the object
	@fires ObjectAdded
]=]

function Scene.Add(object: GuiBase2d | Types.Rigidbody, symbols: { [Types.Symbol]: any }?)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, symbols, "table")

	-- Define SceneObject
	local objectReference: Types.ObjectReference = {
		Object = object,
		Janitor = Janitor.new(),
		ID = HTTPService:GenerateGUID(false),
	}

	-- Allocate object
	sceneObjects[objectReference.ID] = objectReference

	-- Add cleanup function
	objectReference.Janitor:Add(function()
		local isRigidbody = Scene.IsRigidbody(objectReference.Object)

		if isRigidbody then
			objectReference.Object:Destroy()
		else
			UiPool:Return(objectReference.Object)
		end

		sceneObjects[objectReference.ID] = nil
	end, true, objectReference.ID)

	Scene.AddSymbols(object, symbols)

	Scene.Events.ObjectAdded:Fire(object)
end

--[=[
	Attaches symbols specified in `symbols` table to the specified `object`.
	Useful to create a custom compiler.

	@param {GuiBase2D | Rigidbody} object
	@param {dictionary} symbols
]=]
function Scene.AddSymbols(object: GuiBase2d | Types.Rigidbody, symbols: { [Types.Symbol]: any }?)
	if symbols == nil then
		return
	end

	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, symbols, "table")

	local attachedSymbols = {}

	-- Pack symbols
	for symbol, value in pairs(symbols) do
		if typeof(attachedSymbols[symbol.Name]) == "nil" then
			attachedSymbols[symbol.Name] = {}
		end

		symbol.SymbolData.Attached = value

		table.insert(attachedSymbols[symbol.Name], symbol)
	end

	local objectReference = Scene.GetObjectReference(object)

	if not objectReference.Symbols then
		objectReference.Symbols = {}
		objectReference.SymbolJanitor = Janitor.new()
		objectReference.Janitor:Add(objectReference.SymbolJanitor, "Destroy", "SymbolJanitor")
	end

	Symbols.AttachToInstance(objectReference, attachedSymbols)
end

--[=[
	Removes the given object from the `scene dictionary`.

	**Warning:** It does not delete the object!

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local frame = Instance.new("Frame")
	frame.Size = Udim2.new(0, 100, 0, 100)

	Scene.Add(frame)

	Scene.Remove(frame)
	```

	@param {instance} object - The object to get removed from the scene dictionary
	@yields
	@fires ObjectRemoved
]=]
function Scene.Remove(object: GuiBase2d | Types.Rigidbody, stripSymbols: boolean?)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")

	-- remove it from the scene dictionary
	for objectID, sceneObject: Types.ObjectReference in sceneObjects do
		if sceneObject.Object == object and objectID == sceneObject.ID then
			-- Return it to the pool
			UiPool:Retire(Scene.IsRigidbody(object) and object:GetFrame() or object)

			if not stripSymbols then
				for _, symbolID in sceneObject.Symbols.IDs do
					sceneObject.SymbolJanitor:RemoveNoClean(symbolID)
				end
			end

			sceneObject.Janitor:RemoveNoClean(objectID)
			sceneObject.Janitor:Destroy()

			sceneObjects[objectID] = nil

			Scene.Events.ObjectRemoved:Fire(object)

			return
		end
	end

	return error(string.format(DebugStrings.RemoveErrorNoObject, object.Name, typeof(object)))
end

--[=[
	Cleans up the janitor and removes every index from the `scene dictionary` if `ShouldFlush` is
	a falsy value (nil or false).

	**Notes:**
	- If the scene is empty, it will throw a warning.
	- Will ignore objects that have their `ShouldFlush` set to false

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type

	Scene.Load({Name = "My scene"}, {
		My_Container = {
			[Type] = "Rigidbody",
			
			My_group = {
				Box = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(100, 100),
					Image = "rbxassetid://30115084",
				}
			},
		},
	})

	Scene.Flush()
	```

	@param {boolean} ignoreShouldFlush - Whether Scene should delete objects that have ShouldFlush set to false
	@yields
	@fires Flush#FlushStarted
	@fires Flush#FlushFinished
]=]
function Scene.Flush(ignoreShouldFlush: boolean)
	if not (GetTableLenght(sceneObjects) > 0) then
		return warn((DebugStrings.MethodFailNoScene):format("flush"))
	end

	if Scene.IsLoading then
		return warn("Attempted to flush the scene; Loading in process!")
	end

	Scene.Events.FlushStarted:Fire()

	-- Remove the left references to the deleted objects from sceneObjects
	TaskDistributor
		:Distribute(
			TaskDistributor.GenerateChunk(sceneObjects, Settings.CompilerChunkSize),
			function(object: Types.ObjectReference)
				if object.Symbols.ShouldFlush == false and ignoreShouldFlush == false or ignoreShouldFlush == nil then
					return
				end

				warn(object.ID)

				Scene.Events.ObjectRemoved:Fire(object.Object)

				-- Destroy the object's Janitor
				-- This will result in having all of the events disconnected, Rigidbody being destroyed
				-- and the UI element getting returned to the Pool for later use
				object.Janitor:Destroy()
			end
		)
		:await()

	Scene.Events.FlushFinished:Fire()
end

--[=[
	Get's every object that has that specific
	tag no matter what type it is.

	@param {string} tag
	@yields
	@public
	@returns {array} All of the collected objects that were tagged
]=]
function Scene.GetFromTag(tag: string): { [number]: GuiBase2d | Types.Rigidbody }
	assert(typeof(tag) == "string", string.format(DebugStrings.ExpectedNoArg, "string", typeof(tag)))

	local taggedObjects = CollectionService:GetTagged(tag)
	local foundObjects = {}

	for _, sceneObject: Types.ObjectReference in sceneObjects do
		local object = Scene.IsRigidbody(sceneObject.Object) and sceneObject.Object:GetFrame() or sceneObject.Object

		if table.find(taggedObjects, object) then
			table.insert(foundObjects, sceneObject.Object)
		end
	end

	return foundObjects
end

--[=[
	Checks the given instance if it is a rigidbody

	@param {Instance | table} object - The object to check if it is a rigidbody
	@yields
	@public
	@returns {boolean}
]=]
function Scene.IsRigidbody(object: GuiBase2d | Types.Rigidbody): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == RigidBody
end

--[=[
	Returns the object's data that is tracked in `Scene`.

	Useful to add custom events or logic to the object and making it sure
	that, that event/logic gets disconnected upon destroying it.

	@param {GuiBase2d | Types.Rigidbody} object
	@yields
	@returns {SceneObject}
]=]
function Scene.GetObjectReference(object: GuiBase2d | Types.Rigidbody): Types.ObjectReference
	for _, objectReference: Types.ObjectReference in sceneObjects do
		if objectReference.Object ~= object then
			continue
		end

		return objectReference
	end

	return error(`Unable to find {object} in the sceneObjects list!`)
end

--[=[
	Can be used to retrieve all of the scene objects, that make the currently compiled scene.
	
	Contains the Janitor used to clean that specific objec up, the object reference, ShouldFlush
	flag as well as the position in the sceneObjects.

	@yields
	@public
	@returns {array} Returns all of the trakced objects
]=]
function Scene.GetObjects(): { Types.ObjectReference }
	return sceneObjects
end

return Scene
