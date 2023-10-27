--[[
	Camera

	Work in progress camera implementation that supports Nature2D
]]

-- Add a "OriginalPosition" property to the ObjectData table
type ObjectData = {
	Object: GuiBase2d | { any },
	IsRigidbody: boolean,
	OriginalPosition: UDim2,
}

local Scene = require(script.Parent.Scene)
local Template = require(script.Parent.Template)
local Log = require(script.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Vendors.t)
local Signal = require(script.Parent.Parent.Vendors.goodsignal)

local runnerConnection = nil
local prePosition = Vector2.new(0, 0)

local function GetState<OBJ>(object: OBJ)
	local isRigidbody = Scene.IsRigidbody(object)
	return isRigidbody, isRigidbody and object.anchored
end

local Camera = {}

Camera.Position = Vector2.new(0, 0)
Camera.Objects = {}
Camera.IsRunning = false
Camera.XBounds = NumberRange.new(-math.huge, math.huge)
Camera.YBounds = NumberRange.new(-math.huge, math.huge)

Camera.Rendered = Signal.new()

-- Define Render Handlers that sole purpose is to update the objects
-- positions based on the Camera
Camera.Handlers = {}
Camera.Handlers.NonBody = function(objectData: any, cameraDelta: Vector2, deltaTime: number?)
	local object = objectData.Object
	local origin: UDim2 = objectData.Origin

	origin += UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)

	if deltaTime then
		origin += UDim2.fromOffset(cameraDelta.X * deltaTime, cameraDelta.Y * deltaTime)
	end

	object.Position = origin
	objectData.Origin = origin
end
Camera.Handlers.AnchoredBody = function(objectData: any, cameraDelta: Vector2, deltaTime: number?)
	local body = objectData.Object
	local origin: UDim2 = objectData.Origin

	origin += UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)

	if deltaTime then
		origin += UDim2.fromOffset(cameraDelta.X * deltaTime, cameraDelta.Y * deltaTime)
	end

	-- Convert UDim2 to Vector2
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local scaleX = origin.X.Scale * viewportSize.X
	local scaleY = origin.Y.Scale * viewportSize.Y

	local convertedOrigin = Vector2.new(scaleX + origin.X.Offset, scaleY + origin.Y.Offset)

	body.anchorPos = convertedOrigin

	objectData.Origin = origin
end
Camera.Handlers.NonAnchoredBody = function(objectData: any, cameraDelta: Vector2, deltaTime: number?)
	local body = objectData.Object
	--local origin: UDim2 = objectData.Origin
	local origin = body.center

	origin += Vector2.new(cameraDelta.X, cameraDelta.Y)

	if deltaTime then
		origin += Vector2.new(cameraDelta.X * deltaTime, cameraDelta.Y * deltaTime)
	end

	local forces = {}

	for _, vertex in body:GetVertices() do
		forces[vertex.id] = vertex.forces
	end

	body:SetPosition(origin.X, origin.Y)

	for _, vertex in body:GetVertices() do
		vertex.forces = forces[vertex.id]
	end

	objectData.Origin = origin
end

function Camera.GetHandler(objectData)
	local isRigidbody, isAnchored = GetState(objectData.Object)

	if not isRigidbody then
		return Camera.Handlers.NonBody
	elseif isRigidbody and isAnchored then
		return Camera.Handlers.AnchoredBody
	elseif isRigidbody and not isAnchored then
		return Camera.Handlers.NonAnchoredBody
	end
end

-- If deltaTime is provided it will multiply the final position by deltaTime
-- if not it won't
function Camera.Render(deltaTime: number?)
	Log.TAssert(t.optional(t.number)(deltaTime))

	if Camera.Position == prePosition then
		return
	end

	local delta = Camera.Position - prePosition

	-- Loop trough objects

	for _, objectData in Camera.Objects do
		local handler = Camera.GetHandler(objectData)

		if handler == Camera.Handlers.NonBody then
			-- Pass the data into the handler
			handler(objectData, delta, deltaTime)
		end
	end

	-- Set the prePosition to the new position to make .Render
	-- stop updating if it's the same + more accurate delta
	prePosition = Camera.Position

	Camera.Rendered:Fire()
end

function Camera.IsAttached(object)
	Log.TAssert(t.union(t.Instance, t.table)(object))

	for _, reference: ObjectData in Camera.Objects do
		if reference.Object == object then
			return true
		end
	end

	return false
end

function Camera.Attach(object)
	Log.TAssert(t.union(t.Instance, t.table)(object))

	local originPosition = nil

	local isRigidbody, isAnchored = GetState(object)

	if not isRigidbody then
		originPosition = object.Position
	elseif isRigidbody and isAnchored then
		originPosition = object:GetFrame().Position
	elseif isRigidbody and not isAnchored then
		originPosition = object.center
	end

	local objectData = { Object = object, Origin = originPosition }

	-- Apply transformation
	local handler = Camera.GetHandler(objectData)
	if handler then
		handler(objectData, Camera.Position)
	else
		return Log.Warn(`Unexpected object: No Render Handler was found -> Object was not attached!`)
	end

	table.insert(Camera.Objects, objectData)
end

function Camera.Detach(object)
	Log.TAssert(t.union(t.Instance, t.table)(object))

	for index, obj in Camera.Objects do
		if obj.Object == object then
			table.remove(Camera.Objects, index)
		end
	end
end

function Camera.SetPosition(x: number, y: number)
	Log.TAssert(t.number(x))
	Log.TAssert(t.number(y))

	-- Clamp the new x and y to the given boundary
	Camera.Position = Vector2.new(
		math.clamp(x, Camera.XBounds.Min, Camera.XBounds.Max),
		math.clamp(y, Camera.YBounds.Min, Camera.YBounds.Max)
	)
end

function Camera.Start()
	if Camera.IsRunning then
		return Log.Warn("Camera is already running!")
	end

	runnerConnection = Template.FetchGlobal("__Rethink_Physics").Updated:Connect(function(deltaTime)
		Camera.Render(deltaTime)
	end)

	Camera.IsRunning = true
end

function Camera.Stop()
	if not Camera.IsRunning then
		return Log.Warn("Camera is not running!")
	end

	runnerConnection:Disconnect()
	runnerConnection = nil

	Camera.IsRunning = false
end

function Camera.SetBoundary(XBounds: NumberRange, YBounds: NumberRange)
	Log.TAssert(t.NumberRange(XBounds))
	Log.TAssert(t.NumberRange(YBounds))

	Camera.XBounds = XBounds
	Camera.YBounds = YBounds
end

return Camera
