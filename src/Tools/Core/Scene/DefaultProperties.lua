--[[
	This is a list of all of the default properties.
	This was painfully written by hand.
]]

local BASE_PROPERTIES = {
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	Size = UDim2.fromOffset(100, 100),
	BorderSizePixel = 0,
	SelectionImageObject = nil,
	AnchorPoint = Vector2.new(),
	AutomaticSize = Enum.AutomaticSize.None,
	BackgroundTransparency = 0,
	LayoutOrder = 0,
	Archivable = true,
	Rotation = 0,
	SizeConstraint = Enum.SizeConstraint.RelativeXY,
	Visible = true,
	ZIndex = 1,
	ClipsDescendants = false,
	AutoLocalize = true,
	RootLocalizationTable = nil,
	NextSelectionDown = nil,
	NextSelectionUp = nil,
	NextSelectionLeft = nil,
	NextSelectionRight = nil,
	Selectable = false,
	SelectionGroup = false,
	SelectionOrder = 0,
	Active = true,
}

-- Defines most of the proprties
local function Override(overwrites: { [string]: any })
	local properties = table.clone(BASE_PROPERTIES)

	for propertyName, value in pairs(overwrites) do
		properties[propertyName] = value
	end

	return properties
end

return {
	Frame = Override({
		Name = "Frame",
	}),

	ViewportFrame = Override({
		Name = "ViewportFrame",
		Ambient = Color3.fromRGB(200, 200, 200),
		LightColor = Color3.fromRGB(140, 140, 140),
		LightDirection = Vector3.new(-1, -1, -1),
		Active = false,
		CurrentCamera = nil,
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ImageTransparency = 0,
	}),

	ImageButton = Override({
		Name = "ImageButton",
		AutoButtonColor = true,
		Modal = false,
		HoverImage = nil,
		Image = nil,
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ImageRectOffset = Vector2.new(),
		ImageRectSize = Vector2.new(),
		ImageTransparency = 0,
		PressedImage = nil,
		ResampleMode = Enum.ResamplerMode.Default,
		ScaleType = Enum.ScaleType.Stretch,
		Selectable = true,
	}),

	ImageLabel = Override({
		Name = "ImageLabel",
		Image = nil,
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ImageRectOffset = Vector2.new(),
		ImageRectSize = Vector2.new(),
		ImageTransparency = 0,
		ResampleMode = Enum.ResamplerMode.Default,
		ScaleType = Enum.ScaleType.Stretch,
	}),

	ScrollingFrame = Override({
		Name = "ScrollingFrame",
		ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
		ClipsDescendants = true,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		CanvasPosition = Vector2.new(),
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		ScrollBarImageTransparency = 0,
		ScrollBarThickness = 6,
		ScrollingDirection = Enum.ScrollingDirection.XY,
		HorizontalScrollBarInset = Enum.ScrollBarInset.None,
		VerticalScrollBarInset = Enum.ScrollBarInset.None,
		VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
	}),

	TextBox = Override({
		Font = Enum.Font.SourceSans,
		PlaceholderColor3 = Color3.fromRGB(29, 29, 29),
		PlaceholderText = "",
		TextScaled = false,
		TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
		TextStrokeTransparency = 1,
		TextTransparency = 0,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		ClearTextOnFocus = true,
		CursorPosition = 1,
		MultiLine = false,
		SelectionStart = -1,
		ShowNativeInput = true,
		TextEditable = true,
		RichText = false,
		LineHeight = 1,
		MaxVisibleGraphemes = -1,
		Selectable = true,
		Name = "TextBox",
	}),

	TextButton = Override({
		Name = "TextButton",

		Font = Enum.Font.SourceSans,
		TextScaled = false,
		TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
		TextStrokeTransparency = 1,
		TextTransparency = 0,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		LineHeight = 1,
		MaxVisibleGraphemes = -1,
		RichText = false,
		Selectable = true,

		AutoButtonColor = true,
	}),

	TextLabel = Override({
		Name = "TextLabel",

		Font = Enum.Font.SourceSans,
		TextScaled = false,
		TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
		TextStrokeTransparency = 1,
		TextTransparency = 0,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		LineHeight = 1,
		MaxVisibleGraphemes = -1,
		TextSize = 14,
		RichText = false,
		Selectable = true,
	}),
}
