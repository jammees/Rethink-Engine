---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink).Init()
---@module src.Library.ObjectPool
local ObjectPool = Rethink.GetModules().Template.FetchGlobal("__Rethink_Pool")

local Scene = Rethink.GetModules().Scene
local Symbols = Scene.Symbols

local objects = {}
local count = 0

Scene.Events.ObjectAdded:Connect(function(obj)
	count += 1
	objects[obj] = count
	warn(`{objects[obj]} {obj} added`)
end)

Scene.Events.ObjectRemoved:Connect(function(obj)
	warn(`{objects[obj]} {obj} removed`)
	objects[obj] = nil
end)

local function GetLenght(tbl)
	local c = 0

	for _ in tbl do
		c += 1
	end

	return c
end

return function()
	beforeAll(function()
		Scene.Flush()
	end)

	afterAll(function()
		Scene.Flush()
	end)

	describe("Scene.Symbols", function()
		it("should be a table", function()
			expect(Scene.Symbols).to.be.a("table")
		end)

		it("should return symbol data when indexed", function()
			expect(Scene.Symbols.Tag).to.be.ok()
		end)

		it("should error if non-existent symbol is indexed", function()
			expect(function()
				local _ = Scene.Symbols.NonExistentSymbol
			end).to.throw()
		end)

		it("should error if new index", function()
			expect(function()
				Scene.Symbols.NonExistentSymbol = true
			end).to.throw()
		end)
	end)

	describe("Scene.State", function()
		it("should be a string", function()
			expect(Scene.State).to.be.a("string")
		end)
	end)

	describe("Scene.Events", function()
		it("should error if new index", function()
			expect(function()
				Scene.Events.NonExistentEvent = true
			end).to.throw()
		end)

		it("should return a connection", function()
			local signal = Scene.Events.FlushStarted
			local connection = signal:Connect(function() end)

			expect(signal).to.be.ok()
			expect(connection).to.be.ok()
		end)
	end)

	describe("Scene.Load()", function()
		afterEach(function()
			-- for _, object in Scene.GetObjects() do
			-- 	Scene.Cleanup(object.Object)
			-- end

			Scene.Flush()
		end)

		it("should throw if wrong arguments are passed", function()
			expect(function()
				Scene.Load(true)
			end).to.throw()
		end)

		it("should halt if loading", function()
			local scene = { Name = "HaltIfLoading" }

			Scene.State = "Loading"
			Scene.Load(scene)

			expect(GetLenght(Scene.GetObjects())).to.equal(0)

			Scene.State = "Standby"
		end)

		it("should halt if State = Flushing", function()
			local scene = { Name = "HaltIfFlushing" }

			Scene.State = "Flushing"
			Scene.Load(scene)

			expect(GetLenght(Scene.GetObjects())).to.equal(0)

			Scene.State = "Standby"
		end)

		it("should load a scene", function()
			local scene = {
				Name = "LoadObject",

				{ LoadObject = {} },
			}

			Scene.Load(scene)

			expect(require(Rethink.Self.Modules.Scene.Compiler).GetScene(scene)).to.be.ok()
			expect(GetLenght(Scene.GetObjects())).to.equal(1)
		end)

		it("should add symbols/properties correctly", function()
			local scene = {
				Name = "AddSymbolsProperties",

				{
					[Symbols.Property] = {
						ClipsDescendants = true,
					},

					AddSymbolsProperties = {
						BackgroundTransparency = 0.5,

						[Symbols.Tag] = "Tag",
						[Symbols.LinkTag] = "LinkTag",
						[Symbols.LinkGet("LinkTag")] = function(thisObject: Frame, linkedObjects)
							thisObject.SelectionImageObject = linkedObjects[1]
						end,
					},
				},
			}

			Scene.Load(scene)

			local obj: Frame = Scene.GetFromTag("Tag")[1]

			expect(obj).to.be.ok()
			expect(obj.SelectionImageObject).to.equal(obj)
			expect(obj.Name).to.equal("AddSymbolsProperties")
			expect(obj.BackgroundTransparency).to.equal(0.5)
			expect(obj.ClipsDescendants).to.equal(true)

			-- Scene.Cleanup(obj)
		end)

		it("should create rigidbodies", function()
			local scene = {
				Name = "Rigidbodies",

				{
					[Symbols.Type] = "Rigidbody",
					Rigidbody = {
						[Symbols.Tag] = "Tag",
					},
				},
			}

			Scene.Load(scene)
			expect(require(Rethink.Self.Modules.Scene.Compiler).GetScene(scene)).to.be.ok()
			expect(GetLenght(Scene.GetObjects())).to.equal(1)

			local obj = Scene.GetFromTag("Tag")[1]

			expect(obj).to.be.a("table")
			expect(Scene.IsRigidbody(obj)).to.equal(true)
		end)
	end)

	describe("Scene.Add()", function()
		afterEach(function()
			-- for _, object in Scene.GetObjects() do
			-- 	Scene.Cleanup(object.Object)
			-- end

			Scene.Flush()
		end)

		it("should throw if wrong arguments are passed", function()
			expect(function()
				Scene.Add(true)
			end).to.throw()

			expect(function()
				Scene.Add({}, true)
			end).to.throw()
		end)

		it("should add object to scene", function()
			local frame = ObjectPool:Get("Frame")

			Scene.Add(frame)

			local ref = Scene.GetObjectReference(frame)

			expect(ref).to.be.ok()
			expect(ref.Object).to.equal(frame)
		end)

		it("should cleanup object", function()
			local frame = ObjectPool:Get("Frame")

			Scene.Add(frame)

			local ref = Scene.GetObjectReference(frame)
			ref.Janitor:Destroy()

			expect(GetLenght(Scene.GetObjects())).to.equal(0)
			expect(function()
				Scene.GetObjectReference(frame)
			end).to.throw()
		end)
	end)

	describe("Scene.AddSymbols()", function()
		afterEach(function()
			Scene.Flush(true)
		end)

		it("should throw if wrong arguments are passed", function()
			expect(function()
				Scene.Add(true)
			end).to.throw()

			expect(function()
				Scene.Add({}, true)
			end).to.throw()
		end)

		it("should correctly add object with symbols to scene", function()
			local frame = ObjectPool:Get("Frame")
			local symbols = {
				[Symbols.Tag] = "Tag",
				[Symbols.LinkTag] = "LinkTag",
				[Symbols.Property] = {
					BackgroundTransparency = 0.5,
					Name = "SomethingSomething",
				},
				[Symbols.LinkGet("LinkTag")] = function(thisObject: Frame, linkedObjects)
					thisObject.SelectionImageObject = linkedObjects[1]
				end,
			}

			Scene.Add(frame, symbols)

			local ref = Scene.GetObjectReference(frame)

			expect(ref).to.be.ok()
			expect(ref.Object).to.equal(frame)
			expect(ref.Object.Name).to.equal("SomethingSomething")
			expect(ref.Object.SelectionImageObject).to.equal(frame)
			expect(ref.Object.BackgroundTransparency).to.equal(0.5)
			expect(table.find(ref.Object:GetTags(), "Tag")).to.be.ok()
		end)
	end)

	describe("Scene.Remove()", function()
		afterEach(function()
			-- for _, object in Scene.GetObjects() do
			-- 	Scene.Cleanup(object.Object)
			-- end

			Scene.Flush()
		end)

		it("should throw if wrong arguments are passed", function()
			expect(function()
				Scene.Remove(1)
			end).to.throw()

			expect(function()
				Scene.Remove({}, 1)
			end).to.throw()
		end)

		it("should error if unknown object is removed", function()
			expect(function()
				Scene.Remove(Instance.new("Frame"))
			end).to.throw()
		end)

		it("should remove object from scene", function()
			local frame: Frame = ObjectPool:Get("Frame")
			local path = frame:GetFullName()

			Scene.Add(frame)

			local ref = Scene.GetObjectReference(frame)

			expect(ref).to.be.ok()
			expect(ref.Object).to.equal(frame)

			Scene.Remove(frame)

			expect(frame).to.be.ok()
			expect(frame:GetFullName()).to.equal(path)
			expect(GetLenght(Scene.GetObjects())).to.equal(0)
		end)
	end)

	describe("Scene.Cleanup()", function()
		afterEach(function()
			-- for _, object in Scene.GetObjects() do
			-- 	Scene.Cleanup(object.Object)
			-- end

			Scene.Flush()
		end)

		it("should throw if wrong arguments are passed", function()
			expect(function()
				Scene.Cleanup(1)
			end).to.throw()
		end)

		it("should cleanup object", function()
			local scene = {
				Name = "CleanupObject",

				{ CleanupObject = {
					[Symbols.Tag] = "Tag",
				} },
			}

			Scene.Load(scene)

			local obj: Frame = Scene.GetFromTag("Tag")[1]
			local path = obj:GetFullName()

			expect(obj).to.be.ok()
			expect(GetLenght(Scene.GetObjects())).to.equal(1)

			Scene.Cleanup(obj)

			expect(obj).to.be.ok()
			expect(GetLenght(Scene.GetObjects())).to.equal(0)
			expect(function()
				Scene.GetObjectReference(obj)
			end).to.throw()
			expect(obj:GetFullName()).to.never.equal(path)
		end)
	end)
end
