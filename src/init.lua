--[[
	Rethink
	Versatile, easy-to-use 2D game engine.

	@james_mc98
	Version: 0.6.0

	MIT license
]]

local components = script.Components
local tools = script.Tools
local core = tools.Core
local environment = tools.Environment
local utility = tools.Utility

local DebugStrings = require(components.Debug.Strings)
local Physics = require(environment.Physics)
local Template = require(utility.Template)
local Settings = require(script.Settings)
local ObjectPool = require(components.Library.ObjectPool)

-- These are values that will get exported with the rest of the modules after
-- The engine was fully intitialized
local engineStarted = false
local engineUi = nil
local physicsClass = nil
local pool = nil

if not engineStarted then
	engineStarted = true

	-- setup core game ui
	engineUi = require(components.Bootstrap.GenerateGUI)()

	-- Initiate some globals that other components/tools can have access to
	-- These are mainly exists for the sole purpose of quality of life benefits
	Template.NewGlobal("__Rethink_Settings", Settings, true)
	Template.NewGlobal("__Rethink_Ui", engineUi, true)

	-- Setting up UI pool for Scene
	pool = ObjectPool.new(Settings.Pool.InitialCache)
	Template.NewGlobal("__Rethink_Pool", pool, true)

	-- initiate Nature2D
	physicsClass = Physics.init(engineUi.GameFrame)

	-- Apply settings
	-- More in-depth explanation can be found in the Settings module
	physicsClass:UseQuadtrees(Settings.Physics.QuadTreesEnabled)
	physicsClass:SetCollisionIterations(Settings.Physics.CollisionIteration)
	physicsClass:SetConstraintIterations(Settings.Physics.ConstraintIteration)

	-- Initiate a canvas
	-- This is basically unnecessary if KeepInCanvas is always false
	physicsClass:CreateCanvas(Vector2.new(0, 0), workspace.CurrentCamera.ViewportSize, engineUi.Viewport)

	-- Create a new global to get access to the now initialized Nature2D class
	Template.NewGlobal("__Rethink_Physics", physicsClass, true)

	-- Apply engine settings and optimizations
	-- After everything has been initialized
	require(components.Bootstrap.EngineSettings)

	-- Print header into the console if the LogHeader flag is enabled
	if Settings.Console.LogHeader == true then
		warn(DebugStrings.ConsoleHero)
	end
end

return {
	Collision = require(environment.Collision),
	Raycast = require(environment.Raycast),
	Animation = require(core.Animation),
	Outline = require(utility.Outline),
	Scene = require(core.Scene),
	Physics = physicsClass,
	Template = Template,
	Ui = engineUi,
	Pool = pool,

	-- Expose the paths for easier access
	Components = components,
	Tools = tools,

	-- Unfinsished, unstable tools
	Prototypes = {
		Camera = require(core.Camera),
	},
}
