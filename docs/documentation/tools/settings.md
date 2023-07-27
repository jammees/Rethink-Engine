# Settings

Settings is a module made to put every configurable setting into one place. These settings get applied at the
start of the engine.

Every setting is categorized, depending on what purpose they have.

<br>

## Rendering

In this category there are settings related to Rendering. Such as optimizing the rendering of
UI elements by culling them, disabling character loading or disabling 3D rendering.

### Disable3DRendering

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `true`

<hr>

Default value: `true`

__Mostly disables 3D rendering by__

- Setting the camera FOV to 1
- Setting the camera type to scriptable
- Setting the camera's CFrame to 0

### DisablePlayerCharacters

:octicons-tag-16:{ .tag } Since: **0.5.3** | 
:material-cog:{ .tag } Default: `true`

<hr>

Default value: `true`

This setting disables the player characters, by deleting them locally.

### OptimizeLighting

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `true`

<hr>

Default value: `true`

__This setting optimizes lighting and makes the sky color to dark blue by changing__

- Ambient, ColorShift_Bottom, ColorShift_Top, OutdoorAmbient, FogColor to black
- Brightness to 0
- GlobalShadows to false
- ClockTime to 4
- GeographicLatitude to 0

### EnableCoreGuis

:octicons-tag-16:{ .tag } Since: **0.5.3**

<hr>

This setting is used to enable/disable core guis, to free up space or remove
unnecessary features. Such as chat, player list or the emotes menu.

__Default values__

- EmotesMenu (default: `false`)
- PlayerList (default: `false`)
- SelfView (default: `false`)
- Backpack (default: `false`)
- Health (default: `false`)
- Chat (default: `false`)

### Prototypes

Prototypes are settings that are work in progress, unstable or unoptimized.
These settings are recommended to be kept at their default state.

__List of prototypes present in Rendering__

- CullGuiElements (default: `false`)
    - Culls out gui elements that are behind each other or out of the screen boundaries
    - **Status**: Unoptimized, at 2000 objects game lagged at unplayable rate every time an 
    object moved or scene was loaded
- Prototype_GuiCulling_v2 (default: `false`)
    - Same as CullGuiElements but it will use a better algorithm as well as to utilize *TaskDistributor*
    - **Status**: Work in progress, unusable at the moment

<br>

## Pool

### InitialCache

:octicons-tag-16:{ .tag } Since: **0.6.0**

<hr>

This setting is used to determine how many should be created for each class present in the table.

__List of all of the default values__

- ImageLabel (default: `100`)
- TextLabel (default: `100`)
- TextButton (default: `50`)
- ImageButton (default: `50`)
- TextBox (default: `50`)
- ScrollingFrame (default: `5`)
- ViewportFrame (default: `5`)
- Frame (default: `100`)

!!! info

    How the *UiPool* is structured and reads this setting, it it possible to add additional classes such as parts.

### ExtensionSize

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `10`

<hr>

Used when the pool runs out of the specified object. This setting determines how many should get
created to fill up the pool.

<br>

## Physics

### Nature2D.QuadTreesEnabled 

:octicons-tag-16:{ .tag } Since: **0.6.3** | 
:material-cog:{ .tag } Default: `true`

<hr>

Optimization regarding looking up rigidbodies in *Nature2D*

### Nature2D.CollisionIteration 

:octicons-tag-16:{ .tag } Since: **0.6.3** | 
:material-cog:{ .tag } Default: `4`

<hr>

How accure the collision detection should be.


!!! warning

    Higher values result in better collision detection, but at the price of performance!

    The default value is recommened by *Nature2D*

### Nature2D.ConstraintIteration 

:octicons-tag-16:{ .tag } Since: **0.6.3** | 
:material-cog:{ .tag } Default: `3`

<hr>

How accure the contraints should be.

!!! warning

    Higher values result in better contraints detection, but at the price of performance!

    The default value is recommened by *Nature2D*

<br>

## Console

### LogHeader

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `true`

<hr>

Determines if Rethink shoukd print it's header into the console.

### LogOnPropertyFail

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `true`

<hr>

Determines if the *Compiler* should notify in the console, if an unprocessable property was found.

<br>

## Uncategorized

### CompilerChunkSize 

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `100`

<hr>

How big should a chunk be, when using `TaskDistributor.GenerateChunk()`.
This setting is used in the *Compiler*.

### ViewportColor

:octicons-tag-16:{ .tag } Since: **0.6.0** | 
:material-cog:{ .tag } Default: `r: 35, g: 68, b: 139`

The color of the viewport.