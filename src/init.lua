--[[
	Rethink
	Versatile, easy-to-use 2D game engine.

	MIT license
]]

local DebugStrings = require(script.Strings)
local Physics = require(script.Modules.Nature2D)
local Template = require(script.Modules.Template)
local Settings = require(script.Settings)
local ObjectPool = require(script.Library.ObjectPool)
local Log = require(script.Library.Log)

local initEngineUi = nil
local initNature2DClass = nil
local initPool = nil

local Rethink = {}

--[[
	A reference to the instance itself.

	@since 0.6.2
]]
Rethink.Self = script

--[[
	Tells whether Rethink was initialized or not.

	@since 0.6.2
	@readonly
]]
Rethink.IsInitialized = false

--[[
	Tells the current version of Rethink.

	@since 0.6.2
	@readonly
]]
Rethink.Version = script:WaitForChild("Version").Value

--[[
	Reference to the settings module for Rethink.
	After `.Init()` had been called, the settings
	can not be configured anymore.

	@since 0.6.3
]]
Rethink.Settings = Settings

--[[
	Initializes Rethink. This includes:

	- Setting up the game UI elements
	- Setting up the physics engine
	- Setting up global variables that can be accessed with `Template`

	After Rethink has initialized successfully it's header will get printed into the console.
	This behaviour can be configured in the `Settings` file under `Settings.Console.LogHeader`
	(true by default)

	@since 0.6.2
]]
function Rethink.Init()
	if Rethink.IsInitialized then
		return Log.Warn(DebugStrings.RethinkInitialized)
	end

	Rethink.IsInitialized = true

	Rethink.Settings = table.freeze(Settings)

	require(script.Bootstrap.EngineSettings)

	initEngineUi = require(script.Bootstrap.GenerateGUI)()

	initPool = ObjectPool.new(Settings.Pool.InitialCache)

	initNature2DClass = Physics.init(initEngineUi.GameFrame)
	initNature2DClass:UseQuadtrees(Settings.Physics.QuadTreesEnabled)
	initNature2DClass:SetCollisionIterations(Settings.Physics.CollisionIteration)
	initNature2DClass:SetConstraintIterations(Settings.Physics.ConstraintIteration)
	initNature2DClass:CreateCanvas(Vector2.new(0, 0), workspace.CurrentCamera.ViewportSize, initEngineUi.Viewport)

	Template.NewGlobal("__Rethink_Settings", Settings, true)
	Template.NewGlobal("__Rethink_Ui", initEngineUi, true)
	Template.NewGlobal("__Rethink_Pool", initPool, true)
	Template.NewGlobal("__Rethink_Physics", initNature2DClass, true)

	if Settings.Console.LogHeader == true then
		warn(DebugStrings.ConsoleHero:format(Rethink.Version))
	end

	return Rethink
end

--[[
	Returns the modules. Does not check whether if Rethink is initialized or not!

	__Warning__:
	Tools located in the `Prototypes` table are unstable or unfinished!
	such tools are highly unrecommended due to stability issues!

	@since 0.6.2
	@returns Modules `Dictionary`
]]
function Rethink.GetModules()
	return table.freeze({
		Collision = require(script.Modules.GuiCollisionService),
		Raycast = require(script.Modules.RayCast2),
		Animator = require(script.Modules.Animator),
		Outline = require(script.Modules.Outline),
		Scene = require(script.Modules.Scene),
		Sound = require(script.Modules.Sound),

		Physics = initNature2DClass,
		Template = Template,
		Ui = initEngineUi,
		Pool = initPool,

		Prototypes = {
			Camera = require(script.Modules.Camera),
		},
	})
end

return Rethink
