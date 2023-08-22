<hr>

## Update: 0.6.2
- Removed debug prints left in on accident
- Rename type `UiBase` to `UIBase`
- Documentation site improvements
- Removed support of the `Type` symbol having aliases
- Added `Symbols.RegisterCustomSymbol()` function to create custom symbols more easily
- Added wrapper function in Scene for `Symbols.RegisterCustomSymbol()`
- Fixed spelling mistakes
- Removed deprecated RDC runner script
- Fixed Rethink throwing errors if `Rethink.GetModules()` was called before it's initialized
- Updated warnings in Template, Scene
- Added `Scene.Cleanup()`
- Fixed bug relating to Pool not returning the correct object
- Moved `Scene.Events.ObjectRemoved` invoking to object's cleanup method
- Replaced .IsLoading to .State to indicate the states that scene is in, such as: Loading, Flushing, Standby
- Removed Scene throwing a warning in `.Flush()` was called, when the scene is empty
- Added `LinkTag` and `LinkGet` symbols to reference other objects in the scene module
- Cleaned up Symbols module, separation of each handler into its own module
- Updates docs of `Scene` to match current state
- Scene no longer returns a Promise when `.Load` is called
- Renamed back 3rd party modules to their original names
- Renamed Animation back to Animator
- Fixed error regarding not formatting objects correctly when throwing errors
- Scene now exports `ObjectReference` type
- Removed SelfView, CompilerChunkSize from settings
- Added Class symbol to define object ClassNames
- Utilize gitmodules to track third party libraries
- Symbols now return `visual object`s (e.g. Frame)
- Object's reference table is now initially set up with symbol handling
- Rewritten `Scene.Remove()` to use `Scene.GetObjectReference()` internally
- Rewritten `Scene.Flush()`, `Scene.Load()` to stop using `TaskDistributor`
- Use promise in symbol handlers to catch warnings to prevent code halting
- Fixed memory-leak when removing objects using `Scene.Remove()`
- Removed `TaskDistributor`
- Renamed ShouldFlush to Permanent
- Built-in symbols now do type-checking
- Reworked messages and logging using `Log` library
- Add missing documentation for the main module (init.lua)
- Fixed inconsistencies with types not being capitalized sometimes
- Add `Children` symbol
- Make `ObjectPool` create new instances if the specified kind does not exist
- `ObjectPool` now only resets objects that are `GuiBase2d`

## Update: 0.6.1
- Fixed objects not being removed completely
- Rewritten ObjectPool
- Added new argument `stripSymbols` to `.Remove`
- Symbols are now being tracked with their own IDs
- Symbols have their own Janitor now
- Fixed documentation
- Symbols now use `.Symbols` table to store data instead of using the object's reference table directly
- Fixed symbols staying on objects after flushed or removed
- Added `.Init` and `.GetModules` function to Rethink
- Restructure of engine internals

## Update: 0.6.0
* Added aliases to the **Type** symbol:
    - Layer `UiBase`
	- Static `UiBase`
	- Dynamic `Rigidbody`
* Deployed documentation
* Added pin_game.md to request your game getting pinned on the landing page as an example
* Introduced TaskDistributor
* Optimized Scene `Flush` and `Load`
* Refactoring, as well as removing `Utils`
* Fix `Physics` now automatically rescaling canvas, if viewport's size changed
* Simplifed UI hierarchy
    - GameFrame
	- RenderFrame
	- Viewport
	- Ui
* Introduced UiPool to try and minimize the rapid creation and deletion of objects
* Introduced Settings, where you can customize features to your likings
* Introduced `Prototypes`, that can be accessed with `Rethink.Prototypes`
* Now `Components` and `Tools` can be accessed with Rethink for quality-of-life
* Optimizations regarding `Rendering`
* Prototype `Culling` feature, to attempt to optimize heavy object scenarios
* Restructured code into three different categories:
    - **Core**: The main deal of Rethink, modules made by me and are necessary
    - **Environment**: Modules created by `jaipack17` regarding physics and collisions
    - **Utility**: Smaller modules that are expected to be used less often than `Core` ones
* Introduced `Animation` a new animation module for `Spritesheets` and `Set of images`
* Removed being able to use custom `Protocol` modules, due to it just adding more complexity
* Made `Scene.GetBodyFromTag` into a single function
* Introduced Symbols that can be used in `Scene files`
    - **Tag**: Gives the given object a `tag(s)` fetch it with `CollectionService` or `Scene:GetRigidbodyFromTag`
    - **Property**: Applies `properties` or `symbols` to objects in the `group` or the `container`
    - **Type**: How the compiler handles the object `UiBase` and `Rigidbody`
    - **Children**: Add objects that are parented to the given object
    - **Event**: Hook events to the given object
    - **DAF**: Determines if the object will get deleted on `.Flush()` (Delete After Flush)
    - **Rigidbody**: Add rigidbody properties that later get fed into the Physics engine
* Switched from using `Wrapper` to instead using `Template` to pass on classes
* Replaced `:` with `.` where `Wrapper` was used
* Added documentation for functions (as well as JSDoc here and there)
* Added `Scene.IsRigidbody` for identifying rigidbodies easier
* Added `Default properties` to objects when compiling objects
* Introduced `Template`, a simple global data holder
* Removed `ReadOnly`
* Added `Strings` for editing throw messages, header easier
* Cleaned up `GenerateGUI`
* A Dev place has been made available to see my progress on the engine [Click here to view!](https://www.roblox.com/games/11693314673/Rethink-Engine-Dev-Place)
* Introduced `TypeCheck`
* Lot of code refactoring
* Unit test for `TaskDistributor`
* Removed the `Input` library
* Created new logo for Rethink
* Added github issue templates
* Moved actual engine code into `src`

!!! info "For upcoming updates:"

    - Add Rethink to `Wally`
    - Create a lite version of Rethink
    - Finish development of RePreview
    - Create an example game
    - Update GitHub page more frequently :)

## Update: 0.5.3
* Updated physics (Nature2D) to V: 0.6.0
* Added scene:GetRigidbodyFromTag() and scene:GetRigidbodiesFromTag()
* idk

## Update: 0.5.2
* Updated physics (Nature2D) to V: 0.5.4
* Added `Outline`
* Reverted function's first letter to lowercase
* Added `Gamepad` to inputs
* Added `fixedRot` and `fixedPos` to rigidbodies

## Update: 0.4.1
* Made functions' first letter uppercase and the rest lowercase
* Made module names more consistent with eachother

## Update: 0.4.0
* Added `current` to inputs
* Added `Template` to tools

## Update: 0.3.0
* Added scene manager
* Added test folder

## Update: 0.2.0
* Added utility functions for rigid bodies

## Update: 0.1.0
* Inital release