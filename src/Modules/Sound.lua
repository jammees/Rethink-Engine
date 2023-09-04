type Properties = {
	Volume: string | number,
	-- Loop: boolean,
}

local SoundService = game:GetService("SoundService")
local ContentProviderService = game:GetService("ContentProvider")

local Sound = {}
Sound.__index = Sound

function Sound.new(soundID: string | number, properties: Properties)
	local self = setmetatable({}, Sound)

	self.SoundID = soundID
	self.Volume = properties and properties.Volume or 1
	-- self.Loop = properties and properties.Loop or false

	self.Instance = self:ToInstance()
	self.EndedConnection = nil

	return self
end

function Sound.FromInstance() end

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
		sound:Destroy()
	end)

	sound:Play()
end

function Sound:PlayGlobal(origin: Vector2)
	local viewportSize = workspace.CurrentCamera.ViewportSize

	local listenerType, listenerParam = SoundService:GetListener()

	-- Make a virtual graph to control the dropoff scale
	-- If not sure what it looks like hop onto a graph
	-- editor such as Desmos.
	local a = 0.101
	local b = 0.6
	local c = 0.6
	local x = origin.X / viewportSize.X - 0.5

	local scale = math.abs(b * x + c) - math.abs(b * x - c) - math.abs(b * x + a) + math.abs(b * x - a)

	local container = Instance.new("Part")
	container.Name = "GlobalSoundPlayerContainer"
	container.Parent = workspace

	local sound: Sound = self:ToInstance()
	sound.Volume = 1 - math.abs(scale)
	sound.Parent = container

	sound.Ended:Once(function()
		container:Destroy()
		SoundService:SetListener(listenerType, listenerParam)
	end)

	SoundService:SetListener(Enum.ListenerType.CFrame, CFrame.new(-scale, 0, 0))

	sound:Play()
end

function Sound:Stop()
	self.Instance:Stop()
end

return Sound
