--[[
	 ____      _   _     _       _      _____             _            
	|  _ \ ___| |_| |__ (_)_ __ | | __ | ____|_ __   __ _(_)_ __   ___ 
 	| |_) / _ \ __| '_ \| | '_ \| |/ / |  _| | '_ \ / _` | | '_ \ / _ \
	|  _ <  __/ |_| | | | | | | |   <  | |___| | | | (_| | | | | |  __/
	|_| \_\___|\__|_| |_|_|_| |_|_|\_\ |_____|_| |_|\__, |_|_| |_|\___|
	                                                |___/                                     
	Version: 0.6.0
	@james_mc98 (devforum)
	
    Credit goes to:
    @jaipack17 (devforum) for Nature2D and GuiCollisionService

]]

local PRINT_HEADER = true

-- get tools
local isRunning = false
local components = script:WaitForChild("Components")
local tools = script:WaitForChild("Tools")

--// modules
local setup = require(components.Setup)
local readOnly = require(components.ReadOnly)
local settings = require(components.Settings)
local wrapper = require(components.Wrapper)
local nature2D = require(tools.Physics)

local engine = nil

local coreInterface = setup() -- setups core user interfaces

if not isRunning then
	isRunning = true
	settings()

	-- initiate Nature2D
	engine = nature2D.init(coreInterface.GameFrame)
	engine.canvas.frame = coreInterface.Canvas

	wrapper.GiveData({
		Engine = engine,
		Ui = coreInterface,
	})

	if PRINT_HEADER then
		warn([[
		
			 ____      _   _     _       _      _____             _            
			|  _ \ ___| |_| |__ (_)_ __ | | __ | ____|_ __   __ _(_)_ __   ___ 
			| |_) / _ \ __| '_ \| | '_ \| |/ / |  _| | '_ \ / _` | | '_ \ / _ \
			|  _ <  __/ |_| | | | | | | |   <  | |___| | | | (_| | | | | |  __/
			|_| \_\___|\__|_| |_|_|_| |_|_|\_\ |_____|_| |_|\__, |_|_| |_|\___|
			                                                |___/              

			Version: 0.6.0

			@james_mc98 (devforum)
			@jaipack17 (devforum) for Nature2D and GuiCollisionService
			Validark and HowManySmall for Janitor
		]])
	end
end

return readOnly({
	Physics = engine,
	Scene = require(tools.Scene),
	Inputs = require(tools.Inputs),
	Outline = require(tools.Outline),
	Template = require(tools.Template),
	Camera = require(tools.Camera),
	Collision = require(tools.Collision),

	Ui = coreInterface,

	--[[Deprecated
		isRunning = function()
			return isRunning
		end,
	]]
})
