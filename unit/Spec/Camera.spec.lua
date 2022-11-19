local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local Camera = Rethink.Camera

local mockAttached = {}
local currentFrame

local function testSetup(name: string)
	if currentFrame then
		pcall(function()
			Camera:Detach(currentFrame)
		end)
		currentFrame:Destroy()
	end

	currentFrame = Instance.new("Frame")
	currentFrame.Name = type(name) ~= "nil" and name or "frame"
	currentFrame.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	currentFrame.Size = UDim2.fromOffset(100, 100)
	currentFrame.Parent = Rethink.Ui.Layer

	if #mockAttached > 0 then
		for _, v in ipairs(mockAttached) do
			pcall(function()
				Camera:Detach(v)
			end)
			v:Destroy()
		end
	end
end

local function createAttachedMockedFrames(num: number)
	for i = 1, num do
		local frame = Instance.new("Frame")
		frame.Name = type(name) ~= "nil" and name or "frame"
		frame.Position = UDim2.fromOffset(math.random(0, 500), math.random(0, 500))
		frame.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		frame.Size = UDim2.fromOffset(100, 100)
		frame.Parent = Rethink.Ui.Layer

		Camera:Attach(frame)
		table.insert(mockAttached, frame)
	end
end

return function()
	describe("Camera :Attach()", function()
		FIXME("Not working due to api changes!")

		it("should not throw", function()
			testSetup("should not throw")

			expect(function()
				Camera:Attach(currentFrame)
			end).to.never.throw()
		end)

		it("should add to attached objects", function()
			testSetup("should add to attached objects")

			Camera:Attach(currentFrame)

			createAttachedMockedFrames(4)

			local attachedObjects = Camera.attachedObjects
			local result = nil
			for _, v in ipairs(attachedObjects) do
				if v.Object == anotherFrame then
					result = v.Object
				end
			end

			expect(#attachedObjects > 0).to.equal(true)
			expect(result).to.never.be.ok()
		end)

		it("should throw if object is :Attached() twice", function()
			testSetup("should throw if object is :Attached() twice")

			expect(function()
				Camera:Attach(currentFrame)
				Camera:Attach(currentFrame)
			end).to.throw()
		end)

		it("should throw on wrong type", function()
			expect(function()
				Camera:Attach(true)
			end).to.throw()
		end)
	end)

	describe("Camera :Detach()", function()
		FIXME("Not working due to api changes!")

		it("should not throw", function()
			testSetup("should not throw - :Detach()")

			Camera:Attach(currentFrame)
			expect(function()
				Camera:Detach(currentFrame)
			end).to.never.throw()
		end)

		it("should throw on wrong type", function()
			expect(function()
				Camera:Detach(true)
			end).to.throw()
		end)

		it("Should remove frame from .attachedObjects", function()
			testSetup("Should remove frame from .attachedObjects")

			Camera:Attach(currentFrame)

			local attachedObjectsSize = #Camera.attachedObjects

			Camera:Detach(currentFrame)

			local foundAttachedFrame = false

			for _, v in ipairs(Camera.attachedObjects) do
				if v.Object == currentFrame then
					warn("Found attached object!")
					foundAttachedFrame = true
				end
			end

			expect(foundAttachedFrame).to.equal(false)
			expect(#Camera.attachedObjects < attachedObjectsSize).to.equal(true)
		end)

		it("should throw if object is not attached", function()
			expect(function()
				Camera:Detach(currentFrame)
			end).to.throw()
		end)
	end)
end
