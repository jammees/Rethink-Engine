type ImageData = {
	Id: string,
	Offset: Vector2,
	Size: Vector2,
}

local Fusion = require(script.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local Frame = require(script.Parent.Frame)
local Label = require(script.Parent.Label)
local ImageMap = require(script.Parent.ImageMap)

local function ConvertEnumToIndex(key: Enum.KeyCode)
	return string.split(tostring(key), ".")[3]
end

local function FetchKeyData(key: Enum.KeyCode)
	for _, category in pairs(ImageMap) do
		for index, vector in pairs(category) do
			if index == ConvertEnumToIndex(key) then
				return { Id = category.ImageId, Offset = vector, Size = Vector2.new(100, 100) }
			end
		end
	end

	return { Id = "rbxassetid://3926305904", Vector = Vector2.new(364, 324) }
end

return function(props)
	local imageData: ImageData = FetchKeyData(props.Key)

	return Frame({
		Name = props.FrameName or "Keybind Container",
		Size = UDim2.new(0.5, 0, 0, 25),
		Parent = type(props.Parent) ~= "nil" and props.Parent or nil,

		[Children] = {
			List = New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			Padding = New("UIPadding")({
				PaddingRight = UDim.new(0, 2),
			}),

			Title = Label({
				Text = props.LabelText,
				Name = "Title",
				LayoutOrder = -1,
			}),

			Icon = New("ImageLabel")({
				Image = imageData.Id,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(30, 30),
				ImageRectOffset = imageData.Offset,
				ImageRectSize = imageData.Size,
			}),
		},
	})
end
