-- A terrible unit test code
-- that was totally really fun writing :)

local CollectionService = game:GetService("CollectionService")

local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local Scene = Rethink.Scene

local Type = Scene.Symbols.Type

local function clear()
	if #Scene:GetObjects() > 0 then
		Scene:Flush()
	end
end

local function load()
	Scene:Load({ Name = "test", CompileMode = "Standard" }, {
		My_Container = {
			[Type] = "Layer",
			My_group = { EMPTY = {} },
		},
	})
end

local function clearAndLoad()
	clear()
	load()
end

local dummyFrame = nil

local function createDummyFrame()
	if dummyFrame then
		Scene:Remove(dummyFrame)
		dummyFrame:Destroy()
	end

	dummyFrame = Instance.new("Frame")
	dummyFrame.Size = UDim2.fromOffset(100, 100)
	dummyFrame.Parent = Rethink.Ui.Layer

	print("Created dummy frame!")

	return dummyFrame
end

return function()
	describe("Scene:GetSignal()", function()
		it("should not throw", function()
			expect(function()
				Scene:GetSignal("LoadStarted")
			end).to.never.throw()
		end)

		it("should return a signal class", function()
			expect(function()
				Scene:GetSignal("LoadStarted"):Fire()
			end).to.never.throw()
		end)
	end)

	describe("Scene:Load()", function()
		beforeEach(function()
			clear()
		end)

		afterAll(function()
			clear()
		end)

		it("should not throw", function()
			expect(function()
				load()
			end).to.never.throw()
		end)

		it("should throw on wrong type: SceneConfig", function()
			expect(function()
				Scene:Load(true, {})
			end)
		end)

		it("should throw on wrong type: SceneTable", function()
			expect(function()
				Scene:Load({}, true)
			end)
		end)

		it("should populate the objects array", function()
			load()

			expect(Scene:GetObjects()).to.be.ok()
			expect(#Scene:GetObjects() > 0).to.equal(true)
		end)

		it("should fire the LoadStarted signal", function()
			local loadStartedSignal = Scene:GetSignal("LoadStarted")

			local receivedCall = false
			loadStartedSignal:Connect(function()
				receivedCall = true
			end)

			load()

			expect(receivedCall).to.equal(true)
		end)

		it("should fire the LoadFinished signal", function()
			local loadFinisedSignal = Scene:GetSignal("LoadFinished")

			local receivedCall = false
			loadFinisedSignal:Connect(function()
				receivedCall = true
			end)

			load()

			expect(receivedCall).to.equal(true)
		end)
	end)

	describe("Scene:Flush()", function()
		beforeEach(function()
			clearAndLoad()
		end)

		afterAll(function()
			clear()
		end)

		it("should not throw", function()
			expect(function()
				Scene:Flush()
			end).to.never.throw()
		end)

		it("should wipe the scene objects table", function()
			Scene:Flush()

			warn(#Scene:GetObjects())

			expect(#Scene:GetObjects() == 0).to.equal(true)
		end)
	end)

	describe("Scene:Add()", function()
		it("should not throw", function()
			expect(function()
				Scene:Add(createDummyFrame())
			end).to.never.throw()
		end)

		it("should throw on wrong type: object", function()
			expect(function()
				Scene:Add(true)
			end).to.throw()
		end)

		it("should throw on wrong type: tags", function()
			expect(function()
				Scene:Add(createDummyFrame(), true)
			end).to.throw()
		end)

		it("should throw on wrong type: DAF", function()
			expect(function()
				Scene:Add(createDummyFrame(), "Hello", "world!")
			end).to.throw()
		end)

		it("should add a tag to the object", function()
			local tag = "Hello world!"

			local myFrame = createDummyFrame()

			Scene:Add(myFrame, tag)

			print(Scene:GetObjects())

			expect(#CollectionService:GetTagged(tag) > 0).to.equal(true)
			expect(CollectionService:GetTagged(tag)[1] == myFrame).to.equal(true)
		end)

		it("should keep the object after flush", function()
			local myFrame = createDummyFrame()

			Scene:Add(myFrame, nil, false)

			Scene:Flush()

			expect(myFrame).to.be.ok()
		end)
	end)

	describe("Sene:Remove()", function()
		it("should not throw", function()
			expect(function()
				Scene:Remove(dummyFrame)
			end).to.never.throw()
		end)

		it("should throw on wrong type: object", function()
			expect(function()
				Scene:Remove(true)
			end).to.throw()
		end)

		it("should remove the object from sceneObjects", function()
			Scene:Flush()

			Scene:Add(createDummyFrame())

			local oldSize = #Scene:GetObjects()

			print("old size ", oldSize)

			Scene:Remove(dummyFrame)

			print("new size", #Scene:GetObjects())
			print("objects", Scene:GetObjects())

			expect(oldSize > #Scene:GetObjects()).to.equal(true)
		end)
	end)
end
