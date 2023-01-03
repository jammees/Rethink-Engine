--[[

	Outline
	
	Config:

		Name:					Must-have:	Default value:	Description:

		Object: GuiBase2D		yes			none			Module will use as the clone template
		Size: number			no			3				How thicc the outline will be
		Parent: Instance		no			Object			Where to parent it
		Data: table				no			DEFAULT_DATA	Positional data
		Sides: number			no			8				For the loop and for the positional data
		Rotation: number		no			0				How much the module should rotate the outlines
		Customize: table
			Color: Color3		no			black			What color
			Gradient: boolean	no			true			Use gradient or use ImageColor3


    API:

    outline.New()
	outline:Rebake()
    outline:Destroy()

	This is an outdated module.
	I will still keep it around, because it may come handy in the future.
]]

local SIDES = 8
local ALLOWED_PROPERTY_TO_UPDATE = {
	"Image",
	"ImageRectOffset",
	"ImageRectSize",
	"ImageTransparency",
}
local NOT_ALLOWED_INSTANCES = {
	"Script",
	"ModuleScript",
	"LocalScript",
}
local DEFAULT_DATA = {
	[1] = { "-%s", "0" },
	[2] = { "-%s", "-%s" },
	[3] = { "0", "-%s" },
	[4] = { "%s", "-%s" },
	[5] = { "0", "%s" },
	[6] = { "%s", "%s" },
	[7] = { "-%s", "%s" },
	[8] = { "%s", "0" },
}

local function createNewFrame(self)
	local clone = self.template:Clone()
	clone.Size = UDim2.fromScale(1, 1)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.ZIndex = 0
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.BorderSizePixel = 0
	clone.Name = "Outline"
	clone.Rotation = self.rotation

	if self.useGradient then
		local gradient = Instance.new("UIGradient")
		if typeof(self.color) == "ColorSequence" then
			gradient.Color = self.color
		else
			gradient.Color = ColorSequence.new(self.color, self.color)
		end
		gradient.Parent = clone
	else
		clone.ImageColor3 = self.color
	end

	clone.Parent = self.outlineParent
	return clone
end

local function checkIfNotZero(dirString)
	if dirString == "0" then
		return 0
	else
		return tonumber(dirString)
	end
end

local function convertString(dataString, size)
	local formatted = string.format(dataString, tostring(size))
	local haha_yes = checkIfNotZero(formatted)
	return haha_yes
end

local function renderize(self)
	-- "bake" the lines into the image
	for side = 1, self.sides do
		if self.data[side] then
			local clone = createNewFrame(self)
			local pos = clone.Position
			local dirData = self.data[side]

			local x = convertString(dirData[1], self.outlineSize)
			local y = convertString(dirData[2], self.outlineSize)

			pos += UDim2.fromOffset(x, y)
			clone.Position = pos

			self.lines[#self.lines + 1] = clone
		else
			warn("No dir data found!")
		end
	end
	self.template:Destroy()
end

local function rerenderize(self)
	for _, obj in ipairs(self.lines) do
		for _, allowedProperty in ipairs(ALLOWED_PROPERTY_TO_UPDATE) do
			obj[allowedProperty] = self.obj[allowedProperty]
		end
	end
end

local function checkIfExists(data, value)
	if data then
		return data[value]
	else
		return nil
	end
end

local Outline = {}
Outline.__index = Outline

function Outline.New(config)
	local self = {}
	---
	self.obj = config.Object or error("Must-have property: Object is missing!")
	self.outlineSize = config.Size or 3
	self.outlineParent = config.Parent or self.obj
	self.data = config.Data or DEFAULT_DATA
	self.sides = config.Sides or SIDES
	self.rotation = config.Rotation or 0

	self.color = checkIfExists(config.Customize, "Color") or Color3.fromRGB(0, 0, 0)
	self.useGradient = checkIfExists(config.Customize, "Gradient") or true

	self.template = self.obj:Clone()

	-- makes sure that no scripts get cloned, or else it will create a recursion
	for _, instances in ipairs(self.template:GetDescendants()) do
		for _, notAllowedClass in ipairs(NOT_ALLOWED_INSTANCES) do
			if instances:IsA(notAllowedClass) then
				instances:Destroy()
			end
		end
	end

	self.lines = {}

	-- makes sure that the ZIndex behavior is global
	local screenGui = self.obj:FindFirstAncestorOfClass("ScreenGui")
	if screenGui.ZIndexBehavior ~= Enum.ZIndexBehavior.Global then
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	end

	-- render the outlines
	renderize(self)
	---
	return setmetatable(self, Outline)
end

function Outline:Rebake()
	rerenderize(self)
end

function Outline:Destroy()
	self.obj = nil
	self.outlineParent = nil
	self.data = nil

	for _, v in ipairs(self.lines) do
		v:Destroy()
	end
	for _, v in ipairs(self.changedEvents) do
		v:Disconnect()
	end
end

return Outline
