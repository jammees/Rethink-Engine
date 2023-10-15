---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Modules = Rethink.GetModules()
local Scene = Modules.Scene
local Symbols = Scene.Symbols
local Audio = Modules.Audio

-- cool music to listen to: rbxassetid://1845756489 :)
local mySound = Audio.Sound.new("rbxassetid://1845756489")
local myGlobalSound = Audio.Sound2D.new("rbxassetid://1845756489")

return {
	Name = "audio.scene",

	{
		[Symbols.Type] = "UIBase",

		MyObject = {
			Position = UDim2.fromScale(0.5, 0.5),
			[Symbols.Class] = "ImageButton",
			[Symbols.Event("MouseButton1Click")] = function(thisObject: ImageButton)
				-- myClickSound:PlayGlobal(function()
				-- 	return thisObject.AbsolutePosition
				-- end)
				myGlobalSound:Play(thisObject.AbsolutePosition)
			end,
			[Symbols.Event("MouseButton2Click")] = function()
				-- SoundPlayer.Play("9119713951")
				myGlobalSound:Stop()
			end,
		},
	},
}
