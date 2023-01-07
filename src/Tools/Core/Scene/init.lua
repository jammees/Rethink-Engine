--[[

    Scene
	Last updated: 28/05/2022

	Scene currently does not support custom rigidbodies.

]]

type CompiledObject = {
	Object: any,
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
local Types = require(script.Types)

local PhysicsEngine = Template.FetchGlobal("__Rethink_Physics")

local sceneObjects = {}

local Scene = {}

Scene.TEST_MODE = false

-- public properties
Scene.Symbols = Symbols.Types
Scene.SceneName = nil
Scene.Events = {
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
}

-- public methods

--[=[
	Compiles a scene from a given data dictionary. Returns a `Promise`
	
	**Notes:**

	Additional `scene config` can also be passed as an argument.
	Custom `protocols` can be used to tell the compiler how to build up your object.

	**Symbols**:

	| Name:				| Description:
	|--------------------------------------------------------------
	| Tag				| Gives the given object a `tag(s)` fetch it with `CollectionService` or `Scene:GetRigidbodyFromTag`
	| Property			| Applies `properties` or `symbols` to objects in the `group` or the `container`
	| Type				| How the compiler handles the object `UiBase` and `Rigidbody`
	| Children			| Add objects that are parented to the given object
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

	Symbols **must** be wrapped with `[]`

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type
	local Property = Scene.Symbols.Property
	local Tag = Scene.Symbols.Tag

	Scene.Load({Name = "My scene"}, {
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

	@param {dictionary} sceneConfig
	@param {dictionary} sceneData
	@return {promise} sceneTable
	@async
	@fires LoadStarted
	@fires LoadFinished
]=]
function Scene.Load(sceneConfig: SceneConfig, sceneData: { any }): { any }
	assert(typeof(sceneConfig) == "table", string.format(DebugStrings.Expected, "table", typeof(sceneConfig), "1"))
	assert(typeof(sceneData) == "table", string.format(DebugStrings.Expected, "table", typeof(sceneConfig), "2"))

	Scene.Events.LoadStarted:Fire()

	-- Returns a promise to allow the function to yield
	-- In this Promise:
	-- Reassign SceneName to the specified one in the sceneConfig
	-- Loop over the objects that the Compiler returned and add them to the scene
	-- After all fire the .LoadFinished event
	return Compiler.Compile(sceneData)
		:andThen(function(compiledObjects)
			Scene.SceneName = sceneConfig.Name or "Unnamed scene"

			for _, object: CompiledObject in ipairs(compiledObjects) do
				-- Attach symbols
				--Scene.prototype_v1_Add(object.Object)
				--Symbols.AttachToInstance(Scene.prototype_v1_Add(object.Object), object.Source.SymbolsAttached)
				Scene.Add(object.Object, object.Symbols)
			end

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
function Scene.Add(object: any, symbols: { [Types.Symbol]: any }?)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, symbols, "table")

	local ObjectReference = {
		Object = object,
		ObjectJanitor = Janitor.new(),
		Index = 0,
	}

	-- Handle cleanup of the object
	ObjectReference.ObjectJanitor:Add(function()
		local cachedObject = object
		local isRigidbody = Scene.IsRigidbody(cachedObject)

		UiPool:Return(isRigidbody and cachedObject:GetFrame() or cachedObject)

		if isRigidbody then
			cachedObject:Destroy()
		end
	end)

	-- If the symbols table is a table, then try to attach symbols to that object
	if typeof(symbols) == "table" then
		local attachedSymbols = {}

		-- Pack symbols
		for symbol, value in pairs(symbols) do
			if typeof(attachedSymbols[symbol.Name]) == "nil" then
				attachedSymbols[symbol.Name] = {}
			end

			symbol.SymbolData.Attached = value

			table.insert(attachedSymbols[symbol.Name], symbol)
		end

		Symbols.AttachToInstance(ObjectReference, attachedSymbols)
	end

	local reservedPosition = #sceneObjects + 1

	ObjectReference.Index = reservedPosition

	sceneObjects[reservedPosition] = ObjectReference

	Scene.Events.ObjectAdded:Fire(object)
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

	Scene.Add(frame, {"Test1", "Test2"}, false)

	Scene.Remove(frame)
	```

	@param {instance} object - The object to get removed from the scene dictionary
	@fires ObjectRemoved
]=]
function Scene.Remove(object: Instance)
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

	warn(string.format(DebugStrings.RemoveErrorNoObject, object.Name, typeof(object)))
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

	@fires Flush#FlushStarted
	@fires Flush#FlushFinished
]=]
function Scene.Flush()
	if Scene.SceneName == nil then
		return warn((DebugStrings.MethodFailNoScene):format("flush"))
	end

	Scene.Events.FlushStarted:Fire()

	Compiler.CompilerDistributor:Cancel()

	Scene.SceneName = nil

	-- Remove the left references to the deleted objects from sceneObjects
	TaskDistributor:Distribute(TaskDistributor.GenerateChunk(sceneObjects, 100), function(object: Types.SceneObject)
		if object.ShouldFlush == false then
			return
		end

		-- Destroy the object's Janitor
		-- This will result in having all of the events disconnected, Rigidbody being destroyed
		-- and the UI element getting returned to the Pool for later use
		object.ObjectJanitor:Destroy()

		sceneObjects[object.Index] = nil
	end):await()

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
function Scene.GetBodyFromTag(tag: string): { [number]: { any } }
	assert(typeof(tag) == "string", string.format(DebugStrings.ExpectedNoArg, "string", typeof(tag)))

	local results = {}

	for _, object in ipairs(CollectionService:GetTagged(tag)) do --> fetch instances tagged with "tag argument"
		for _, rigid in ipairs(PhysicsEngine:GetBodies()) do --> loop trough all of the rigidbodies (i'll try to optimize it somehow) -> UPDATE: won't
			if rigid.frame == object then
				table.insert(results, {
					Object = object,
					Class = rigid,
				})
			end
		end
	end

	return results
end

--[=[
	Checks the given instance if it is a rigidbody

	@param {Instance | table} object - The object to check if it is a rigidbody
	@yields
	@public
	@returns {boolean}
]=]
function Scene.IsRigidbody(object: any): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == RigidBody
end

-- Some getter functions

--[=[
	Returns a signal class if already exists, if not it will create a new signal.

	**Available signals:**
	- `LoadStarted`: fired before attempting to start compiling the scene from a dictionary
	- `LoadFinished`: fired after the scene has been compiled successfully
	- `FlushStarted`: fired before starting to flush the scene
	- `FlushFinished`: fired after finished flushing the scene
	- `ObjectAdded`: fired after an object has been added to the scene
	- `ObjectRemoved`: fired after an object has been removed from the scene

	Alternative way of getting a signal: `Scene.Events`

	**Example"**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
	local Scene = Rethink.Scene

	Scene.GetSignal("LoadStarted"):Connect(function()
		print("Finished loading in scene; " .. Scene.SceneName)
	end)
	```

	@param {string} signalName
	@yields
	@public
	@alias Scene.Events
	@returns {signal} Returns a signal object
]=]
function Scene.GetSignal(signalName: string): { any }?
	if Scene.Events[signalName] then
		return Scene.Events[signalName]
	end

	warn(string.format(DebugStrings.SignalNotFound, tostring(signalName)))

	return
end

--[=[
	Can be used to retrieve the currently compiled scene's name, specified in the sceneTable.

	@yields
	@public
	@returns {string} Returns the loaded scene's name
]]
]=]
function Scene.GetName(): string
	return Scene.SceneName
end

--[=[
	Can be used to retrieve all of the scene objects, that make the currently compiled scene.

	@yields
	@public
	@returns {array} Returns all of the trakced objects
]=]
function Scene.GetObjects(): { [number]: any }
	return sceneObjects
end

return Scene
