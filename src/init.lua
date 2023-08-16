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
Rethink.Self = script
Rethink.IsInitialized = false
Rethink.Version = script:WaitForChild("Version").Value

function Rethink.Init()
	if Rethink.IsInitialized then
		return Log.Warn(DebugStrings.RethinkInitialized)
	end

	Rethink.IsInitialized = true

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

	require(script.Bootstrap.EngineSettings)

	if Settings.Console.LogHeader == true then
		warn(DebugStrings.ConsoleHero:format(Rethink.Version))
	end

	return Rethink
end

function Rethink.GetModules()
	return {
		Collision = require(script.Modules.GuiCollisionService),
		Raycast = require(script.Modules.RayCast2),
		Animator = require(script.Modules.Animator),
		Outline = require(script.Modules.Outline),
		Scene = require(script.Modules.Scene),

		Physics = initNature2DClass,
		Template = Template,
		Ui = initEngineUi,
		Pool = initPool,

		Prototypes = {
			Camera = require(script.Modules.Camera),
		},
	}
end

return Rethink
