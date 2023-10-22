type SoundData = { Sound: Sound, Origin: Vector2, Container: Attachment }

local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)
local ObjectPoolClass = require(script.Parent.Parent.Parent.Library.ObjectPool).Class
local Camera = require(script.Parent.Parent.Camera)
local Settings = require(script.Parent.Parent.Parent.Settings)
local Sound = require(script.Parent.Sound)
local Janitor = require(script.Parent.Parent.Parent.Vendors.Janitor)
local Types = require(script.Parent.Types)

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

	self.Instances = ObjectPoolClass.new("Sound", self.Amount)
	self.TrackedObjects = {}

	self._Janitor = Janitor.new()

	self._Janitor:Add(
		Camera.Rendered:Connect(function()
			for _, soundData: SoundData in self.TrackedObjects do
				self:_UpdateEmitter(soundData)
			end
		end),
		"Disconnect"
	)

	return self
end

function Sound2D:_UpdateEmitter(soundData: SoundData)
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

function Sound2D:Play(origin: Vector2)
	origin = origin or Vector2.new(0, 0)

	local soundContainer = Instance.new("Attachment")
	soundContainer.Name = self.SoundID .. " Emitter" -- added the word Emitter at the end so it sounds way more cooler and technical
	soundContainer.Parent = container

	local sound: Sound = self.Instances:Get()
	sound.SoundId = self.SoundID
	sound.Volume = self.Volume
	sound.Looped = self.Loop
	sound.Parent = soundContainer

	self.TrackedObjects[sound] = {
		Sound = sound,
		Container = soundContainer,
		Origin = origin,
	}

	if not self.Loop then
		sound.Ended:Connect(function()
			self.TrackedObjects[sound] = nil
			self.Instances:Return(sound)
			soundContainer:Destroy()
		end)
	end

	self:_UpdateEmitter(self.TrackedObjects[sound])

	sound:Play()
end

function Sound2D:Stop()
	for _, soundData: SoundData in self.TrackedObjects do
		soundData.Sound:Stop()
		self.Instances:Return(soundData.Sound)
		soundData.Container:Destroy()
		self.TrackedObjects[soundData.Sound] = nil
	end
end

function Sound2D:Destroy()
	self:Stop()

	for _, object in self.Instances.Objects do
		local sound: Sound = object.Object

		self.Instances:Retire(sound)
		sound:Destroy()
	end

	self._Janitor:Destroy()

	setmetatable(self.Instances, nil)
	table.clear(self.Instances)
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
