--[[
	
     ____      _   _     _       _       _____             _            
    |  _ \ ___| |_| |__ (_)_ __ | | __  | ____|_ __   __ _(_)_ __   ___ 
    | |_) / _ \ __| '_ \| | '_ \| |/ /  |  _| | '_ \ / _` | | '_ \ / _ \
    |  _ <  __/ |_| | | | | | | |   <   | |___| | | | (_| | | | | |  __/
    |_| \_\___|\__|_| |_|_|_| |_|_|\_\  |_____|_| |_|\__, |_|_| |_|\___|
                                                     |___/              
    
    Version: 0.6.0 indev
    james_mc98
    
    Thanks to:
    jaipack17 for Nature2D / GuiCollisionService / RayCast2
    Brownsage for helping with Camera
    sleitnick for Symbol
	evaera for Promise
	Validark and HowManySmall for Janitor

]]

-- variables
local components = script.Components
local tools = script.Tools
local core = tools.Core
local environment = tools.Environment
local utility = tools.Utility

local PhysicsClass = nil

local isStarted = false
local engineUi = nil

-- modules
--local Settings = require(components.Bootstrap.EngineSettings)
local Strings = require(components.Debug.Strings)
--local Wrapper = require(components.Wrapper)
local Physics = require(environment.Physics)
local Template = require(utility.Template)

if not isStarted then
	isStarted = true

	-- setup core game ui and apply the settings
	engineUi = require(components.Bootstrap.SetupUi)()

	-- initiate Nature2D
	PhysicsClass = Physics.init(engineUi.GameFrame)
	PhysicsClass:CreateCanvas(Vector2.new(0, 0), workspace.CurrentCamera.ViewportSize, engineUi.Canvas)

	Template.NewGlobal("__Rethink_Settings", require(components.Bootstrap.EngineSettings.Settings), true)
	Template.NewGlobal("__Rethink_Physics", PhysicsClass, true)
	Template.NewGlobal("__Rethink_Ui", engineUi, true)

	require(components.Bootstrap.EngineSettings)

	if Template.FetchGlobal("__Rethink_Settings").Console.LogHeader == true then
		warn(Strings.ConsoleHero)
	end
end

return {
	Collision = require(environment.Collision),
	Raycast = require(environment.Raycast),
	Outline = require(utility.Outline),
	Scene = require(core.Scene),
	Physics = PhysicsClass,
	Template = Template,

	Ui = engineUi,

	-- Unfinsished, unstable tools
	Prototypes = {
		Camera = require(core.Camera),
		Inputs = require(utility.Inputs),
	},
}
