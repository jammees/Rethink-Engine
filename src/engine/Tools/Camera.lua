local package = script.Parent.Parent
local components = package.Components

local wrapper = require(components.Wrapper)

local camera = wrapper.Wrap()

local cameraContainer = camera.CameraCont
local canvas = camera.Canvas
local layer = camera.Layer

local lastPosition = nil

-- selfs
camera.bindTo = nil

function camera:Render(deltaTime)
	if self.bindTo then
		if lastPosition ~= self.bindTo.Position then
			lastPosition = self.bindTo.Position
			local vectorDir = (self.bindTo.Position - cameraContainer.Position) * deltaTime

			for _, object in ipairs(canvas:GetChildren()) do
				object.Position += vectorDir
			end

			for _, object in ipairs(layer:GetChildren()) do
				object.Position += vectorDir
			end
		end
	end
end

function camera:BindTo(instance: Instance)
	self.bindTo = instance
end

return camera
