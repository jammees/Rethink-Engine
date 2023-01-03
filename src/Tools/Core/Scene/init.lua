--[[

    Scene
	Last updated: 28/05/2022

]]

type SceneObject = {
	Object: Instance | { any },
	ShouldFlush: boolean,
}

type Tag = { [number]: string } | string?
type SceneConfig = { Name: string }

local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local package = script:FindFirstAncestor("Tools").Parent
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

local PhysicsEngine = Template.FetchGlobal("__Rethink_Physics")

local sceneObjects = {}

local function AddTag(object: Instance, tags: { [number]: string } | string?)
	if typeof(tags) == "table" then
		for _, tag in ipairs(tags) do
			CollectionService:AddTag(object, tag)
		end
	else
		CollectionService:AddTag(object, tags)
	end
end

local Scene = {}

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
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
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
	@return {dictionary} sceneTable
	@async
	@fires LoadStarted
	@fires LoadFinished
]=]
function Scene.Load(sceneConfig: SceneConfig, sceneData: { any })
	assert(typeof(sceneConfig) == "table", string.format(DebugStrings.Expected, "table", typeof(sceneConfig), "1"))
	assert(typeof(sceneData) == "table", string.format(DebugStrings.Expected, "table", typeof(sceneConfig), "2"))

	Scene.Events.LoadStarted:Fire()

	-- Returns a promise to allow the function to yield
	-- In this Promise:
		-- Reassign SceneName to the specified one in the sceneConfig
		-- Loop over the objects that the Compiler returned and add them to the scene
		-- After all fire the .LoadFinished event
	return Compiler.Compile(sceneData):andThen(function(compiledObjects)
		Scene.SceneName = sceneConfig.Name or "Unnamed scene"

		for _, v in ipairs(compiledObjects) do
			Scene.Add(v)
		end

		Scene.Events.LoadFinished:Fire()
	end):catch(warn)
end

--[=[
	Can be used to add an instance into the scene, after it has been compiled.

	Tags can be added to the instance.
	If ShouldFlush is false it will prevent the `:Flush` method to clean that object up.
	Does not support adding symbols to the object.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
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
function Scene.Add(object: any, tags: Tag?, shouldFlush: boolean?)
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, object, "Instance", "table")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, tags, "table", "string", "nil")
	TypeCheck.Assert(DebugStrings.ExpectedNoArg, shouldFlush, "boolean", "nil")

	if tags then
		if Scene.IsRigidbody(object) then
			AddTag(object:GetFrame(), tags)
		else
			AddTag(object, tags)
		end
	end

	table.insert(sceneObjects, {
		Object = object,
		ShouldFlush = shouldFlush,
	})

	Scene.Events.ObjectAdded:Fire(object)
end

--[=[
	Removes the given object from the `scene dictionary` and from the janitor.
	If the object does not exist in the `scnene dictionary` it won't throw an error.

	**Warning:** It does not delete the object!

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
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
	assert(typeof(object) == "Instance", string.format(DebugStrings.ExpectedNoArg, "Instance", typeof(object)))

	-- remove it from the scene dictionary
	for index, sceneObject: SceneObject in ipairs(sceneObjects) do
		if sceneObject.Object == object then
			-- Return it to the pool
			UiPool:Return(object)

			table.remove(sceneObject, index)

			Scene.Events.ObjectRemoved:Fire(object)

			return
		end
	end

	warn(string.format(DebugStrings.RemoveErrorNoObject, object.Name, typeof(object)))
end

--[=[
	Cleans up the janitor and removes every index from the `scene dictionary` if `delete after flush` is
	`false` or `nil`.

	**Notes:**
	- If the scene is empty, it will throw a warning instead.
	- Will ignore objects that have their `ShouldFlush` set to false

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type

	Scene.Load({Name = "My scene", CompileMode = "Standard"}, {
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

	-- remove the left references to the deleted objects from sceneObjects
	for index, sceneObject in ipairs(sceneObjects) do
		if sceneObject ~= false then
			local isRigidbody = Scene.IsRigidbody(sceneObject.Object)

			UiPool:Return(isRigidbody and sceneObject.Object:GetFrame() or sceneObject.Object)

			if isRigidbody then
				sceneObject.Object:Destroy()
			end

			sceneObjects[index] = nil
		end
	end

	Scene.Events.FlushFinished:Fire()

	return
end

--[=[
	Gets a collection of rigidbody(s) from a tag, that can be assigned with the `Tag` symbol.

	If only one rigidbody is found it will return only that, else will will return a table with the
	other rigidbodies

	**Example:**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type
	local Tag = Scene.Symbols.Tag

	Scene.Load({Name = "My scene", CompileMode = "Standard"}, {
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
function Scene.GetBodyFromTag(tag: string): { [number]: { any } } | { any }
	assert(typeof(tag) == "string", string.format(DebugStrings.ExpectedNoArg, "string", typeof(tag)))

	local results = {}

	for _, object in ipairs(CollectionService:GetTagged(tag)) do --> fetch instances tagged with "tag argument"
		for _, rigid in ipairs(PhysicsEngine:GetBodies()) do --> loop trough all of the rigidbodies (i'll try to optimize it somehow)
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
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	Scene.GetSignal("LoadStarted"):Connect(function()
		print("Finished loading in scene, called.. " .. Scene.SceneName)
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
