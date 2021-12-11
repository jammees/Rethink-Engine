-- Gui to Lua
-- Version: 3.2

-- Instances:

local main = Instance.new("Frame")
local editor = Instance.new("Frame")
local bar = Instance.new("Frame")
local level = Instance.new("TextButton")
local size = Instance.new("UITextSizeConstraint")
local list = Instance.new("UIListLayout")
local collider = Instance.new("TextButton")
local size_2 = Instance.new("UITextSizeConstraint")
local list_2 = Instance.new("UIListLayout")
local scrolls = Instance.new("Frame")
local level_2 = Instance.new("ScrollingFrame")
local collider_2 = Instance.new("ScrollingFrame")
local list_3 = Instance.new("UIListLayout")
local properties = Instance.new("Frame")
local scroll = Instance.new("ScrollingFrame")
local list_4 = Instance.new("UIListLayout")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local TextLabel_3 = Instance.new("TextLabel")
local TextLabel_4 = Instance.new("TextLabel")
local TextLabel_5 = Instance.new("TextLabel")
local TextLabel_6 = Instance.new("TextLabel")
local TextLabel_7 = Instance.new("TextLabel")
local bar_2 = Instance.new("Frame")
local add = Instance.new("TextButton")
local size_3 = Instance.new("UITextSizeConstraint")
local list_5 = Instance.new("UIListLayout")
local padding = Instance.new("UIPadding")
local list_6 = Instance.new("UIListLayout")

--Properties:

main.Name = "main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
main.Position = UDim2.new(0.499364674, 0, 0.49953863, 0)
main.Size = UDim2.new(0.927573085, 0, 0.927573085, 0)

editor.Name = "editor"
editor.Parent = main
editor.AnchorPoint = Vector2.new(0.5, 0.5)
editor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
editor.BackgroundTransparency = 1.000
editor.Position = UDim2.new(0.363013685, 0, 0.5, 0)
editor.Size = UDim2.new(0.726027369, 0, 1, 0)

bar.Name = "bar"
bar.Parent = editor
bar.AnchorPoint = Vector2.new(0.5, 0.5)
bar.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
bar.BorderSizePixel = 0
bar.Position = UDim2.new(0.5, 0, 0.0448102839, 0)
bar.Size = UDim2.new(1, 0, 0.0896205679, 0)

level.Name = "level"
level.Parent = bar
level.AnchorPoint = Vector2.new(0.5, 0.5)
level.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
level.BorderColor3 = Color3.fromRGB(27, 42, 53)
level.BorderSizePixel = 0
level.Position = UDim2.new(0.14957878, 0, 0.574142098, 0)
level.Size = UDim2.new(0.29915756, 0, 0.851715744, 0)
level.Font = Enum.Font.GothamSemibold
level.Text = "level editor"
level.TextColor3 = Color3.fromRGB(255, 255, 255)
level.TextScaled = true
level.TextSize = 17.000
level.TextWrapped = true

size.Name = "size"
size.Parent = level
size.MaxTextSize = 19

list.Name = "list"
list.Parent = bar
list.FillDirection = Enum.FillDirection.Horizontal
list.SortOrder = Enum.SortOrder.LayoutOrder
list.VerticalAlignment = Enum.VerticalAlignment.Bottom

collider.Name = "collider"
collider.Parent = bar
collider.AnchorPoint = Vector2.new(0.5, 0.5)
collider.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
collider.BorderSizePixel = 0
collider.Position = UDim2.new(0.14957878, 0, 0.574142098, 0)
collider.Size = UDim2.new(0.29915756, 0, 0.851715744, 0)
collider.Font = Enum.Font.GothamSemibold
collider.Text = "collider editor"
collider.TextColor3 = Color3.fromRGB(255, 255, 255)
collider.TextScaled = true
collider.TextSize = 17.000
collider.TextWrapped = true

size_2.Name = "size"
size_2.Parent = collider
size_2.MaxTextSize = 19

list_2.Name = "list"
list_2.Parent = editor
list_2.SortOrder = Enum.SortOrder.LayoutOrder

scrolls.Name = "scrolls"
scrolls.Parent = editor
scrolls.AnchorPoint = Vector2.new(0.5, 0.5)
scrolls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scrolls.BackgroundTransparency = 1.000
scrolls.Position = UDim2.new(0, 0, 0.0896205679, 0)
scrolls.Size = UDim2.new(0.98867923, 0, 0.89356935, 0)

level_2.Name = "level"
level_2.Parent = scrolls
level_2.Active = true
level_2.AnchorPoint = Vector2.new(0.5, 0.5)
level_2.BackgroundColor3 = Color3.fromRGB(7, 255, 218)
level_2.BackgroundTransparency = 1.000
level_2.BorderSizePixel = 0
level_2.Position = UDim2.new(0.5, 0, 0.5, 0)
level_2.Size = UDim2.new(1, 0, 1, 0)
level_2.CanvasSize = UDim2.new(5, 0, 2, 0)
level_2.ScrollBarThickness = 5
level_2.ScrollingEnabled = false

collider_2.Name = "collider"
collider_2.Parent = scrolls
collider_2.Active = true
collider_2.AnchorPoint = Vector2.new(0.5, 0.5)
collider_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
collider_2.BackgroundTransparency = 1.000
collider_2.BorderSizePixel = 0
collider_2.Position = UDim2.new(0.5, 0, 0.5, 0)
collider_2.Size = UDim2.new(1, 0, 1, 0)
collider_2.Visible = false
collider_2.ZIndex = 5
collider_2.CanvasSize = UDim2.new(5, 0, 2, 0)
collider_2.ScrollBarThickness = 5

