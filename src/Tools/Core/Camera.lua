type TweenProperty = {
	Duration: number,
	Style: Enum.EasingStyle,
	Direction: Enum.EasingDirection,
}

local TweenService = game:GetService("TweenService")

local zoomTween: Tween = nil
local package = script.Parent.Parent.Parent
local components = package.Components

local Util = require(components.Util)
local Strings = require(components.Debug.Strings)
-- local Collision = require(script.Parent.Parent.Environment.Collision)
local Wrapper = require(components.Wrapper)

local Camera = Wrapper.Wrap()

Camera.Position = Vector2.new(0, 0)
Camera.PrePosition = Vector2.new(0, 0)
Camera.Objects = {}

local viewScale = Camera.ViewScale
-- local physics = Camera.physics

-- local connectionCache = {}

--[[ function Camera:DampenBounce()
	local rigidbodies = physics:GetBodies()

	for _, connection in ipairs(connectionCache) do
		connection:Disconnect()
	end
	table.clear(connectionCache)

	for _, body in ipairs(rigidbodies) do
		if body.anchored then
			connectionCache[#connectionCache + 1] = body.Touched:Connect(function(id)
				local touchedBody = physics:GetBodyById(id)
				if not touchedBody.anchored then
					--warn(touchedBody:AverageVelocity().Y)
					if touchedBody:AverageVelocity().Y > 1 then
						touchedBody:Anchor()
						local touchedFrame = touchedBody:GetFrame()
						local _, depth = Collision.solidCollision(touchedFrame, body:GetFrame())
						local X = touchedFrame.Position.X.Offset
						local Y = touchedFrame.Position.Y.Offset + depth.Y

						touchedBody:Unanchor()
						touchedBody:SetPosition(X, Y)
					end
				end
			end)
		end
	end
end ]]

local posbuffer = {}

function Camera:Render()
	-- if self.PrePosition ~= self.Position and #self.Objects > 0 then --> save some resources, hopefully :)
	-- 	self.PrePosition = self.Position

	-- 	for _, objectData in ipairs(self.Objects) do
	-- 		local object: Instance | { any } = objectData.Object
	-- 		local initPos: UDim2 = objectData.Position

	-- 		local X = -self.Position.X - initPos.X.Offset
	-- 		local Y = -self.Position.Y - initPos.Y.Offset

	-- 		local deltaPosition = Camera.PrePosition - Camera.Position

	-- 		-- if typeof(object) == "Instance" then
	-- 		-- 	object.Position = UDim2.fromOffset(X, Y)
	-- 		-- end

	-- 		if object.id ~= nil then
	-- 			local objInstance: Frame = object:GetFrame()
	-- 			local objPosition: UDim2 = objInstance.Position
	-- 			object:SetPosition(objPosition.X.Offset + deltaPosition.X, objPosition.Y.Offset + deltaPosition.Y)
	-- 		end
	-- 		-- if object.anchored then
	-- 		-- 	object:SetPosition(X, Y)
	-- 		-- else
	-- 		-- 	return -- for now Camera won't support moving rigidbodies
	-- 		-- 	-- object:SetPosition(X, Y)
	-- 		-- 	-- object:ApplyForce(X / 2, Y / 2) <-- won't work pretty sure
	-- 		-- end
	-- 	end
	-- end

	if self.PrePosition ~= self.Position and #self.Objects > 0 then
		self.PrePosition = self.Position --> stop updating

		for _, objectData in ipairs(self.Objects) do
			local object = objectData.Object
			local initalPosition: UDim2 = objectData.Position

			local X = -self.Position.X - initalPosition.X.Offset
			local Y = -self.Position.Y - initalPosition.Y.Offset

			local buffer = posbuffer[type(object) == "table" and object:GetFrame() or object]

			local delta = Vector2.new(buffer.X - X, buffer.Y - Y)

			-- somehow figure it out how to reference this code or get the data
			-- to send it to the physics engine
			-- so the body will move now instead of it getting freezed
			if object.id then
				--object:SetPosition
				--rigidbuffer[object:GetFrame()] = delta

				-- do something blah blah
			else
				object.Position += UDim2.fromOffset(delta.X, delta.Y)
			end
		end
	end
end

-- @readonly
-- @private
function Camera:FromBuffer(object: Instance)
	if posbuffer[object] then
		return posbuffer[object]
	end
end

function Camera:Attach(object: Instance | { any }) --> for now to make the :Attach() work call it twice on the objet
	Util.Assert(Strings.ExpectedNoArg, object, "Instance", "table")

	-- check if its not attached to the camera already
	local isFound, _ = Util.FindInTable(self.Objects, object, "Object")
	if isFound then
		return warn(string.format(Strings.ObjectAlreadyAttached, object.Name or object.id or "Unknown"))
	end

	--[[ 
	-- listen to UpdateFinished to update the rigidbody's position
	if object.id then
		local initPos = object.Position 
		object.UpdateFinished:Connect(function()
			local X = -self.Position.X - initPos.X.Offset
			local Y = -self.Position.Y - initPos.Y.Offset

			object:SetPosition(X, Y)
		end)
	end *]]

	local initialPosition = type(object) == "table" and object:GetFrame().Position or object.Position
	posbuffer[type(object) == "table" and object:GetFrame() or object] = Vector2.new(initialPosition)

	table.insert(self.Objects, {
		Object = object,
		Position = initialPosition,
	})
end

function Camera:Detach(object: Instance | { any })
	Util.Assert(Strings.ExpectedNoArg, object, "Instance", "table")

	-- check if its attached to the camera already
	local isFound, index = Util.FindInTable(self.Objects, object, "Object")
	if not isFound then
		return warn(string.format(Strings.ObjectIsNotAttached, object.Name or object.id or "Unknown"))
	end

	table.remove(self.Objects, index)
end

function Camera:MoveTo(newPosition: UDim2 | Vector2, offset: Vector2)
	Util.Assert(Strings.ExpectedNoArg, newPosition, "UDim2", "Vector2")

	self.Position = typeof(offset) == "Vector2" and Util.ConvertToVector(newPosition) + offset
		or Util.ConvertToVector(newPosition)
end

--[[ function Camera:ScaleToViewport()
	local scaleToFit = self.GameFrame.AbsoluteSize / Vector2.new(280 * 16 / 9, 280)
	local scale = math.ceil(math.max(scaleToFit.X, scaleToFit.Y))
	--local scale = math.max(scaleToFit.X, scaleToFit.Y)
	viewScale.Scale = scale
end ]]

function Camera:Zoom(amount: number, tweenInfo: TweenProperty?)
	if typeof(tweenInfo) == "table" then
		if zoomTween then
			zoomTween:Cancel()
			zoomTween = nil
		end

		zoomTween = TweenService:Create(
			viewScale,
			TweenInfo.new(
				tweenInfo.Duration or 1,
				tweenInfo.Style or Enum.EasingStyle.Linear,
				tweenInfo.Direction or Enum.EasingDirection.Out
			),
			{ Scale = amount }
		)
		zoomTween:Play()
	else
		viewScale.Scale = amount
	end
end

return Camera
