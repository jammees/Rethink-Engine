--[[

    Currently passed variables

    engine
    ui

]]

local saveData = nil

local wrapper = {}
wrapper.__index = wrapper

function wrapper.giveData(array: {})
	saveData = array
end

function wrapper.wrap()
	return setmetatable({
		-- modules
		Engine = saveData.Engine,

		-- ui
		GameFrame = saveData.Ui.gameFrame,
		RenderFrame = saveData.Ui.renderFrame,
		Canvas = saveData.Ui.canvas,
		Layer = saveData.Ui.layer,
		Hud = saveData.Ui.hud,
	}, wrapper)
end

return wrapper
