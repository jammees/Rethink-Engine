local GuiCollisionService = {}
GuiCollisionService.__index = GuiCollisionService

local function intersects(p, edge)
	local x1, y1 = edge.a.x, edge.a.y
	local x2, y2 = edge.b.x, edge.b.y

	local x3, y3 = p.x, p.y
	local x4, y4 = p.x + 2147483647, p.y

	local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

	if den == 0 then
		return false
	end

	local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
	local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den

	if t and u and t > 0 and t < 1 and u > 0 then
		return true
	end

	return false
end

local function solidCollision(gui1, gui2) -- special thanks to RuizuKun_Dev
	local pos1, size1 = gui1.AbsolutePosition, gui1.AbsoluteSize
	local pos2, size2 = gui2.AbsolutePosition, gui2.AbsoluteSize

	local IsColliding, MTV = GuiCollisionService.isColliding(gui1, gui2)
	if IsColliding then
		local EdgeDifferences_Array = {
			Vector2.new(pos1.x - (pos2.x + size2.x), 0),
			Vector2.new((pos1.x + size1.x) - pos2.x, 0),
			Vector2.new(0, pos1.y - (pos2.y + size2.y)),
			Vector2.new(0, (pos1.y + size1.y) - pos2.y),
		}
		table.sort(EdgeDifferences_Array, function(A, B)
			return A.magnitude < B.magnitude
		end)
		MTV = EdgeDifferences_Array[1]
	end
	return IsColliding, MTV or Vector2.new()
end

local function getCorners(guiObject0)
	local pos = guiObject0.AbsolutePosition
	local size = guiObject0.AbsoluteSize
	local rotation = guiObject0.Rotation

	local a = pos
		+ size / 2
		- math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2)
			* Vector2.new(
				math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) + math.atan2(size.Y, size.X))
			)
	local b = pos
		+ size / 2
		- math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2)
			* Vector2.new(
				math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) - math.atan2(size.Y, size.X))
			)
	local c = pos
		+ size / 2
		+ math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2)
			* Vector2.new(
				math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) + math.atan2(size.Y, size.X))
			)
	local d = pos
		+ size / 2
		+ math.sqrt((size.X / 2) ^ 2 + (size.Y / 2) ^ 2)
			* Vector2.new(
				math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)),
				math.sin(math.rad(rotation) - math.atan2(size.Y, size.X))
			)

	return {
		topleft = a,
		bottomleft = b,
		topright = d,
		bottomright = c,
	}
end

local function checkCollisions(collider, hitter)
	if collider.solid then
		local IsColliding, MTV = solidCollision(hitter.i, collider.i)
		if IsColliding then
			if hitter.t then
				for i, tween in ipairs(hitter.t) do
					if tween.PlaybackState == Enum.PlaybackState.Playing then
						tween:Pause()
						table.remove(hitter.t, i)
					end
				end
			end
			hitter.i.Position = hitter.i.Position - UDim2.new(0, MTV.x, 0, MTV.y)
		end
	end

	if GuiCollisionService.isColliding(hitter.i, collider.i) then
		return true
	end

	return false
end

local function check(hitter, colliders, h)
	local collidingWith = {}

	for _, collider in ipairs(colliders) do
		if h then
			if hitter.i.ZIndex == collider.i.ZIndex then
				if checkCollisions(collider, hitter) then
					table.insert(collidingWith, collider.i)
				end
			end
		else
			if checkCollisions(collider, hitter) then
				table.insert(collidingWith, collider.i)
			end
		end
	end

	if #collidingWith > 0 then
		return collidingWith
	end

	return nil
end

local function inRange(num, range)
	return num > range.Min and num < range.Max
end

function GuiCollisionService.isInCore(gui0, gui1)
	assert(typeof(gui0) == "Instance" and typeof(gui1) == "Instance", "argument must be an instance")
	if gui0.AbsoluteSize.x > gui1.AbsoluteSize.x or gui0.AbsoluteSize.y > gui1.AbsoluteSize.y then
		return false
	end

	local corners0, corners1 = getCorners(gui0), getCorners(gui1)

	local x = NumberRange.new(corners1[1].x, corners1[4].x)
	local y = NumberRange.new(corners1[1].y, corners1[2].y)

	local cornersInside = 0

	for _, corner in ipairs(corners0) do
		if inRange(corner.x, x) and inRange(corner.y, y) then
			cornersInside += 1
		end
	end

	if cornersInside == 4 then
		return true
	end

	return false
end

