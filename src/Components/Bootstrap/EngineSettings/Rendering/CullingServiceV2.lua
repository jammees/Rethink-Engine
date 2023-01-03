local package = script:FindFirstAncestor("Components").Parent

local Scene = require(package.Tools.Core.Scene)
local Collision = require(package.Tools.Environment.Collision)
local Promise = require(package.Components.Library.Promise)

local objects = {}
local xLookup = {}

local CullingService = {}

function CullingService.Add(object: Instance | { any })
	table.insert(objects, object)

	local viewportSize = workspace.CurrentCamera.ViewportSize
	local isRigidbody = Scene.IsRigidbody(object)
	local visualObject: GuiBase2d = (isRigidbody and object:GetFrame()) or object

	local x = visualObject.AbsolutePosition.X

	visualObject.Destroying:Connect(function() end)

	if x < (viewportSize.X / 2) then -- If on left
	else -- On right
	end
end

function CullingService.Remove() end

function CullingService.Cleanup() end

return CullingService
