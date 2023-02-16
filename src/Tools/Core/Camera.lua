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

local RunService = game:GetService("RunService")

local Types = require(script.Parent.Scene.Types)
local Scene = require(script.Parent.Scene)

local prePosition = Vector2.new(0, 0)
local objectLookup = {}

local Camera = {}

Camera.Position = Vector2.new(0, 0)
Camera.Objects = {}
Camera.ShouldRender = true

-- Calculate the new position of the object based on its original position and the camera's movement
-- TODO: Cleanup
-- TODO: Create different type of modes:
-- Such as: Top-Down, Editor-1 (no-zoom), Editor-2 (with zoom), Side View
function Camera.Render(deltaTime: number)
	if Camera.ShouldRender == false or prePosition == Camera.Position then
		return
	end

	for _, objectData: ObjectData in ipairs(Camera.Objects) do
		-- Calculate the movement of the camera since the last update
		local cameraMovement = Camera.Position - prePosition

		if objectData.IsRigidbody then
			local newPos = objectData.Object.center + cameraMovement

			if objectData.Object.anchored then
				objectData.Object:SetPosition(newPos.X, newPos.Y)
				objectData.OriginalPosition = newPos

				continue
			end

			local vertexCache = {}

			for _, vertex in ipairs(objectData.Object:GetVertices()) do
				--vertexCache[vertex.id] = vertex.forces
				vertexCache[vertex.id] = vertex:Velocity()
				--vertexCache[vertex.id] = vertex:Velocity2()
				--vertexCache[vertex.id] = vertex:GetNetForce()
			end

			-- Create a function to store the position that Camera calculated
			-- and next time when Nature2D is updating the rigidbodies it should take that pose into account (starting point)

			--objectData.Object:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)
			objectData.Object:SetPosition(newPos.X, newPos.Y)
			--objectData.Object:ApplyForce(cameraMovement.X, cameraMovement.Y)

			for _, vertex in ipairs(objectData.Object:GetVertices()) do
				vertex:ApplyForce(vertexCache[vertex.id])
			end

			objectData.OriginalPosition = newPos

			continue
		end

		-- Calculate the new position of the object by adding the camera movement to its original position
		local newPosition = objectData.OriginalPosition + UDim2.fromOffset(cameraMovement.X, cameraMovement.Y)

		-- Use the ChangePosition method to directly set the new position for the object
		objectData.OriginalPosition = newPosition
		objectData.Object.Position = newPosition
	end

	prePosition = Camera.Position
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

	table.insert(Camera.Objects, objectReference)

	-- Apply position
	local cameraMovement = Camera.Position - prePosition
	if Scene.IsRigidbody(object) then
		local newPos = object.center + cameraMovement
		object:SetPosition(newPos.X, newPos.Y)
		objectReference.OriginalPosition = newPos
	else
		local newPosition = objectReference.OriginalPosition + UDim2.fromOffset(cameraMovement.X, cameraMovement.Y)
		objectReference.OriginalPosition = newPosition
		objectReference.Object.Position = newPosition
	end
end

function Camera.Detach(object: GuiBase2d | { any })
	local dataIndex = objectLookup[object]

	if dataIndex then
		table.remove(Camera.Objects, dataIndex)
	end
end

function Camera.MoveTo(x: number, y: number)
	if RunService:IsStudio() then
		warn("[Rethink] Camera is still in a prototyping phase! API is highly unstable and likely to cause problems!")
	end

	-- Update the prePosition variable with the current position of the camera
	prePosition = Camera.Position
	Camera.Position = Vector2.new(x, y)
end

function Camera.Zoom() end

-- Automatically call :Attach on every object that gets loaded
-- with scene.
-- In the future, this might get a setting to turn this behaviour off
Scene.Events.ObjectAdded:Connect(function(object)
	Camera.Attach(object)
end)

Scene.Events.FlushStarted:Connect(function()
	for _, object in ipairs(Camera.Objects) do
		Camera.Detach(object)
	end
end)

return Camera
