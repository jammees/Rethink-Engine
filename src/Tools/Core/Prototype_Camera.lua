type ObjectData = {
	OldPosition: Vector2,
	RenderData: Vector2,
}

local Scene = require(script.Parent.Scene)

local trackedLookup = {}
local trackedObjects = {}
local objectData = {}

local updateCounter = 0
local renderCounter = 0

local Camera = {}
Camera.Position = Vector2.new(0, 0)

-- Update should pre-calculate all the necessary informations
function Camera.Update()
	for _, object: GuiBase2d in ipairs(trackedObjects) do
		--objectData[object] = math.sin(tick()) * 5
		if Scene.IsRigidbody(object) then
			continue
		end

		local objData: ObjectData = objectData[object]

		local currentPosition = object.Position

		local deltaX = currentPosition.X.Offset - objData.OldPosition.X
		local deltaY = currentPosition.Y.Offset - objData.OldPosition.Y

		objData.RenderData = Vector2.new(deltaX, deltaY)
	end

	updateCounter += 1
end

-- Render should apply those calculations done by .Update()
function Camera.Render()
	if updateCounter ~= renderCounter + 1 then
		renderCounter = updateCounter

		print(
			`Desynchronization detected! updateCounter = {updateCounter}, renderCounter = {renderCounter + 1}, renderCounter is bigger than updateCounter! Did .Render got called before .Update?`
		)

		return
	end

	for _, object in ipairs(trackedObjects) do
		Camera.RenderIndividual(object)
	end

	renderCounter += 1
end

function Camera.RenderIndividual(object: any)
	local objData: ObjectData = objectData[object]

	if Scene.IsRigidbody(object) then
		return
	end

	--local object: GuiBase2d = Scene.IsRigidbody(object) and object:GetFrame() or object
	--frame.Rotation = objectData[object]

	object.Position =
		UDim2.new(object.Position.X.Scale, objData.RenderData.X, object.Position.Y.Scale, objData.RenderData.Y)
end

Scene.Events.ObjectAdded:Connect(function(object: any)
	local reservedPosition = #trackedObjects + 1
	trackedObjects[reservedPosition] = object
	trackedLookup[object] = reservedPosition

	-- Add intital data to the objectData litt
	objectData[object] = {
		OldPosition = object.AbsolutePosition,
		RenderData = Vector2.new(0, 0),
	}

	Camera.RenderIndividual(object)
end)

Scene.Events.ObjectRemoved:Connect(function(object: any)
	table.remove(trackedObjects, trackedLookup[object])
	trackedLookup[object] = nil
	objectData[object] = nil
end)

return Camera