function GuiCollisionService.isColliding(guiObject0, guiObject1)
	if not typeof(guiObject0) == "Instance" or not typeof(guiObject1) == "Instance" then
		error("argument must be an instance")
		return
	end

	local ap1 = guiObject0.AbsolutePosition
	local as1 = guiObject0.AbsoluteSize
	local sum = ap1 + as1

	local ap2 = guiObject1.AbsolutePosition
	local as2 = guiObject1.AbsoluteSize
	local sum2 = ap2 + as2

	local corners0 = getCorners(guiObject0)
	local corners1 = getCorners(guiObject1)

	local edges = {
		{
			a = corners1.topleft,
			b = corners1.bottomleft,
		},
		{
			a = corners1.topleft,
			b = corners1.topright,
		},
		{
			a = corners1.bottomleft,
			b = corners1.bottomright,
		},
		{
			a = corners1.topright,
			b = corners1.bottomright,
		},
	}

	local collisions = 0

	for _, corner in pairs(corners0) do
		for _, edge in pairs(edges) do
			if intersects(corner, edge) then
				collisions += 1
			end
		end
	end

	if collisions % 2 ~= 0 then
		return true
	end

	if (ap1.x < sum2.x and sum.x > ap2.x) and (ap1.y < sum2.y and sum.y > ap2.y) then
		return true
	end

	return false
end

function GuiCollisionService.createCollisionGroup()
	local collisionDetected = Instance.new("BindableEvent")

	local self = setmetatable({
		ColliderTouched = collisionDetected.Event,
	}, GuiCollisionService)

	self.colliders = {}
	self.hitters = {}
	self.hierarchy = false

	game:GetService("RunService").RenderStepped:Connect(function(dt)
		for _, hitter in ipairs(self.hitters) do
			local res = check(hitter, self.colliders, self.hierarchy)

			if res then
				local bin = {}

				for i, v in ipairs(res) do
					if table.find(bin, v) then
						table.remove(res, i)
					else
						table.insert(bin, v)
					end
				end

				hitter.i.CollidersTouched:Fire(res)
				hitter.i.Colliding.Value = true
				return
			else
				hitter.i.Colliding.Value = false
			end

			hitter.i.Colliding:GetPropertyChangedSignal("Value"):Connect(function()
				if not hitter.i.Colliding.Value then
					hitter.i.OnCollisionEnded:Fire()
					return
				end
			end)
		end
	end)

	return self
end

function GuiCollisionService:setZIndexHierarchy(bool: boolean)
	assert(typeof(bool) == "boolean", "argument must be a boolean")

	self.hierarchy = true
end

function GuiCollisionService:addHitter(instance, tweens: table)
	assert(typeof(instance) == "Instance", "argument must be an instance")
	assert(typeof(tweens) == "table", "argument must be a table")

	local be = Instance.new("BindableEvent")
	be.Name = "CollidersTouched"
	be.Parent = instance

	local be2 = be:Clone()
	be2.Name = "OnCollisionEnded"
	be2.Parent = instance

	local is = Instance.new("BoolValue")
	is.Name = "Colliding"
	is.Value = false
	is.Parent = instance

	table.insert(self.hitters, { i = instance, t = tweens })

	return { index = #self.hitters, ["instance"] = instance }
end

function GuiCollisionService:updateHitter(i: number, instance, tweens: table)
	assert(typeof(i) == "number", "argument must be a table")
	assert(typeof(instance) == "Instance", "argument must be an instance")
	assert(typeof(tweens) == "table", "argument must be a table")

	self.hitters[i] = { i = instance, t = tweens or {} }

	return { index = i, instance = self.hitters[i].i }
end

function GuiCollisionService:getHitter(index)
	return self.hitters[index].i
end

function GuiCollisionService:getHitterTweens(index)
	return self.hitters[index].t
end

function GuiCollisionService:getHitters()
	local res = {}

	for _, v in ipairs(self.hitters) do
		table.insert(res, v.i)
	end

	return res
end

function GuiCollisionService:removeHitter(index)
	table.remove(self.hitters, index)
end

function GuiCollisionService:addCollider(instance, t: boolean)
	assert(typeof(instance) == "Instance", "argument must be an instance")
	assert(typeof(t) == "boolean", "argument must be a boolean")

	if not self.colliders then
		self.colliders = {}
	end

	if t then
		table.insert(self.colliders, { i = instance, solid = true })
	else
		table.insert(self.colliders, { i = instance })
	end

	return { index = #self.colliders, ["instance"] = instance, solid = t }
end

function GuiCollisionService:updateCollider(i: number, instance, t: boolean)
	assert(typeof(i) == "number", "argument must be a table")
	assert(typeof(instance) == "Instance", "argument must be an instance")
	assert(typeof(t) == "boolean", "argument must be a boolean")

	self.colliders[i] = { ["i"] = instance, solid = t }

	return { index = i, instance = self.colliders[i].i, self.colliders[i].solid }
end

function GuiCollisionService:getColliders()
	local res = {}

	for _, v in ipairs(self.colliders) do
		table.insert(res, v.i)
	end

	return res
end

function GuiCollisionService:removeCollider(index)
	table.remove(self.colliders, index)
end

return GuiCollisionService
