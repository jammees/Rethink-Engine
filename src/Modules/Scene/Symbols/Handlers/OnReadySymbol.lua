local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)
local SceneObject = require(script.Parent.Parent.Parent.SceneObject)

return function(object: SceneObject.SceneObject, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.callback(symbol.SymbolData.Attached))

	local Scene = require(script.Parent.Parent.Parent)

	local loadFinishedSignal
	loadFinishedSignal = Scene.Events.LoadFinished:Connect(function()
		loadFinishedSignal:Disconnect()

		symbol.SymbolData.Attached(object.Object)
	end)
end
