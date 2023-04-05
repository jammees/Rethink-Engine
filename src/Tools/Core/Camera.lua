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

local Types = require(script.Parent.Scene.Types)
local Scene = require(script.Parent.Scene)

local prePosition = Vector2.new(0, 0)
local objectLookup = {}

local Camera = {}

Camera.Position = Vector2.new(0, 0)
Camera.Objects = {}
Camera.ShouldRender = true

function Camera.Render(deltaTime: number)
	if Camera.ShouldRender == false or prePosition == Camera.Position then
		return
	end

	for _, objectData: ObjectData in ipairs(Camera.Objects) do
		Camera.RenderIndividual(objectData)
	end

	prePosition = Camera.Position
end

function Camera.RenderIndividual(objectData, deltaTime: number)
	-- Calculate the movement of the camera since the last update
	local cameraDelta = Camera.Position - prePosition

	if objectData.IsRigidbody then
		local newPosition = objectData.OriginalPosition + UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)

		if objectData.Object.anchored then
			objectData.Object:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)

			objectData.OriginalPosition = newPosition

			return
		end

		local vertexCache = {}

		for _, vertex in ipairs(objectData.Object:GetVertices()) do
			vertexCache[vertex.id] = vertex:Velocity()
		end

		objectData.Object:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)

		for _, vertex in ipairs(objectData.Object:GetVertices()) do
			vertex:ApplyForce(vertexCache[vertex.id])
		end

		objectData.OriginalPosition = newPosition

		return
	end

	-- Calculate the new position of the object by adding the camera movement to its original position
	local newPosition = objectData.OriginalPosition + UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)

	-- Use the ChangePosition method to directly set the new position for the object
	objectData.Object.Position = newPosition
	objectData.OriginalPosition = newPosition
end

-- Store the original position of the object when it is attached to the camera
function Camera.Attach(object: GuiBase2d | Types.Rigidbody)
	local isRigidbody = Scene.IsRigidbody(object)

	local reservedPosition = #Camera.Objects + 1
	objectLookup[object] = reservedPosition

	local objectReference = {
		Object = object,
		IsRigidbody = isRigidbody,
		OriginalPosition = isRigidbody and object:GetFrame().Position or object.Position,
	}

	-- Apply position
	--[[ local cameraDelta = Camera.Position - prePosition
	if Scene.IsRigidbody(object) then
		local newPosition = objectReference.OriginalPosition + UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)
		object:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)
		objectReference.OriginalPosition = newPosition
	else
		local newPosition = objectReference.OriginalPosition + UDim2.fromOffset(cameraDelta.X, cameraDelta.Y)
		object.Position = newPosition
		objectReference.OriginalPosition = newPosition
	end ]]

	table.insert(Camera.Objects, objectReference)
end

function Camera.Detach(object: GuiBase2d | { any })
	local dataIndex = objectLookup[object]

	if dataIndex then
		table.remove(Camera.Objects, dataIndex)
	end
end

function Camera.MoveTo(x: number, y: number)
	-- Update the prePosition variable with the current position of the camera
	prePosition = Camera.Position
	Camera.Position = Vector2.new(x, y)
end

-- Automatically call :Attach on every object that gets loaded
-- with scene.
-- In the future, this might get a setting to turn this behaviour off
Scene.Events.ObjectAdded:Connect(function(object)
	Camera.Attach(object)
end)

Scene.Events.ObjectRemoved:Connect(function(object)
	Camera.Detach(object)
end)

return Camera
