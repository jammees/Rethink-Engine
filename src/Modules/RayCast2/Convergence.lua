--[[
	This additional module is a part of RayCast2. 
	
	-> Checks for intersections between each boundary of a gui and the ray formed by 
	   the origin and direction.
	
	* Detailed math - https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
]]
--

local Globals = require(script.Parent.GlobalConstants)

local Convergence = {}

function Convergence.getConvergencePoint(x1, x2, y1, y2, x3, x4, y3, y4)
	local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

	if den == 0 then
		return
	end

	local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
	local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den

	return u, t
end

function Convergence.intersects(_self, descendants)
	local minimumMagnitude = Globals.MAX
	local minimumMagnitude2 = Globals.MAX

	local minimumFinalPoint
	local toReturnHit

	for _, wall in ipairs(descendants) do
		if not table.find(Globals.Classes, wall.ClassName) or not wall then
			continue
		end

		local pos = wall.AbsolutePosition + Globals.offset
		local size = wall.AbsoluteSize
		local rotation = wall.Rotation

		local wallCorners = {
			topleft = pos + size / 2 - math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2) * Vector2.new(
				math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) + math.atan2(size.Y, size.X))
			),
			bottomleft = pos + size / 2 - math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2) * Vector2.new(
				math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) - math.atan2(size.Y, size.X))
			),
			bottomright = pos + size / 2 + math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2) * Vector2.new(
				math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) + math.atan2(size.Y, size.X))
			),
			topright = pos + size / 2 + math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2) * Vector2.new(
				math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) - math.atan2(size.Y, size.X))
			),
		}

		local edges = {
			{
				a = wallCorners.topleft,
				b = wallCorners.bottomleft,
			},
			{
				a = wallCorners.topleft,
				b = wallCorners.topright,
			},
			{
				a = wallCorners.bottomleft,
				b = wallCorners.bottomright,
			},
			{
				a = wallCorners.topright,
				b = wallCorners.bottomright,
			},
		}

		local tempPoint
		local tempObstacle

		for _, edge in ipairs(edges) do
			local x1, y1 = edge.a.x, edge.a.y
			local x2, y2 = edge.b.x, edge.b.y

			local x3, y3 = _self._origin.x, _self._origin.y
			local x4, y4 = _self._direction.x, _self._direction.y

			local u, t = Convergence.getConvergencePoint(x1, x2, y1, y2, x3, x4, y3, y4)

			if t and u and t > 0 and t < 1 and u > 0 then
				local point = Vector2.new(x1 + t * (x2 - x1), y1 + t * (y2 - y1))

				if (point - _self._origin).magnitude < minimumMagnitude then
					minimumMagnitude = (point - _self._origin).magnitude
					tempPoint = point
					tempObstacle = wall
				end
			end
		end

		if tempObstacle and tempPoint then
			if (tempPoint - _self._origin).magnitude < minimumMagnitude2 then
				minimumMagnitude2 = (tempPoint - _self._origin).magnitude
				minimumFinalPoint = tempPoint
				toReturnHit = tempObstacle
			end
		end
	end

	return toReturnHit, minimumFinalPoint
end

return Convergence
