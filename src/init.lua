--[[
	Rethink
	Versatile, easy-to-use 2D game engine.

	MIT license
]]

local DebugStrings = require(script.Strings)
local Physics = require(script.Modules.Physics)
local Template = require(script.Modules.Template)
local Settings = require(script.Settings)
local ObjectPool = require(script.Library.ObjectPool)

local initEngineUi = nil
local initPhysicsClass = nil
local initPool = nil

local Rethink = {}
Rethink.Self = script
Rethink.IsInitialized = false
Rethink.Version = script:WaitForChild("Version").Value

function Rethink.Init()
	if Rethink.IsInitialized then
		return warn("Already initialized!")
	end

	Rethink.IsInitialized = true

	initEngineUi = require(script.Bootstrap.GenerateGUI)()

	initPool = ObjectPool.new(Settings.Pool.InitialCache)

	initPhysicsClass = Physics.init(initEngineUi.GameFrame)
	initPhysicsClass:UseQuadtrees(Settings.Physics.QuadTreesEnabled)
	initPhysicsClass:SetCollisionIterations(Settings.Physics.CollisionIteration)
	initPhysicsClass:SetConstraintIterations(Settings.Physics.ConstraintIteration)
	initPhysicsClass:CreateCanvas(Vector2.new(0, 0), workspace.CurrentCamera.ViewportSize, initEngineUi.Viewport)

	Template.NewGlobal("__Rethink_Settings", Settings, true)
	Template.NewGlobal("__Rethink_Ui", initEngineUi, true)
	Template.NewGlobal("__Rethink_Pool", initPool, true)
	Template.NewGlobal("__Rethink_Physics", initPhysicsClass, true)

	require(script.Bootstrap.EngineSettings)

	if Settings.Console.LogHeader == true then
		warn(DebugStrings.ConsoleHero:format(Rethink.Version))
	end

	return Rethink
end

function Rethink.GetModules()
	return {
		Collision = require(script.Modules.Collision),
		Raycast = require(script.Modules.Raycast),
		Animation = require(script.Modules.Animation),
		Outline = require(script.Modules.Outline),
		Scene = require(script.Modules.Scene),

		Physics = initPhysicsClass,
		Template = Template,
		Ui = initEngineUi,
		Pool = initPool,

		Prototypes = {
			Camera = require(script.Modules.Camera),
		},
	}
end

return Rethink
