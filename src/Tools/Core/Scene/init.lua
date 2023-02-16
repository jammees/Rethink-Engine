--[[

    Scene
	Last updated: 13/01/2023

	Scene does not support custom rigidbodies.

]]

local Types = require(script.Types)

type CompiledObject = {
	Object: GuiBase2d | Types.Rigidbody,
	Symbols: any,
}

type Tag = { [number]: string } | string?

type SceneConfig = { Name: string }

local CollectionService = game:GetService("CollectionService")

local package = script.Parent.Parent.Parent
local components = package.Components
local library = components.Library
local tools = package.Tools

local RigidBody = require(tools.Environment.Physics.Physics.RigidBody)
local Template = require(package.Tools.Utility.Template)
local DebugStrings = require(components.Debug.Strings)
local Signal = require(library.Signal)
local Compiler = require(script.Compiler)
local Symbols = require(script.Symbols)
local TypeCheck = require(components.Debug.TypeCheck)
local UiPool = Template.FetchGlobal("__Rethink_Pool")
local TaskDistributor = require(components.Library.TaskDistributor).new()
local Janitor = require(components.Library.Janitor)
local PhysicsEngine = Template.FetchGlobal("__Rethink_Physics")

-- TODO: Create a hash table to store the position of each object's index
local sceneObjects = {}

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
	
	**Notes:**
	Additional `scene config` can also be passed as an argument.

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
			
			My_group = {
				[Property] = {
					Class = "ImageButton"
					[Tag] = "Group!"
				}

				Box = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(100, 100),
					Image = "rbxassetid://30115084",

					[Tag] = "Object!"
				}
			},
		},
	})
	```

	@param {dictionary} sceneData
	@returns {promise} sceneTable
	@async
	@fires LoadStarted
	@fires LoadFinished
]=]
function Scene.Load(sceneData: { any }): { any }
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
	@param {boolean} destroyAfterFlush - Whether the object will get deleted after .Flush() was called
	@fires ObjectAdded
]=]

function Scene.Add(object: GuiBase2d | Types.Rigidbody, symbols: { [Types.Symbol]: any }?)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, symbols, "table")

	-- Define SceneObject
	local ObjectReference: Types.SceneObject = {
		Object = object,
		ObjectJanitor = Janitor.new(),
		Index = 0,
	}

	-- Allocate object
	local reservedPosition = #sceneObjects + 1
	ObjectReference.Index = reservedPosition
	table.insert(sceneObjects, ObjectReference)

	-- Add cleanup function
	ObjectReference.ObjectJanitor:Add(function()
		local cachedReference = ObjectReference
		local isRigidbody = Scene.IsRigidbody(cachedReference.Object)

		UiPool:Return(isRigidbody and cachedReference.Object.frame or cachedReference.Object)

		if isRigidbody == true then
			cachedReference.Object:Destroy()
		end

		table.remove(sceneObjects, cachedReference.Index)

		-- Reassign indexes
		for position, sceneObject: Types.SceneObject in pairs(sceneObjects) do
			sceneObject.Index = position
		end

		cachedReference = nil
	end)

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

	Symbols.AttachToInstance(Scene.GetObjectReference(object), attachedSymbols)
end

--[=[
	Removes the given object from the `scene dictionary`.
	If the object does not exist in the `scnene dictionary` it will throw a warning instead
	of an error.

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
function Scene.Remove(object: GuiBase2d | Types.Rigidbody)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")

	-- remove it from the scene dictionary
	for index, sceneObject: Types.SceneObject in ipairs(sceneObjects) do
		if sceneObject.Object == object then
			-- Return it to the pool
			UiPool:Return(object)

			sceneObject.ObjectJanitor:DestroyNoCleanup()

			table.remove(sceneObject, index)

			Scene.Events.ObjectRemoved:Fire(object)

			return true
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

	@param {boolean} ignoreShouldFlush 
	@yields
	@fires Flush#FlushStarted
	@fires Flush#FlushFinished
]=]
function Scene.Flush(ignoreShouldFlush: boolean)
	if #sceneObjects == 0 then
		return warn((DebugStrings.MethodFailNoScene):format("flush"))
	end

	Scene.Events.FlushStarted:Fire()

	-- Remove the left references to the deleted objects from sceneObjects
	TaskDistributor
		:Distribute(TaskDistributor.GenerateChunk(sceneObjects, 100), function(object: Types.SceneObject)
			if object.ShouldFlush == false and ignoreShouldFlush == false or ignoreShouldFlush == nil then
				return
			end

			Scene.Events.ObjectRemoved:Fire(object.Object)

			-- Destroy the object's Janitor
			-- This will result in having all of the events disconnected, Rigidbody being destroyed
			-- and the UI element getting returned to the Pool for later use
			object.ObjectJanitor:Destroy()
		end)
		:await()

	Scene.Events.FlushFinished:Fire()
end

--[=[
	Gets a collection of rigidbodies from a tag, that can be assigned with the `Tag` symbol in
	a scene file, or by using `Scene.Add`.

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type
	local Tag = Scene.Symbols.Tag

	Scene.Load({Name = "My scene"}, {
		My_Container = {
			[Type] = "Rigidbody",
			
			My_group = {
				Box = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(100, 100),
					Image = "rbxassetid://30115084",

					[Tag] = "Object!"
				}
			},
		},
	})

	local myBox = Scene.GetBodyFromTag("Object!")
	print(myBox)
	```

	@param {string} tag - Look for objects with the specified tag
	@yields
	@public
	@returns {array} Collection of all rigidbodies with the given tag
]=]
function Scene.GetBodyFromTag(tag: string): { [number]: { Types.Rigidbody } }
	assert(typeof(tag) == "string", string.format(DebugStrings.ExpectedNoArg, "string", typeof(tag)))

	local rigidbodies = PhysicsEngine:GetBodies()
	local foundBodies = {}

	for _, object in ipairs(CollectionService:GetTagged(tag)) do --> fetch instances tagged with "tag argument"
		for _, rigidbody in ipairs(rigidbodies) do --> loop trough all of the rigidbodies (i'll try to optimize it somehow) -> UPDATE: won't -> UPDATE: will
			if rigidbody.frame == object then
				table.insert(foundBodies, rigidbody)
			end
		end
	end

	return foundBodies
end

function Scene.GetFromTag(tag: string): { [number]: GuiBase2d | Types.Rigidbody }
	return 0
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
	@returns SceneObject
]=]
function Scene.GetObjectReference(object: GuiBase2d | Types.Rigidbody): Types.SceneObject
	for _, objectReference: Types.SceneObject in ipairs(sceneObjects) do
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
function Scene.GetObjects(): { [number]: Types.SceneObject }
	return sceneObjects
end

return Scene
