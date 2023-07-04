--[[
	This additional module consists of necessary global 
	
	-> Consists of necessary global constants.
	-> You can edit classes to whatever GUIBASE2D classes. These classes are used to determine
	   the objects the ray can collide with.
]]
--

return {
	Name = "Ray",
	Thickness = 1,
	Color = Color3.fromRGB(255, 0, 0),
	Classes = {
		"Frame",
		"ImageLabel",
		"ImageButton",
		"TextButton",
		"TextLabel",
		"TextBox",
	},
	MAX = math.huge,
	offset = Vector2.new(0, 36), -- set this to Vector2.new(0, 0) if you get weird results.
}
