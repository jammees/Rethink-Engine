---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols
local Sound = Rethink.GetModules().Sound

local myClickSound = Sound.new("rbxasset://sounds\\clickfast.wav", {
	Loop = true,
})

return {
	Name = "sound.scene",

	{
		[Symbols.Type] = "UIBase",

		MyObject = {
			Position = UDim2.fromScale(0.5, 0.5),
			[Symbols.Class] = "ImageButton",
			[Symbols.Event("MouseButton1Click")] = function(thisObject: ImageButton)
				-- SoundPlayer.Play("9119713951")
				-- myClickSound:PlayGlobal(thisObject.AbsolutePosition)
				myClickSound:PlayGlobal(function()
					return thisObject.AbsolutePosition
				end)
			end,
			[Symbols.Event("MouseButton2Click")] = function()
				-- SoundPlayer.Play("9119713951")
				myClickSound:Stop()
			end,
		},
	},
}
