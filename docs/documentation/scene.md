Scene is the main part of Rethink, which makes working with Nature2D and in general working with UIs much more simpler and easier.
It provides a simple API which can load in dozens of objects if required into the game with ease.

!!! warning "Custom Rigidbodies"

	Scene currently does not support the use of custom
	rigidbodies!

<br>

## Properties

<hr>

### Symbols

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-book-cog-outline: Read-Only</span>

!!! danger

	Symbols __must__ be wrapped with `[ ]`! Reason is
	that without the `[ ]` lua would just treat the index as
	a simple string and not as a table.

	Symbols cannot be saved as locals! Reason is that symbols are
	automatically generated when indexing `Scene.Symbols` to make
	every instance of a symbol unique and prevent data loss by
	overriding another symbol.

Symbols are an easy way to add additional extra functionality to an
object. This feature was inspired by Fusion. Rethink allows the creation
of custom symbols. See: [Scene.RegisterCustomSymbol()](#registercustomsymbolname-returnkind-controller)

<hr>

__<p style="font-size:111%;">Tag</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> Tag(s) `String | {String}`

Gives object the specified tag(s) using CollectionService.
Can be retrieved using CollectionService or
[Scene.GetFromTag()](#getfromtagtag).

??? example

	```lua
	MyObject = {
		[Symbols.Tag] = "Hello world!"
	}
	```

	```lua
	local result1 = CollectionService:GetTagged("Hello world!")[1]
	local result2 = Rethink.Scene.GetFromTag("Hello world!")[1]

	print(result1 == result2) --> true
	```

	Results in the same object being returned. However, one key
	difference between CollectionService and GetFromTag
	is that GetFromTag returns the Rigidbody class whilst CollectionService
	would have just returned the gui instance (e.g. Frame) itself.

<br>

__<p style="font-size:111%;">Property</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> Properties `{[String | Symbol]: any}`

Adds properties and symbols to object. Mainly used in
containers.

??? example

	```lua
	MyContainer = {
		[Symbols.Property] = {
			Name = "Hello world!"
		},

		MyObject = {
			Name = "Something totally different!"
		}
	}
	```

	From the example above, it is a normal behaviour that MyObject's name
	property was applied instead of the property symbol's. The reason is the
	Compiler always prioritizes objects more than containers.

<br>

__<p style="font-size:111%;">Type</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> Type `String`

Tells the Compiler the type of the object: `UiBase` or `Rigidbody`.
Type symbols are defined in containers. If not present the Compiler
will throw a warning and default to `UIBase`!

??? example

	```lua
	MyContainer = {
		[Symbols.Type] = "Rigidbody"

		MyObject = {}
	}
	```

<br>

__<p style="font-size:111%;">Event</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> EventName `String`
<span class=def>:material-cog-outline: Parameter:</span> Callback `(Object) -> ()`

Listens to the given event, firing the provided callback
function with the object.

??? example

	```lua
	MyObject = {
		[Symbols.Event("MouseEnter")] = function(thisObject)
			print("Mouse entered", thisObject.Name)
		end,
	}
	```

<br>

__<p style="font-size:111%;">Permanent</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> Predicate `Boolean`

Tells Scene if object should get flushed, if value is set to true.
Symbol is ignored if ignorePermanent argument is set to
true in [Scene.Flush()](#flushignorepermanent).

??? example

	```lua
	MyObject = {
		[Symbols.Permanent] = true
	}
	```

	```lua
	Scene.Flush(false)
	```

	From the example above, it can be observed that MyObject
	has not been flushed, since Permanent was set to true
	and ignorePermanent was set to false. Resulting in the object 
	staying in the scene. Leaving ignorePermanent as nil works the same
	way!

<br>

__<p style="font-size:111%;">ShouldFlush</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> Predicate `Boolean`

!!! danger

	Renamed from ShouldFlush to Permanent for more clarity, since 0.6.2!

Tells Scene if object should get flushed, if value is set to false.
Symbol is ignored if `ignoreShouldFlush` argument is set to
true in [Scene.Flush()](#flushignorepermanent).

??? example

	```lua
	MyObject = {
		[Symbols.ShouldFlush] = false
	}
	```

	```lua
	Scene.Flush()
	```

	From the example above, it can be observed that MyObject
	has not been flushed, since ShouldFlush and ignoreShouldFlush are
	set to false. Resulting in the object staying in the scene.

<br>

__<p style="font-size:111%;">Rigidbody</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> Properties `{[String]: any}`

Adds Rigidbody properties to object. This symbol
has only affect to those who are under the
Type symbol configured to Rigidbody. The Object property is being
handled automatically.

[Rigidbody properties of Nature2D](https://jaipack17.github.io/Nature2D/docs/api/RigidBody#properties)

??? example

	```lua
	MyObject = {
		[Symbols.Rigidbody] = {
			Anchored = true
		}
	}
	```

	From the example above, once the physics simulation
	has been started the object wont move.

<br>

__<p style="font-size:111%;">LinkTag</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> Tag `String`

Adds a tag to object, which can be fetched using the
[LinkGet](#linkget) symbol.

??? example

	```lua
	MyObject = {
		[Symbols.LinkTag] = "Hello world!"
	}
	```

<br>

__<p style="font-size:111%;">LinkGet</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> Tag `String | { String }`
<span class=def>:material-cog-outline: Parameter:</span> Callback `(Object, ...) -> ()`

Gets all of the objects with the specified tag.
If the symbol has been applied during loading of the scene,
the execution will be delayed until [LoadFinished](#events) has been fired
else, when [ObjectAdded](#events) fires.

Accepts a tuple of strings or a string as a parameter. If
the given link name has more than one object tied to
it, it will return a tuple of the objects in the `Callback`
function. Otherwise, the object itself will get returned.

??? example

	## First example

	```lua
	MyObject = {
		[Symbols.LinkTag] = "Hello world!"
	},

	NamedAfterMyobject = {
		Name = "Something totally different!",

		[Symbols.LinkGet("Hello world!")] = function(thisObject, linkedObjects: { [number]: any }
			thisObject.Name = linkedObjects[1].Name
		end)
	}
	```

	From the example above, after the scene has finished loading `NamedAfterMyobject`
	will rename itself from "Something totally different!" to "MyObject".

	<br>

	## Second example

	```lua
	TextObject = {
		Text = "Something something...",

		[Symbols.LinkTag] = "text",
		[Symbols.Class] = "TextLabel",
	},

	ChildObject1 = {
		[Symbols.LinkTag] = "child",
	},

	ChildObject2 = {
		[Symbols.LinkTag] = "child",
	},

	ChildObject3 = {
		[Symbols.LinkTag] = "child",
	},

	MyObject = {
		[Symbols.Class] = "TextLabel",
		[Symbols.LinkGet({ "text", "child" })] = function(
			thisObject: TextLabel,
			text: TextLabel,
			childObjects: { Frame }
		)
			thisObject.Text = text.Text

			for _, object in childObjects do
				object.Parent = thisObject
			end
		end,
	},
	```

	<img src="../../assets/docs/link_get_tuple.png" align="left">

	The above example will result in MyObject's text being set to
	TextObject's text, while the ChildObject1-3's parent get set to
	MyObject's. To the left the result can be seen.

<br>

__<p style="font-size:111%;">Class</p>__

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> Type `String`

Tells the Compiler the class of the object (e.g. Frame).
If not present, will default to `Frame`!

??? example

	```lua
	MyTextLabel = {
		Text = "Hello world!",

		[Symbols.Class] = "TextLabel"
	}
	```

<br>

### IsLoading

<span class=warn>:material-alert-outline: Warning:</span> Deprecated since 0.6.2
<span class=def>:material-book-cog-outline: Read-Only</span>

IsLoading is a simple property which tells if the compiler is busy or not working on a scene.

<br>

### State

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-book-cog-outline: Read-Only</span>

Replacement for [IsLoading](#isloading).
Reports the current state of Scene:

- Loading
- Flushing
- Standby

<br>

### Events

<span class=def>:material-tag-outline: Since:</span> 0.5.3
<span class=def>:material-book-cog-outline: Read-Only</span>

Events are simple ways to run certain behaviour at certain times.

**List of all available events**

| Name:                     | Description:
| ------------------------- | ------------------------------------
| LoadStarted               | Fires before the scene gets loaded
| LoadFinished              | Fires after the scene got loaded
| FlushStarted              | Fires before the scene gets flushed/deleted
| FlushFinished             | Fires after the scene got flushed/deleted
| ObjectAdded               | Fires when an object got added to the scene, returns object
| ObjectRemoved             | Fires when an object got removed from the scene, returns object

## API

<hr>

### .Load(`sceneData`)

<span class=def>:material-tag-outline: Since:</span> 0.3.0
<span class=def>:material-cog-outline: Parameter:</span> sceneData `Dictionary`

Loads in a scene using the sceneData table. A name field must be provided, otherwise
it will default to "Unnamed scene", which could cause unintended behaviours.
The compiler does not check if a scene already exists with that name, meaning it will
overwrite it. It is a good practice to have each container's type defined, even if
it is supposed to be an `UIBase`! Otherwise, an error will be thrown!

Fires [LoadStarted](#events) and [LoadFinished](#events).

??? example

    ```lua
    return {
		Name = "My scene",

		My_Container = {
			[Type] = "UIBase",
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

<br>

### .Add(`object`, `symbols`)

<span class=def>:material-tag-outline: Since:</span> 0.5.3
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`
<span class=def>:material-cog-outline: Parameter:</span> symbols `{[Symbol]: any}`

Internally used by scene when the compiler has finished gathering and building up the 
objects in the scene. Sets up a cleanup method for the object, creates a new entry 
in the sceneObjects array saving an `ObjectReference` table associated with
the object and calls [Scene.AddSymbols()](#addsymbolsobject-symbols).

Fires [ObjectAdded](#events).

```lua
type ObjectReference = {
	Object: GuiObject | Rigidbody,
	Janitor: Janitor,
	SymbolJanitor: Janitor?,
	ID: string,
	Symbols: {
		IDs: { UUID },
		ShouldFlush: boolean?,
		LinkIDs: { string }
	}?,
}
```

<br>

### .AddSymbols(`object`, `symbols`)

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`
<span class=def>:material-cog-outline: Parameter:</span> symbols `{[Symbol]: any}`

Attaches symbols to an object. Used by [Scene.Add()](#addobject-symbols).
Does not support custom objects, due to symbols need to have the reference to 
the object to access data such as the object's Janitor.

<br>
  
### .Remove(`object`, `stripSymbols`)

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`
<span class=def>:material-cog-outline: Parameter:</span> stripSymbols `Boolean`
<span class=def>:material-database-arrow-down-outline: Default:</span> stripSymbols `false`

Removes the object from the scene without destroying it nor cleaning up the Janitor.
If stripSymbols is set to true it will cleanup the symbols.

Fires [ObjectRemoved](#events).

<br>

### .Cleanup(`object`)

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`

Cleans up the provided object.

<br>

### .Flush(`ignorePermanent`)

<span class=def>:material-tag-outline: Since:</span> 0.5.3
<span class=def>:material-cog-outline: Parameter:</span> ignorePermanent `Boolean`
<span class=def>:material-database-arrow-down-outline: Default:</span> ignorePermanent `false`

Cleans up all of the objects in the scene if called. If ignorePermanent is set to true Scene will ignore objects which have the Permanent symbol attached with the value
of true.

<br>

### .RegisterCustomSymbol(`name`, `returnKind`, `controller`)

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-cog-outline: Parameter:</span> name `string`
<span class=def>:material-cog-outline: Parameter:</span> returnKind `number`
<span class=def>:material-cog-outline: Parameter:</span> controller `(object, symbol) -> ()`

Registers a new custom symbol handler. The returnKind parameter accepts:

- 0 - Returns the symbol
- 1 - Returns a function, when called returns the symbol

!!! example

	This example prints the object's ID and the attached value of the symbol.

	```lua
	Scene.RegisterCustomSymbol("testSymbol", 0, function(object, symbol)
		print(object.ID, symbol.SymbolData.Attached)
	end)
	```

<br>

### .GetFromTag(`tag`)

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> tag `String`
<span class=def>:material-keyboard-return: Returns:</span> Objects `{[number]: GuiBase2d | Types.Rigidbody}`

Returns all of the objects with the specified tag.

<br>

### .IsRigidbody(`object`)

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`
<span class=def>:material-keyboard-return: Returns:</span> Result `Boolean`

Returns a boolean to indicate if object is a rigidbody or not.

<br>

### .GetObjectReference(`object`)

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`
<span class=def>:material-keyboard-return: Returns:</span> Reference `ObjectReference`

Returns the object's ObjectReference table used by Scene.

Useful to add custom events or logic to the object and making it sure
that, that event/logic gets disconnected upon the destruction of the object.

Internally used by [Scene.AddSymbols()](#addsymbolsobject-symbols).

<br>

### .GetObjects()

<span class=def>:material-tag-outline: Since:</span> 0.5.3
<span class=def>:material-keyboard-return: Returns:</span> Objects `{ [Types.UUID]: ObjectReference }`

Returns all of the objects wihin scene containing all of the `ObjectReferences`.