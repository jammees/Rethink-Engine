local Fusion = require(script.Parent.Fusion)
local New = Fusion.New

return function(props)
	return New("TextLabel")({
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextColor3 = Color3.fromRGB(241, 241, 241),
		Size = UDim2.new(0.5, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = props.Text,
		Name = props.Name or "Label",
		LayoutOrder = props.LayoutOrder or 0,
	})
end
