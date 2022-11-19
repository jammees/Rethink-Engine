local CompilerSceneData = {}
CompilerSceneData.Scene = nil

function CompilerSceneData:AddScene(scene)
	self.Scene = scene
end

function CompilerSceneData:GetData()
	local Type = self.Scene.Symbols.Type
	local Property = self.Scene.Symbols.Property

	return {
		Interactibles = {
			[Type] = "Layer",
			[Property] = {
				Class = "Frame",
				BackgroundColor3 = Color3.fromRGB(255, 125, 25),
				Transparency = 0.5,
			},

			["My_group"] = {
				[Property] = {
					BorderColor3 = Color3.fromRGB(0, 255, 0),
				},

				Box = {
					Class = "ImageButton",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(100, 100),
					Image = "rbxassetid://30115084",
				},

				HelloWorld = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.4, 0.5),
					Size = UDim2.fromOffset(100, 100),
				},
			},
		},
	}
end
