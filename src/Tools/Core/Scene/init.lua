--[[

    Scene
	Last updated: 28/05/2022

]]

type SceneObject = {
	Object: Instance | { any },
	Id: string,
	DAF: boolean,
}

local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local package = script.Parent.Parent.Parent
local components = package.Components
local lib = components.Lib
local tools = package.Tools

local Util = require(components.Util)
local Strings = require(components.Debug.Strings)
local Signal = require(components.Lib.Signal)
local Janitor = require(lib.Janitor).new()
local RigidBody = require(tools.Environment.Physics.Physics.RigidBody)
local Symbols = require(script.Symbols)
local Compiler = require(script.Compiler)
local Template = require(package.Tools.Utility.Template)

local PhysicsEngine = Template.FetchGlobal("__Rethink_Physics")

local sceneObjects = {}
local sceneCache = {}

local Scene = {}

-- public properties

Scene.Symbols = Symbols
Scene.SceneName = nil
Scene.Events = {
	LoadStarted = Signal.new(),
	LoadFinished = Signal.new(),
	FlushStarted = Signal.new(),
	FlushFinished = Signal.new(),
	ObjectAdded = Signal.new(),
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
	| Type				| How the compiler handles the object `Layer` and `Rigidbody`
	| Children			| Add objects that are parented to the given object
	| Event				| Hook events to the given object
	| DAF				| Determines if the object will get deleted on `.Flush()`
	| Rigidbody			| Add rigidbody properties that later get fed into the Physics engine
	
	Symbols **must** be wrapped with `[]`

	**Protocols**:

	Protocols are a pair of modules, that define how an object can be reconstructed from a pair of tables.
	In case if there's no `CompileMode` defined or it can't find the one specified, it will fall back to `Standard`'s modules.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	local Type = Scene.Symbols.Type
	local Property = Scene.Symbols.Property
	local Tag = Scene.Symbols.Tag

	Scene.Load({Name = "My scene", CompileMode = "Standard"}, {
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
]=]
function Scene.Load(sceneConfig: { any }, sceneTable: { [string | number]: any })
	assert(typeof(sceneConfig) == "table", string.format(Strings.Expected, "table", typeof(sceneConfig), "1"))
	assert(typeof(sceneTable) == "table", string.format(Strings.Expected, "table", typeof(sceneConfig), "2"))

	Scene.Events.LoadStarted:Fire()

	return Compiler(sceneConfig, sceneTable):andThen(function(layers, rigids)
		Scene.SceneName = sceneConfig.Name or "Unnamed scene"

		-- do some stuffs
		for _, v in ipairs(Util.MergeTablesIndex(layers, rigids)) do
			Scene.Add(v)
		end

		Scene.Events.LoadFinished:Fire()
	end):catch(warn)
end

---------------------------------------------------------------------
-- UNFINISHED CODE
-- NOT WORKING ON IT

-- function for caching a scene
-- basically saving instances so later down the line it won't need to

-- UPDATE: cache methods are discontinued now because I figured that
-- it's better to create all of the instances at the same time
-- because this whole cache doesn't apply to rigidbody's
-- they still get destroyed, they still need to be created
-- won't delete the code in case someone will have a better idea
function Scene.Prototype_1v_Cache(cacheName: string)
	warn("Prototype_1v_Cache is unfinished")

	if Scene.SceneName == nil then
		return warn((Strings.MethodFailNoScene):format("cache"))
	end

	-- save the sceneObjects to a cache so later it can be grabbed again

	local localCache = sceneObjects
	local newCache = { CachedRigids = {}, CachedLayers = {} }

	for _, v: SceneObject in ipairs(localCache) do
		if RigidBody.is(v.Object) then
			local rigidObject: Instance | GuiBase2d = v.Object:GetFrame()
			local newSceneRef = v

			newSceneRef.Object = rigidObject
			newSceneRef.Temp = { Parent = rigidObject.Parent, Transparency = rigidObject.Transparency }

			-- thought about a new way, by simply getting all of the settings and
			-- encoding the table into JSON to hopefully
			-- save memory or something like that
			-- also would be cool if there are mutliple properties that match
			-- they would just reference eachother or something like that
			-- not sure if it would save memory
			newSceneRef.Prop = HttpService:JSONEncode(v.Object:GetSettings())

			warn(newSceneRef)

			--local newObject = rigidObject:Clone()
			--newSceneRef.Object.Parent = cacheFolder
			--newSceneRef.Object = newObject

			--v.Object:Destroy()

			-- prevent the rigidbody to update itself.
			-- thinking about maybe trying to save it's properties and then destroy the rigidbody to save up memory
			-- since we already use memory to save the scene object's properties

			table.insert(newCache.CachedRigids, newSceneRef)
		else
			table.insert(newCache.CachedLayers, v)
		end
	end

	sceneCache[cacheName or Scene.SceneName] = newCache

	print("Finished caching scene", cacheName or Scene.SceneName, newCache)

	print(sceneCache)
end

function Scene.Prototype_1v_UnCache(cacheName: string)
	warn("Prototype_1v_Cache is unfinished")

	if sceneCache[cacheName] then
		table.clear(sceneCache[cacheName])
		sceneCache[cacheName] = nil
	else
		warn(("Cache %s not found!"):format(cacheName))
	end
end

function Scene.Prototype_1v_LoadCache(cacheName: string, flushLoaded: boolean)
	warn("Prototype_1v_Cache is unfinished")

	if sceneCache[cacheName] then
		if flushLoaded then
			Scene.Flush()
		end
	end
end

function Scene.Prototype_1v_GetCache()
	warn("Prototype_1v_Cache is unfinished")

	return sceneCache
end

---------------------------------------------------------------------

--[=[
	Can be used to add an instance into the scene, after it has been compiled.

	**Notes:**

	- As an addition, tags can be added to the instance.
	- If destroy after flush is false it will prevent the `:Flush` method to clean that object up

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	local frame = Instance.new("Frame")
	frame.Size = Udim2.new(0, 100, 0, 100)

	Scene.Add(frame, {"Test1", "Test2"}, false)
	```
]=]
function Scene.Add(object: Instance, tags: { [number]: string } | string, destroyAfterFlush: boolean)
	Util.Assert(Strings.ExpectedNoArg, object, "Instance", "table")
	Util.Assert(Strings.ExpectedNoArg, tags, "table", "string", "nil")
	Util.Assert(Strings.ExpectedNoArg, destroyAfterFlush, "boolean", "nil")

	if tags then
		if RigidBody.is(object) then
			Util.AddTagToInstance(object:GetFrame(), tags)
		else
			Util.AddTagToInstance(object, tags)
		end
	end

	local objectId = HttpService:GenerateGUID(false)

	table.insert(sceneObjects, {
		Object = object,
		Id = objectId,
		DAF = destroyAfterFlush,
	})

	if destroyAfterFlush ~= false then
		Janitor:Add(object, "Destroy", objectId)
	end

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
]=]
function Scene.Remove(object: Instance)
	assert(typeof(object) == "Instance", string.format(Strings.ExpectedNoArg, "Instance", typeof(object)))

	-- remove it from the scene dictionary
	for index, sceneObject in ipairs(sceneObjects) do
		if sceneObject.Object == object then
			Janitor:RemoveFromSelf(sceneObject.Id) --> remove from janitor
			sceneObject[index] = nil

			Scene.Events.ObjectRemoved:Fire(object)

			return
		end
	end

	warn(string.format(Strings.RemoveErrorNoObject, object.Name, typeof(object)))
end

--[=[
	Cleans up the janitor and removes every index from the `scene dictionary` if `delete after flush` is
	`false` or `nil`.

	**Notes:**
	- If the scene is empty, it will throw a warning instead.
	- Will ignore objects that have their `DAF` set to false

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
]=]
function Scene.Flush()
	if Scene.SceneName == nil then
		return warn((Strings.MethodFailNoScene):format("flush"))
	end

	Scene.Events.FlushStarted:Fire()

	Scene.SceneName = nil

	Janitor:Cleanup() --> cleans up all the objects

	-- remove the left references to the deleted objects from sceneObjects
	for index, sceneObject in ipairs(sceneObjects) do
		if sceneObject.DAF ~= false then
			sceneObjects[index] = nil
		end
	end

	Scene.Events.FlushFinished:Fire()
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
]=]
function Scene.GetBodyFromTag(tag: string): { [number]: { any } } | { any }
	assert(typeof(tag) == "string", string.format(Strings.ExpectedNoArg, "string", typeof(tag)))

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

-- Some getter functions

--[=[
	Returns a signal class if already exists, if not it will create a new signal.

	**Available signals:**
	- `LoadStarted`: fired before attempting to start compiling the scene from a dictionary
	- `LoadFinished`: fired after the scene has been compiled successfully
	- `FlushStarted`: fired before starting to flush the scene
	- `FlushFinished`: fired after finished flushing the scene
	- `ObjectAdded`: fired after an object has been added to the scene
	- `ObjectRemoved`: fired after an object has been removed from the scene and from the janitor

	Alternative way of getting a signal: `Scene.Events`

	**Example"**
	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Scene = Rethink.Scene

	Scene.GetSignal("LoadStarted"):Connect(function()
		print("Finished loading in scene, called.. " .. Scene.SceneName)
	end)
	```
]=]
function Scene.GetSignal(signalName: string)
	if Scene.Events[signalName] then
		return Scene.Events[signalName]
	end

	warn(string.format(Strings.SignalNotFound, tostring(signalName)))
end

--[=[
	Can be used to retrieve the currently compiled scene's name, specified in the sceneTable.
]]
]=]
function Scene.GetName(): string
	return Scene.SceneName
end

--[=[
	Can be used to retrieve all of the scene objects, that make the currently compiled scene.
]=]
function Scene.GetObjects(): { [number]: any }
	return sceneObjects
end

return Scene
