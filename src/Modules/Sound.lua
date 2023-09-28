type Properties = {
	Volume: number,
	Loop: boolean,
}

local SoundService = game:GetService("SoundService")
local ContentProviderService = game:GetService("ContentProvider")

local Settings = require(script.Parent.Parent.Settings)
local Log = require(script.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Vendors.t)

local Sound = {}
Sound.__index = Sound

function Sound.new(soundID: string | number, properties: Properties?)
	Log.TAssert(t.union(t.string, t.number)(soundID))
	Log.TAssert(t.optional(t.strictInterface({
		Volume = t.optional(t.number),
		Loop = t.optional(t.boolean),
	}))(properties))

	local self = setmetatable({}, Sound)

	self.SoundID = soundID
	self.Properties = properties
	self.Volume = properties and properties.Volume or 1
	self.Loop = properties and properties.Loop or false

	self.Instances = {}

	return self
end

function Sound.FromInstance(soundInstance: Sound)
	Log.TAssert(t.instanceIsA("Sound")(soundInstance))

	return Sound.new(soundInstance.SoundId, {
		Volume = soundInstance.Volume,
		Loop = soundInstance.Looped,
	})
end

function Sound:ToInstance()
	local soundInstance = Instance.new("Sound")
	soundInstance.Volume = self.Volume
	soundInstance.Name = self.SoundID
	soundInstance.Looped = self.Loop
	soundInstance.SoundId = self.SoundID
	soundInstance.Parent = script

	ContentProviderService:PreloadAsync({ soundInstance })

	return soundInstance
end

function Sound:PlayLocal()
	-- SoundService:PlayLocalSound(self.Instance)
	local sound: Sound = self:ToInstance()
	sound.Parent = script

	sound.Ended:Once(function()
		table.remove(self.Instances, table.find(self.Instances, sound))
		sound:Destroy()
	end)

	table.insert(self.Instances, sound)

	sound:Play()
end

function Sound:_GetScaleFromOrigin(origin: Vector2)
	Log.TAssert(t.Vector2(origin))

	local viewportSize = workspace.CurrentCamera.ViewportSize

	local x = origin.X / viewportSize.X - 0.5

	-- Make a virtual graph to control the dropoff scale
	-- If not sure what it looks like hop onto a graph
	-- editor such as Desmos.
	local a = Settings.DirectionalSound.Flatness
	local b = Settings.DirectionalSound.Steepness
	local c = Settings.DirectionalSound.Range

	return math.abs(b * x + c) - math.abs(b * x - c) - math.abs(b * x + a) + math.abs(b * x - a)
end

function Sound:_ApplyDirectionalData(scale: number, soundInstance: Sound)
	Log.TAssert(t.number(scale))
	Log.TAssert(t.instanceIsA("Sound")(soundInstance))

	soundInstance.Volume = self.Volume - math.abs(scale * Settings.DirectionalSound.RolloffMultiplier)

	SoundService:SetListener(Enum.ListenerType.CFrame, CFrame.new(-scale, 0, 0))
end

-- A function which returns a Vector2
-- after each call
function Sound:PlayGlobal(origin: Vector2 | () -> Vector2)
	if not Settings.DirectionalSound.DirectionalAudioEnabled then
		return self:PlayLocal()
	end

	Log.TAssert(t.union(t.Vector2, t.callback)(origin))

	local listenerType, listenerParam = SoundService:GetListener()

	local container = Instance.new("Part")
	container.Name = "GlobalSoundPlayerContainer"
	container.Parent = workspace

	local sound: Sound = self:ToInstance()
	sound.Parent = container

	local function GetOriginValue(soundOrigin: Vector2 | () -> Vector2)
		return t.callback(soundOrigin) and soundOrigin() or soundOrigin
	end

	self:_ApplyDirectionalData(self:_GetScaleFromOrigin(GetOriginValue(origin)), sound)

	sound.Ended:Once(function()
		table.remove(self.Instances, table.find(self.Instances, sound))
		container:Destroy()

		SoundService:SetListener(listenerType, listenerParam)
	end)

	if self.Loop then
		sound.DidLoop:Connect(function()
			self:_ApplyDirectionalData(self:_GetScaleFromOrigin(GetOriginValue(origin)), sound)
		end)
	end

	table.insert(self.Instances, sound)

	sound:Play()
end

function Sound:Stop()
	-- self.Instance:Stop()
	for _, soundInstance: Sound in self.Instances do
		soundInstance.Parent:Destroy()
	end
end

return Sound
