type Properties = {
	Amount: number?,
	Loop: boolean?,
	Volume: number?,
}

local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)
local ObjectPoolClass = require(script.Parent.Parent.Parent.Library.ObjectPool).Class
local Camera = require(script.Parent.Parent.Camera)

local container = nil

local Sound2D = {}
Sound2D.__index = Sound2D

function Sound2D.new(soundID: string | number, properties: Properties?)
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

	soundData.Sound.Parent = if Settings.DirectionalSound.PlayLocalIfOriginZero
			and soundData.Container.Position == Vector3.zero
		then script
		else soundData.Container
end

function Sound2D:Play(origin: Vector2)
	origin = origin or Vector2.new(0, 0)

	local soundContainer = Instance.new("Attachment")
	soundContainer.Parent = container

	local sound: Sound = self.Instances:Get()
	sound.SoundId = self.SoundID
	sound.Volume = self.Volume
	sound.Looped = self.Loop
	sound.Parent = soundContainer

	if not self.Loop then
		sound.Ended:Connect(function()
			self.Instances:Return(sound)
		end)
	end

	self:_UpdateEmitter(self.TrackedObjects[sound])

	sound:Play()
end

function Sound2D:Stop()
	for _, object in self.Instances.Objects do
		local sound: Sound = object.Object
		sound:Stop()
		self.Instances:Return(sound)
	end
end

function Sound2D:Destroy()
	for _, object in self.Instances.Objects do
		local sound: Sound = object.Object

		self.Instances:Retire(sound)
		sound:Destroy()
	end

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

Camera.Rendered:Connect(function()
	local cameraPosition = Camera.Position
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local normalizedPosition = cameraPosition / viewportSize

	-- even if this looks very weird
	-- it's here to make my job easier and make the directional
	-- audio work
	normalizedPosition *= 30

	container.CFrame = CFrame.new(normalizedPosition.X, normalizedPosition.Y, 0)
end)

return Sound2D
