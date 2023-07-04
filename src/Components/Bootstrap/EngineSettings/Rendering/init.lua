type ObjectData = {
	Object: Instance | { any },
	VObject: GuiBase2d,
	Score: number,
	AlreadyVisible: number,
	Processed: boolean,
	ShouldCull: boolean,
}

local LIGHTING_PROPERTIES = {
	ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
	ColorShift_Top = Color3.fromRGB(0, 0, 0),
	OutdoorAmbient = Color3.fromRGB(0, 0, 0),
	FogColor = Color3.fromRGB(0, 0, 0),
	Ambient = Color3.fromRGB(0, 0, 0),
	GeographicLatitude = 0,
	Brightness = 0,
	GlobalShadows = false,
	ClockTime = 0,
	FogEnd = 0,
}

local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Components").Parent

local Scene = require(package.Tools.Core.Scene)

return {
	Disable3DRendering = function(value: any)
		if value then
			RunService.Heartbeat:Connect(function()
				workspace.CurrentCamera.FieldOfView = 1
				workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
				workspace.CurrentCamera.CFrame = CFrame.new()
			end)
		end
	end,

	DisablePlayerCharacters = function(value: any)
		if value then
			local function DeleteCharacter()
				-- Iterate trough all players and flag their characters
				for _, player in ipairs(game.Players:GetPlayers()) do
					-- wait for the character if not loaded
					if not player.Character then
						player.CharacterAdded:Wait()
					end

					CollectionService:AddTag(player.Character, "__Rethink_Flag_Destroy")
				end

				-- Delete flagged characters
				for _, taggedCharacters in ipairs(CollectionService:GetTagged("__Rethink_Flag_Destroy")) do
					taggedCharacters:Destroy()
				end
			end

			game.Players.PlayerAdded:Connect(function()
				DeleteCharacter()
			end)

			DeleteCharacter()
		end
	end,

	OptimizeLighting = function(value: any)
		if value then
			for propName, propValue in pairs(LIGHTING_PROPERTIES) do
				Lighting[propName] = propValue
			end
		end
	end,

	EnableCoreGuis = function(values: { [string]: boolean })
		for enumName, state in pairs(values) do
			local r, c = pcall(function()
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[enumName], state)
			end)

			if not r then
				warn(c)
			end
		end
	end,

	-- This is an attempt to optimize gui elements by hiding them if they are obstructed or
	-- out of the screen.

	CullGuiElements = function(value: boolean)
		if value then
			local JanitorCullGuiElements = require(script.Parent.Parent.Parent.Library.Janitor).new()
			local Promise = require(script.Parent.Parent.Parent.Library.Promise)
			local Collision = require(script.Parent.Parent.Parent.Parent.Tools.Environment.Collision)

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

			local function CalculateScores(objects)
				local scores = {}
				local pointers = {}

				for index, object in ipairs(objects) do
					local isRigidbody = Scene.IsRigidbody(object.Object)
					local visualObject: Instance = (isRigidbody and object.Object:GetFrame()) or object.Object

					local sizeScore = visualObject.AbsoluteSize.X + visualObject.AbsoluteSize.Y
					local objectData: ObjectData = {
						Object = object.Object,
						VObject = visualObject,
						Score = sizeScore,
						AlreadyVisible = visualObject.Visible,

						Processed = false,
						ShouldCull = false,
					}

					table.insert(scores, index, objectData)
					pointers[visualObject] = index
				end

				table.sort(scores, function(a, b)
					return a.Score > b.Score
				end)

				return scores, pointers
			end

			local isCulling = false
			local function CullObjects()
				return Promise.new(function(resolve, reject)
					-- STEP 1:
					-- Check if the object is out of bounds
					if isCulling then
						reject("Culling is already running!")
					end

					isCulling = true

					local objectScores = CalculateScores(Scene.GetObjects())

					for _, objectData: ObjectData in ipairs(objectScores) do
						if IsOutOfBounds(objectData.VObject) and objectData.VObject.Transparency < 1 then
							objectData.Processed = true
							objectData.ShouldCull = true
						end
					end

					resolve(objectScores)
				end)
					:andThen(function(objectScores: { ObjectData })
						-- STEP 2:
						-- Check if objects are getting obstructed by other obhect
						for _, objectData: ObjectData in ipairs(objectScores) do
							local vObject = objectData.VObject

							for _, subObjectData in ipairs(objectScores) do
								local ivObject = subObjectData.VObject

								local isObjectSame = ivObject == vObject
								local isInCore = Collision.isInCore(ivObject, vObject)

								if isObjectSame or not isInCore then
									continue
								end

								subObjectData.Processed = true
								subObjectData.ShouldCull = true
							end
						end

						return objectScores
					end)
					:andThen(function(objectScores: { ObjectData })
						-- STEP 3:
						-- Finalize
						for _, objectData: ObjectData in ipairs(objectScores) do
							if objectData.ShouldCull == false then
								objectData.VObject.Visible = true --objectData.AlreadyVisible
								continue
							end

							objectData.VObject.Visible = false

							print(objectData.VObject, objectData)
						end

						isCulling = false
					end)
					:catch(warn)
			end

			-- Handle the connections
			Scene.Events.ObjectAdded:Connect(function(object)
				local isRigidbody = Scene.IsRigidbody(object)
				local visualObject: Instance = (isRigidbody and object:GetFrame()) or object

				JanitorCullGuiElements:Add(
					visualObject:GetPropertyChangedSignal("Position"):Connect(CullObjects),
					"Disconnect"
				)
			end)

			Scene.Events.FlushStarted:Connect(function()
				JanitorCullGuiElements:Cleanup()
			end)

			Scene.Events.ObjectRemoved:Connect(function() end)
		end
	end,
}