list_3.Name = "list"
list_3.Parent = main
list_3.FillDirection = Enum.FillDirection.Horizontal
list_3.HorizontalAlignment = Enum.HorizontalAlignment.Right
list_3.SortOrder = Enum.SortOrder.LayoutOrder

properties.Name = "properties"
properties.Parent = main
properties.AnchorPoint = Vector2.new(0.5, 0.5)
properties.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
properties.BackgroundTransparency = 0.900
properties.BorderSizePixel = 0
properties.Position = UDim2.new(0.863013685, 0, 0.5, 0)
properties.Size = UDim2.new(0.273972601, 0, 1, 0)

scroll.Name = "scroll"
scroll.Parent = properties
scroll.Active = true
scroll.AnchorPoint = Vector2.new(0.5, 0.5)
scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scroll.BackgroundTransparency = 1.000
scroll.BorderSizePixel = 0
scroll.LayoutOrder = 2
scroll.Position = UDim2.new(0.5, 0, 0.544810236, 0)
scroll.Size = UDim2.new(1, 0, 0.910379469, 0)
scroll.ScrollBarThickness = 4

list_4.Name = "list"
list_4.Parent = scroll
list_4.SortOrder = Enum.SortOrder.LayoutOrder

TextLabel.Parent = scroll
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Position = UDim2.new(0.5, 0, 0.0316238552, 0)
TextLabel.Size = UDim2.new(1, 0, 0.0632476285, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "custom properties are not implemented yet!"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

TextLabel_2.Parent = scroll
TextLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.Position = UDim2.new(0.5, 0, 0.162095666, 0)
TextLabel_2.Size = UDim2.new(1, 0, 0.0462955646, 0)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "properties"
TextLabel_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.TextSize = 14.000
TextLabel_2.TextWrapped = true

TextLabel_3.Parent = scroll
TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.Position = UDim2.new(0.5, 0, 0.255314738, 0)
TextLabel_3.Size = UDim2.new(1, 0, 0.0293214992, 0)
TextLabel_3.Font = Enum.Font.SourceSans
TextLabel_3.Text = "layer"
TextLabel_3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.TextSize = 14.000
TextLabel_3.TextWrapped = true

TextLabel_4.Parent = scroll
TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.Position = UDim2.new(0.5, 0, 0.255314738, 0)
TextLabel_4.Size = UDim2.new(1, 0, 0.0293214992, 0)
TextLabel_4.Font = Enum.Font.SourceSans
TextLabel_4.Text = "color"
TextLabel_4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.TextSize = 14.000
TextLabel_4.TextWrapped = true

TextLabel_5.Parent = scroll
TextLabel_5.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.Position = UDim2.new(0.5, 0, 0.255314738, 0)
TextLabel_5.Size = UDim2.new(1, 0, 0.0293214992, 0)
TextLabel_5.Font = Enum.Font.SourceSans
TextLabel_5.Text = "anchored"
TextLabel_5.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.TextSize = 14.000
TextLabel_5.TextWrapped = true

TextLabel_6.Parent = scroll
TextLabel_6.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.Position = UDim2.new(0.5, 0, 0.255314738, 0)
TextLabel_6.Size = UDim2.new(1, 0, 0.0293214992, 0)
TextLabel_6.Font = Enum.Font.SourceSans
TextLabel_6.Text = "collidable"
TextLabel_6.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_6.TextSize = 14.000
TextLabel_6.TextWrapped = true

TextLabel_7.Parent = scroll
TextLabel_7.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.Position = UDim2.new(0.5, 0, 0.255314738, 0)
TextLabel_7.Size = UDim2.new(1, 0, 0.0293214992, 0)
TextLabel_7.Font = Enum.Font.SourceSans
TextLabel_7.Text = "z index"
TextLabel_7.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_7.TextSize = 14.000
TextLabel_7.TextWrapped = true

bar_2.Name = "bar"
bar_2.Parent = properties
bar_2.AnchorPoint = Vector2.new(0.5, 0.5)
bar_2.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
bar_2.BorderSizePixel = 0
bar_2.Position = UDim2.new(0.5, 0, 0.0448102616, 0)
bar_2.Size = UDim2.new(1, 0, 0.0896205232, 0)

add.Name = "add"
add.Parent = bar_2
add.AnchorPoint = Vector2.new(0.5, 0.5)
add.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
add.Position = UDim2.new(0.936923146, 0, 0.542892218, 0)
add.Size = UDim2.new(0.126153752, 0, 0.703431547, 0)
add.Font = Enum.Font.GothamSemibold
add.Text = "+"
add.TextColor3 = Color3.fromRGB(255, 255, 255)
add.TextScaled = true
add.TextSize = 17.000
add.TextWrapped = true

size_3.Name = "size"
size_3.Parent = add
size_3.MaxTextSize = 19

list_5.Name = "list"
list_5.Parent = bar_2
list_5.HorizontalAlignment = Enum.HorizontalAlignment.Right
list_5.SortOrder = Enum.SortOrder.LayoutOrder
list_5.VerticalAlignment = Enum.VerticalAlignment.Center

padding.Name = "padding"
padding.Parent = bar_2
padding.PaddingRight = UDim.new(0, 5)

list_6.Name = "list"
list_6.Parent = properties
list_6.SortOrder = Enum.SortOrder.LayoutOrder

return {
    main = main,

    prop = {
        buttons = {
            add = add
        },
        scroll = scroll
    },
    level = {
        button = level,
        scroll = level_2,
    },
    collider = {
        button = level,
        scroll = collider_2,
    }
}