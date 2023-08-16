-- [ RayCast2 v0.1 ] --

--[[

	|------------------------------------------------------------|		

   	|- Devforum Post:

                https://devforum.roblox.com/t/raycast2-cast-rays-on-a-2d-surface/1430643

   	|- API:

                https://jaipack17.gitbook.io/raycast2/

	|- Debugging and Troubleshooting:

		:- Place the module inside StarterGui only.
		:- Check if you passed correct parameters when using functions.
		:- the 'parent' parameter in :Cast() must be a ScreenGui instance.
		:- Classes: {
			Frame,
			ImageLabel
		}
		:- To add more classes, go to RayCast2 -> GlobalConstants | Edit the Classes Table.
		:- If you get weird results/behavior, go to RayCast2 -> GlobalConstants | Set Offset to Vector2.new(0, 0)

	|- Functions:

		[function] :: RayCast2.new()
			
			initializes the ray to be formed.
			
			* parameters: (
				[vector2] or [udim2] origin -> Starting point of the ray
				[vector2 ( X: lenght , Y: rotation ) ] or [udim2] direction -> Direction point of the ray
			)
			
			* returns (
				[metatable] {
					[vector2] _origin,
					[vectro2] _direction,
					[nil] or [instance] _ray,
					[boolean] Visible
				},
				{
					[function] Cast(),
					[function] GetRayInstance(),
					[function] GetOrigin(),
					[function] GetDirection()
				}
			)
			
		[function] :: RayCast2:Cast()
		
			casts the ray in the given direction from the origin
			
			* parameters (
				[instance] parent -> If the ray is said to be visible, the Ray instance will be parented to this ScreenGui
				[table] whitelist -> The ray will only intersect the gui instances in this table (if possible)
			)
			
			* returns (
				[instance] or [nil] hit -> The gui the ray hits
				[vector2] or [nil] point -> The point at which ray hits another gui
			)
			
		[function] :: RayCast2:GetRayInstance()
		
			get ray instance that has been formed when calling :Cast()
			
			* parameters ()
			
			* returns (
				[instance] ray -> The ray instance
			)
			
		[function] :: RayCast2:GetOrigin()
		
			get the origin point of the ray
			
			* parameters ()
			
			* returns (
				[vector2] origin
			)
			
		[function] :: RayCast2:GetDirection()
		
			get the direction point of the ray
			
			* parameters ()
			
			* returns (
				[vector2] direction
			)
			
	|------------------------------------------------------------|		
	
]]
--

-- [Additional Modules]

local drawLine = require(script.Ray)
local Convergence = require(script.Convergence)

-- [Module]

local RayCast2 = {}
RayCast2.__index = RayCast2

-- [Debug]

--if not script:IsDescendantOf(game:GetService("Players").LocalPlayer.PlayerGui) then
--	error("RayCast2 must be a descendant of PlayerGui. Place the module inside StarterGui.")
--end

-- [function] RayCast2.new()

function RayCast2.new(origin, direction)
	if not typeof(origin) == "UDim2" and not typeof(origin) == "Vector2" then
		error("UDim2 or Vector2 expected got " .. typeof(origin))
	end
	if not typeof(direction) == "UDim2" and not typeof(direction) == "Vector2" then
		error("UDim2 or Vector2 expected got " .. typeof(direction))
	end

	origin = typeof(origin) == "UDim2" and Vector2.new(origin.X.Offset, origin.Y.Offset) or origin
	direction = typeof(direction) == "UDim2" and Vector2.new(direction.X.Offset, direction.Y.Offset) or direction

	local self = setmetatable({
		_origin = origin,
		_direction = direction,
		_ray = nil,
		Visible = false,
	}, RayCast2)

	return self
end

-- [function] RayCast2:Cast()

function RayCast2:Cast(parent: Instance, list: table)
	assert(parent:IsA("ScreenGui"), "argument must be a ScreenGui instance")

	if self._ray then
		self._ray:Destroy()
		self._ray = nil
	end

	if self.Visible then
		local ray = drawLine(self._origin.x, self._origin.y, self._direction.x, self._direction.y, parent, 1)
		self._ray = ray
	end

	local hit, pos = Convergence.intersects(self, list)

	return hit, pos
end

-- [function] RayCast2:GetRayInstance()

function RayCast2:GetRayInstance()
	return self._ray
end

-- [function] RayCast2:GetOrigin()

function RayCast2:GetOrigin()
	return self._origin
end

-- [function] RayCast2:GetDirection()

function RayCast2:GetDirection()
	return self._direction
end

return RayCast2
