type SoundData = { Sound: Sound, Origin: Vector2, Container: Attachment }

local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)
local ObjectPoolClass = require(script.Parent.Parent.Parent.Library.ObjectPool).Class
local Camera = require(script.Parent.Parent.Camera)
local Settings = require(script.Parent.Parent.Parent.Settings)
local Sound = require(script.Parent.Sound)
local Janitor = require(script.Parent.Parent.Parent.Vendors.Janitor)
local Types = require(script.Parent.Types)
local Scene = require(script.Parent.Parent.Scene)
local SceneTypes = require(script.Parent.Parent.Scene.Types)

local container = nil

-- note to self: desmos graph is located in the settings!!!
local function CalculateEmitterPosition(x: number)
	local a = Settings.DirectionalSound.Flatness
	local b = Settings.DirectionalSound.Steepness
	local c = Settings.DirectionalSound.Range
	local offset = math.abs(b * x + c) - math.abs(b * x - c) - math.abs(b * x + a) + math.abs(b * x - a)

	return tonumber(string.format(`%.{Settings.DirectionalSound.Precision}f`, offset))
end

local Sound2D = {}
Sound2D.__index = Sound2D

function Sound2D.new(soundID: string | number, properties: Types.SoundProperties?)
	if not Settings.DirectionalSound.DirectionalAudioEnabled then
		Log.Warn(`DirectionalAudioEnabled is set to false, returning Sound instead! SoundID: {soundID}`)

		return Sound.new(soundID, properties)
	end

	Log.TAssert(t.union(t.string, t.number)(soundID))
	Log.TAssert(t.optional(t.strictInterface({
		Amount = t.optional(t.number),
		Loop = t.optional(t.boolean),
		Volume = t.optional(t.number),
		MinRange = t.optional(t.number),
		MaxRange = t.optional(t.number),
	}))(properties))
	if not properties then
		properties = {}
	end

	local self = setmetatable({}, Sound2D)

	self.Amount = properties.Amount or 5
	self.Loop = properties.Loop or false
	self.Volume = properties.Volume or 1
	self.SoundID = tostring(soundID)

	self._Instances = ObjectPoolClass.new("Sound", self.Amount, true)
	self._TrackedObjects = {}
	self._Emitter = nil
	self._Janitor = Janitor.new()

	self._Janitor:Add(
		Camera.Rendered:Connect(function()
			for _, soundData: SoundData in self._TrackedObjects do
				self:_UpdateEmitter(soundData)
			end
		end),
		"Disconnect"
	)

	return self
end

function Sound2D:_UpdateEmitter(soundData: SoundData)
	if true then
		self:_UpdateEmitterV2(soundData)
	end

	local viewportSize = workspace.CurrentCamera.ViewportSize

	local cameraPosition = Camera.Position
	local originPosition = soundData.Origin

	local unitCamera = cameraPosition / viewportSize
	local unitOrigin = originPosition / viewportSize

	local magnitude = unitOrigin - unitCamera - Vector2.one * 0.5

	local x = CalculateEmitterPosition(magnitude.X)
	local y = CalculateEmitterPosition(magnitude.Y)
	local emitterPosition = Vector2.new(x, y)

	soundData.Sound.Volume = self.Volume - emitterPosition.Magnitude
	soundData.Container.Position = Vector3.new(-emitterPosition.X, emitterPosition.Y, 0)

	soundData.Sound.Parent = if Settings.DirectionalSound.PlayLocalIfPositionZero
			and soundData.Container.Position == Vector3.zero
		then script
		else soundData.Container
end

function Sound2D:_UpdateEmitterV2(soundData: SoundData)
	local viewportSize = workspace.CurrentCamera.ViewportSize

	local originPosition = soundData.Origin
	local centerOfScreen = viewportSize / 2
	local magnitude = (originPosition - centerOfScreen) / viewportSize

	local x = CalculateEmitterPosition(magnitude.X)
	local y = CalculateEmitterPosition(magnitude.Y)
	local emitterPosition = Vector2.new(x, y)

	soundData.Sound.Volume = self.Volume - emitterPosition.Magnitude
	soundData.Container.Position = Vector3.new(-emitterPosition.X, emitterPosition.Y, 0)

	soundData.Sound.Parent = if Settings.DirectionalSound.PlayLocalIfPositionZero
			and soundData.Container.Position == Vector3.zero
		then script
		else soundData.Container
end

function Sound2D:Play(origin: Vector2)
	origin = origin or Vector2.new(0, 0)

	local soundContainer = Instance.new("Attachment")
	soundContainer.Name = self.SoundID .. " Emitter" -- added the word Emitter at the end so it sounds way more cooler and technical
	soundContainer.Parent = container

	local sound: Sound = self._Instances:Get()
	sound.SoundId = self.SoundID
	sound.Volume = self.Volume
	sound.Looped = self.Loop
	sound.Parent = soundContainer

	self._TrackedObjects[sound] = {
		Sound = sound,
		Container = soundContainer,
		Origin = origin,
	}

	if not self.Loop then
		sound.Ended:Connect(function()
			self._TrackedObjects[sound] = nil
			self._Instances:Return(sound)
			soundContainer:Destroy()
		end)
	end

	self:_UpdateEmitter(self._TrackedObjects[sound])

	sound:Play()
end

function Sound2D:SetEmitter(object: GuiBase2d | SceneTypes.Rigidbody | nil)
	if object == nil then
		self._Janitor:Remove("EmitterSignal")
		self._Emitter = nil

		return
	end

	self._Emitter = Scene.GetSceneObjectFrom(object)

	if self._Janitor:Get("EmitterSignal") then
		self._Janitor:Remove("EmitterSignal")
	end

	self:_UpdateOrigins(object.AbsolutePosition)

	self._Janitor:Add(
		self._Emitter.Object:GetPropertyChangedSignal("Position"):Connect(function()
			self:_UpdateOrigins(object.AbsolutePosition)
		end),
		"Disconnect",
		"EmitterSignal"
	)
end

function Sound2D:_UpdateOrigins(newOrigin: Vector2)
	for _, soundData: SoundData in self._TrackedObjects do
		soundData.Origin = newOrigin
		self:_UpdateEmitter(soundData)
	end
end

function Sound2D:Stop()
	for _, soundData: SoundData in self._TrackedObjects do
		soundData.Sound:Stop()
		self._Instances:Return(soundData.Sound)
		soundData.Container:Destroy()
		self._TrackedObjects[soundData.Sound] = nil
	end
end

function Sound2D:Destroy()
	self:Stop()

	for _, object in self._Instances.Objects do
		local sound: Sound = object.Object

		self._Instances:Retire(sound)
		sound:Destroy()
	end

	self._Janitor:Destroy()

	setmetatable(self._Instances, nil)
	table.clear(self._Instances)
	setmetatable(self, nil)
	table.clear(self)
end

container = Instance.new("Part")
container.Size = Vector3.new(1, 1, 1)
container.CFrame = CFrame.new()
container.Name = "SoundEmitter"
container.Anchored = true
container.Parent = workspace

return Sound2D
