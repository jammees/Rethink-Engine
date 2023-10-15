---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols
local Sound = Rethink.GetModules().Sound

local talkSound = Sound.new("rbxassetid://3620844678", {
	Loop = true,
})

local backgroundMusic = Sound.new("rbxassetid://1845756489", {
	Loop = true,
	Volume = 0.7,
})

return {
	Name = "sound.scene",

	{
		[Symbols.Type] = "UIBase",

		ToggleButton = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.7),
			Text = "Toggle sounds",

			[Symbols.Class] = "TextButton",
			[Symbols.LinkGet({ "talk", "music" })] = function(thisObject: TextButton, talk: Frame, music: Frame)
				local playSounds = false

				Scene.GetSceneObjectFrom(thisObject).Janitor:Add(thisObject.MouseButton1Click:Connect(function()
					playSounds = not playSounds

					if playSounds then
						talkSound:PlayGlobal(talk.AbsolutePosition)
						backgroundMusic:PlayGlobal(music.AbsolutePosition)
					else
						talkSound:Stop()
						backgroundMusic:Stop()
					end
				end))
			end,
		},

		talk = {
			Position = UDim2.fromScale(0.1, 0.5),
			[Symbols.LinkTag] = "talk",
		},

		music = {
			Position = UDim2.fromScale(0.7, 0.5),
			[Symbols.LinkTag] = "music",
		},
	},
}
