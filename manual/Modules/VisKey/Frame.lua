local Fusion = require(script.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children

return function(props)
	return New("Frame")({
		BackgroundTransparency = 1,
		Size = props.Size,
		Name = props.Name or "Frame",
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder or 0,

		[Children] = props[Children] or {},
	})
end
