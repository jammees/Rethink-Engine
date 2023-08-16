Settings is a module made to put every configurable setting into one place. These settings get applied at the
start of the engine.

Every setting is categorized, depending on what purpose they have.

## Rendering

<hr>

In this category there are settings related to Rendering. Such as optimizing the rendering of
UI elements by culling them, disabling character loading or disabling 3D rendering.

### Disable3DRendering

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> Disable3DRendering `true`

__Disables 3D rendering by__

- Setting the camera FOV to 1
- Setting the camera type to scriptable
- Setting the camera's CFrame to 0

<br>

### DisablePlayerCharacters

<span class=def>:material-tag-outline: Since:</span> 0.5.3
<span class=def>:material-database-arrow-down-outline: Default:</span> DisablePlayerCharacters `true`

This setting disables the player characters, by deleting them locally.

<br>

### OptimizeLighting

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> OptimizeLighting `true`

__Optimizes lighting by__

- Ambient, ColorShift_Bottom, ColorShift_Top, OutdoorAmbient, FogColor to black
- Brightness to 0
- GlobalShadows to false
- ClockTime to 4
- GeographicLatitude to 0

<br>

### EnableCoreGuis

<span class=def>:material-tag-outline: Since:</span> 0.5.3

This setting is used to enable/disable core guis, to free up space or remove
unnecessary features. Such as chat, player list or the emotes menu.

__Default values__

- EmotesMenu (default: `false`)
- PlayerList (default: `false`)
- Backpack (default: `false`)
- Health (default: `false`)
- Chat (default: `false`)

<br>

### Prototypes

Prototypes are settings that are work in progress, unstable or unoptimized.
These settings are recommended to be kept at their default state.

__List of prototypes present in Rendering__

- CullGuiElements (default: `false`)
    - Culls out gui elements that are behind each other or out of the screen boundaries
    - **Status**: Unoptimized, at 2000 objects game lagged at unplayable rate every time an 
    object moved or scene was loaded

## Pool

<hr>

### InitialCache

<span class=def>:material-tag-outline: Since:</span> 0.6.0

This setting is used to determine how many should be created for each class present in the table.

__Default values__

- ImageLabel (default: `100`)
- TextLabel (default: `100`)
- TextButton (default: `50`)
- ImageButton (default: `50`)
- TextBox (default: `50`)
- ScrollingFrame (default: `5`)
- ViewportFrame (default: `5`)
- Frame (default: `100`)

<br>

### ExtensionSize

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> ExtensionSize `10`

Used when the pool runs out of the specified object. This setting determines how many should get
created to fill up the pool.

## Physics

<hr>

### Nature2D.QuadTreesEnabled 

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> QuadTreesEnabled `true`

Optimization regarding looking up rigidbodies in *Nature2D*

<br>

### Nature2D.CollisionIteration 

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> CollisionIteration `4`

How accure the collision detection should be.

!!! warning

    Higher values result in better collision detection, but at the price of performance!
    The default value is recommened by *Nature2D*

<br>

### Nature2D.ConstraintIteration 

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> CollisionIteration `3`

How accure the contraints should be.

!!! warning

    Higher values result in better contraints detection, but at the price of performance!
    The default value is recommened by *Nature2D*

## Console

<hr>

### LogHeader

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> LogHeader `true`

Determines if Rethink shoukd print it's header into the console.

<br>

### LogOnPropertyFail

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> LogOnPropertyFail `True`

Determines if the *Compiler* should notify in the console, if an unprocessable property was found.

## Uncategorized

<hr>

### CompilerChunkSize 

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> CompilerChunkSize `100`

How big should a chunk be, when using [TaskDistributor.GenerateChunk()](../taskdistributor/#taskdistributorgeneratechunkdata-chunksize).
This setting is used in the *Compiler*.

<br>

### ViewportColor

<span class=def>:material-tag-outline: Since:</span> 0.6.0
<span class=def>:material-database-arrow-down-outline: Default:</span> ViewportColor `R: 35, R: 68, B: 139`

The color of the viewport.