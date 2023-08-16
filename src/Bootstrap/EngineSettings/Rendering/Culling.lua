--[[
	Simple implementation of culling for UI instances.
]]

type ObjectData = {
	Object: Instance | { any },
	VObject: GuiBase2d,
	Score: number,
	AlreadyVisible: number,
	Processed: boolean,
	ShouldCull: boolean,
}

local package = script:FindFirstAncestor("Components").Parent

local Scene = require(package.Tools.Core.Scene)
local Collision = require(package.Tools.Environment.Collision)
local Promise = require(package.Components.Vendors.Promise)

-- Checks if an object is not visible.
local function IsOutOfBounds(object: GuiBase2d)
	local viewportSize = workspace.CurrentCamera.ViewportSize

	local size = object.AbsoluteSize
	local position = object.AbsolutePosition

	local LeftOut = position.X <= -size.X
	local RightOut = position.X >= viewportSize.X
	local UpOut = position.Y <= -size.Y
	local DownOut = position.Y >= viewportSize.Y

	if LeftOut or RightOut or UpOut or DownOut then
		return true
	end

	return false
end

-- Calculates the scores based on the size of the instances.
-- After that it sorts the table from highest to lowest.
local function CalculateScores(objects)
	local scores = {}

	for index, object in ipairs(objects) do
		local isRigidbody = Scene.IsRigidbody(object)
		local visualObject: GuiBase2d = (isRigidbody and object:GetFrame()) or object

		local sizeScore = visualObject.AbsoluteSize.X + visualObject.AbsoluteSize.Y
		local objectData: ObjectData = {
			Object = object,
			VObject = visualObject,
			Score = sizeScore,
			--AlreadyVisible = visualObject.Visible,

			Processed = false,
			ShouldCull = false,
		}

		table.insert(scores, index, objectData)
	end

	table.sort(scores, function(a, b)
		return a.Score > b.Score
	end)

	return scores
end

local Culling = {}
Culling.IsRunning = false
Culling.Objects = {}

function Culling.Run()
	return Promise.new(function(resolve, reject)
		if Culling.IsRunning then
			reject()
		end

		Culling.IsRunning = true

		local objectScores = CalculateScores(Culling.Objects)

		for _, collider: ObjectData in ipairs(objectScores) do
			for _, hitter: ObjectData in ipairs(objectScores) do
				local isObjectSame = collider == hitter
				local isObstructed = Collision.isInCore(hitter.VObject, collider.VObject)
				local isOutOfBounds = IsOutOfBounds(hitter.VObject)

				if isObjectSame then
					-- If the object has not been processed, then hide it.
					-- If it is a rigidbody as well, enable the physics.
					if hitter.Processed == false then
						if Scene.IsRigidbody(hitter.Object) then
							hitter.Object.ShouldCalculatePhysics = true
						end

						hitter.VObject.Visible = true
					end

					continue
				end

				if isObstructed or isOutOfBounds then
					hitter.Processed = true
					hitter.ShouldCull = true

					-- Check if the object is a rigidbody.
					-- If it is, disable the physics.
					if Scene.IsRigidbody(hitter.Object) and isOutOfBounds then
						hitter.Object.ShouldCalculatePhysics = false
					end

					hitter.VObject.Visible = false
				end
			end
		end

		Culling.IsRunning = false
		resolve()
	end):catch(print)
end

function Culling.Add(object: Instance | { any })
	table.insert(Culling.Objects, object)
end

function Culling.Remove(object: Instance | { any })
	table.remove(Culling.Objects, table.find(Culling.Objects, object))
end

function Culling.Cleanup()
	table.clear(Culling.Objects)
end

return Culling
