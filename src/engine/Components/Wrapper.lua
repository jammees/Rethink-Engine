--[[

    Currently passed variables

    engine
    ui

]]

local saveData = {}

local wrapper = {}
wrapper.__index = wrapper

function wrapper.GiveData(array: { [string]: any })
	saveData = array
end

function wrapper.Wrap()
	return setmetatable({
		-- modules
		Engine = saveData.Engine,

		-- ui
		GameFrame = saveData.Ui.GameFrame,
		RenderFrame = saveData.Ui.RenderFrame,
		Canvas = saveData.Ui.Canvas,
		Layer = saveData.Ui.Layer,
		Ui = saveData.Ui.Ui,
		CameraCont = saveData.Ui.CameraCont,
	}, wrapper)
end

return wrapper
