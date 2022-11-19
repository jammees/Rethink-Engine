local LIGHTING_PROPERTIES = {
	Ambient = Color3.fromRGB(0, 0, 0),
	Brightness = 0,
	ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
	ColorShift_Top = Color3.fromRGB(0, 0, 0),
	GlobalShadows = false,
	OutdoorAmbient = Color3.fromRGB(0, 0, 0),
	FogColor = Color3.fromRGB(0, 0, 0),
	ClockTime = 4,
	GeographicLatitude = 0,
}

local Lighting = game:GetService("Lighting")
local HTTPService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local package = script.Parent.Parent.Parent.Parent.Parent

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

	Prototype_1V_GuiCulling = function(value: boolean, template: { any })
		if value then
			local Scene = require(package.Tools.Core.Scene)
			local Rigidbody = require(package.Tools.Environment.Physics.Physics.RigidBody)
			local Janitor = require(package.Components.Lib.Janitor).new()

			local function IsGUIObjectOnScreen(Object)
				local CurrentCamera = workspace.CurrentCamera
				local ScreenSize = CurrentCamera.ViewportSize
				local Position, Size = Object.AbsolutePosition, Object.AbsoluteSize
				local Bounds = {
					X = {
						Min = -Size.X,
						Max = ScreenSize.X,
					},
					Y = {
						Min = -Size.Y - 36,
						Max = ScreenSize.Y - 36,
					},
				}

				if
					Position.X <= Bounds.X.Min
					or Position.X >= Bounds.X.Max
					or Position.Y <= Bounds.Y.Min
					or Position.Y >= Bounds.Y.Max
				then
					return false
				end

				return true
			end

			local objectLookup = {}

			--[[

				TODO:

				psuedo code:

				listen for ObjectAdded
					hook a :GetPropertyChangedSignal
						track every objects positions

						if position changes and not the same then
							create an empty table
							loop trough every object
							assign a score given by the absolute size
							sort the table
							
							loop trough table
								use Collision and check for nearby objects with the tracked positions
								
								if the object is in the core (biggest object) then
									check if it's a rigidbody
										disable physics calculations
									
									hide the object

					

			]]

			Scene.Events.ObjectAdded:Connect(function(object)
				local isRigidbody = getmetatable(object.Object) == Rigidbody
				local visualObject: Instance = (isRigidbody and object.Object:GetFrame()) or object.Object
				local generatedId = HTTPService:GenerateGUID(false)

				objectLookup[generatedId] = {
					Object = object,
					VisualObject = visualObject,
					IsRigidbody = isRigidbody,
				}

				Janitor:Add(
					visualObject:GetPropertyChangedSignal("Position"):Connect(function()
						print("Position changed for", visualObject)
					end),
					"Disconnect",
					generatedId
				)
			end)
		end
	end,
}
