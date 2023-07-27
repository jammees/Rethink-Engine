# Scene

Scene is the main part of Rethink engine, which makes working with Nature2D and in general working with UIs much more simpler and easier.
It provides a simple API which can load in dozens of objects if required into the game with ease.

<br>

## Properties

<hr>

### Symbols

Symbols are an easy way to add additional functionality to an
object. This feature was inspired by Fusion.

**All available symbols and their description**

| Name:				| Description:
| ----------------- |------------------------------------------
| Tag				| Gives the given object a `tag(s)` fetch it with `CollectionService` or `Scene:GetRigidbodyFromTag`
| Property			| Applies `properties` or `symbols` to objects in the `group` or the `container`
| Type				| How the compiler handles the object `UiBase` and `Rigidbody` or it's aliases
| Event				| Hook events to the given object
| ShouldFlush		| Determines if the object will get deleted on `.Flush()` (Delete After Flush)
| Rigidbody			| Add rigidbody properties that later get fed into the Physics engine

??? note "Type symbol and its aliases"
    
    Rethink allows to use alises with the `Type` symbol.

	The Type symbol is used within containers, which defines
	that container what kind of objects it contains. This is required
	since the Compiler has no context of what type objects are
	supposed to be.

    | Alias:			| Base type:
	| ----------------- | -----------------------------------------
	| Layer 			| UiBase
	| Static 			| UiBase
	| Dynamic 			| Rigidbody

	If prefered UiBase and Rigidbody can be used.

**Example**

```lua
-- This would be somewhere in one of the scene files.
MyObject = {
    Class = "TextButton",
    [Rethink.Scene.Symbols.Event("MouseButton1Click")] = function(object)
        print(object, "was clicked")
    end
}
```

!!! note

    Symbols should always be encapsulated by *[ ]* because symbols are just simple tables that tell Scene what to do.

??? tip "Custom symbols"

	Custom made symbols can be easily created by going into the `SymbolConfig` located in Scene under the `Symbols` module.

	SymbolConfig is the one that defines and handles all of the symbols and their behaviour. 
	This is how usually a symbol looks like:

	```lua
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
	```

	The first argument the `object` is a sceneReference containing all of the vital information that is required for
	scene to handle the cleanup and tracking of each of the objects in the scene.

	The second argument the `symbol` is the symbol object itself. Can be used to retrieve information that
	could've been defined for it, such as a callback function or a string. (In this a string or a set of strings)

	**NOTE:** Rembember to always use Janitor if possible to
	clean up any event/connections after the object has been removed
	from the scene. This is required because the objects do not get
	destroyed but rather get fed back to the pool for later use.

	It is required to define the custom symbol in the `TypeLookup` table. This table
	defines how each symbol should function and is used to check whether that symbol
	exists or not.

	| Value			| Behaviour
	| ------------- | -----------------------
	| 0				| Returns the symbol itself
	| 1				| Returns a function that when called returns the symbol itself with the given argument fron the function

<br>

### IsLoading

IsLoading is a simple property which tells if the compiler is busy or not working on a scene.

<br>

### Events

Events are simple ways to run certain behaviour at certain times.

**List of all available events**

| Name:                     | Description:
| ------------------------- | ------------------------------------
| LoadStarted               | Fires before the scene gets loaded
| LoadFinished              | Fires after the scene got loaded
| FlushStarted              | Fires before the scene gets flushed/deleted
| FlushFinished             | Fires after the scene got flushed/deleted
| ObjectAdded               | Fires when an object got added to the scene, provides object
| ObjectRemoved             | Fires when an object got removed from the scene, provides object


## API

<hr>

### .Load(`sceneData`)

<span style="color:rgba(197, 148, 197, 1);">@param {dictionary} sceneData</span>

Load is the main part of Scene which handles loading in objects from tables.

Returns a promise.

??? hint "One example of such table"

    ```lua
    return {
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
	}
    ```

In a scene file a `Name` filed has to be provided. This is how Rethink looks up cached scenes. If not present it will default to `Unnamed scene` resulting in overwriting the last one.

How a scene file is typically structured:

| Level: | Name:      | Description:
| ------ | ---------- | ------------------------------
| 0      | Main body  | The main part where we define the `Containers` as well as the `Name`
| 1      | Containers | Containers define the groups, as well as the `Type` of the objects and the `Properties` that objects may share
| 2      | Objects    | Objects define their properties and their symbols based on previous `Property` symbols and the data inside the table

The compiler reads the `Property` symbols in these order: Containers -> Objects.
Meaning that objects always overwrite the properties that `Property` symbols give.

<br>

### .Add(`object`, `symbols`)

<span style="color:rgba(197, 148, 197, 1);">@param {instance} object - The object to be added to the scene</span>

<span style="color:rgba(197, 148, 197, 1);">@param {array} tags - List of tags to add to the object</span>

Internally used by scene when the compiler has finished gathering and building up the objects in the scene.

Handles the creation and destruction of the object. Creates a new entry in the sceneObjects array
to keep track of the object's state and index.

```lua
type ObjectReference = {
	Object: Instance | Rigidbody,
	ObjectJanitor: Janitor,
	Index: number,
	ShouldFlush: boolean?,
}
```

<br>

### .AddSymbols(`object`, `symbols`)


<span style="color:rgba(197, 148, 197, 1);">@param {GuiBase2D | Rigidbody} object</span>

<span style="color:rgba(197, 148, 197, 1);">@param {dictionary} symbols</span>

Used to attach symbols to an object. Used by `Scene.Add`.

Does not work with custom objects, due to symbols need to have the reference to the object to access data such as the object's Janitor.

<br>
  
### .Remove(`object`)

<span style="color:rgba(197, 148, 197, 1);">@param {instance} object - The object to get removed from the scene dictionary</span>

Removes the object from the scene without destroying it nor cleaning up the Janitor.

<br>

### .Flush(`ignoreShouldFlush`)

<span style="color:rgba(197, 148, 197, 1);">@param {boolean} ignoreShouldFlush - Whether Scene should delete objects that have ShouldFlush set to false</span>

Cleans up the scene and all of its objects if `ShouldFlush` is not false. This
behaviour can be changed by doing `Scene.Flush(true)`. This will result in Scene
ignoring the `ShouldFlush` symbol.

<br>

### .GetFromTag(`tag`)

<span style="color:rgba(197, 148, 197, 1);">@param {string} tag</span>

Returns all of the objects with the specified tag.

<br>

### .IsRigidbody(`object`)

<span style="color:rgba(197, 148, 197, 1);">@param {Instance | table} object - The object to check if it is a rigidbody</span>

Returns whether the given object is a Rigidbody or not.

<br>

### .GetObjectReference(`object`)

<span style="color:rgba(197, 148, 197, 1);">@param {GuiBase2d | Types.Rigidbody} object</span>

Returns the object's `ObjectReference` table used by Scene.

Useful to add custom events or logic to the object and making it sure
that, that event/logic gets disconnected upon destroying it.

Internally used by `Scene.AddSymbols()`

<br>

### .GetObjects()

Returns all of the objects wihin scene containing all of the `ObjectReferences`.