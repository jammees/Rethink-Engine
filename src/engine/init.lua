--[[

    RethinkEngine                                  
    @JamRBX (twitter)

    Credit goes to:
    @AstrealDev (devforum) for Roactive
    @jaipack17 (devforum) for Nature2D

]]

-- get tools
local isRunning = false
local components = script:WaitForChild("Components")
local tools = script:WaitForChild("Tools")

--// modules
local engine = nil
local setup = require(components.Setup)
local readOnly = require(components.ReadOnly)
local settings = require(components.Settings)
local roactive = require(components.Roactive)
local wrapper = require(components.Wrapper)
local exposedStates = roactive.State(setup()) -- setups ui and exposes it
local nature2D = require(tools.Physics)

if not isRunning then
	isRunning = true
	settings()

	-- initiate Nature2D
	engine = nature2D.init(exposedStates:Get().gameFrame)
	engine.canvas.frame = exposedStates:Get().canvas

	wrapper.giveData({
		Engine = engine,
		Ui = exposedStates:Get(),
	})
end

return readOnly({
	Physics = engine,
	--Rigid = require(tools.Rigid),
	Scene = require(tools.Scene),
	Inputs = require(tools.Inputs),
	Outline = require(tools.Outline),
	Template = require(tools.Template),
	Roactive = require(components.Roactive),

	Ui = exposedStates:Get(),

	isRunning = function()
		return isRunning
	end,
})
