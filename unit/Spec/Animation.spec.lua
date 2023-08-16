---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Animator = Rethink.GetModules().Animator

local animationClass = Animator.new()

return function()
	describe("Tools.PopulateRow()", function()
		it("should return an array with the specified lenght", function()
			local array = Animator.Tools.PopulateRow(5)

			expect(#array).to.equal(5)
		end)
	end)

	describe("Tools.PopulateColumn()", function()
		it("should return a set of arrays specified by x, y", function()
			local setArrays = table.pack(Animator.Tools.PopulateColumn(5, 5))

			expect(setArrays.n - 1).to.equal(5)
			expect(#setArrays[1]).to.equal(5)
		end)

		it("should include the bonus", function()
			local setArrays = table.pack(Animator.Tools.PopulateColumn(0, 0, 5))

			expect(setArrays.n).to.equal(1)
			expect(#setArrays[1]).to.equal(5)
		end)
	end)

	describe("Animation.new()", function()
		it("should return a table", function()
			expect(animationClass).to.be.ok()
			expect(animationClass).to.be.a("table")
		end)

		it("should be a parent of the root module", function()
			expect(getmetatable(animationClass) == Animator).to.equal(true)
		end)

		it("should set Objects if argument is present", function()
			local frame = Instance.new("Frame")
			local tClass = Animator.new({ frame })

			expect(tClass.Objects).to.be.ok()
			expect(tClass.Objects[1]).to.equal(frame)
		end)
	end)

	describe("Animation:AddSpritesheet()", function()
		beforeEach(function()
			animationClass:ClearAnimationData()
		end)

		it("should correctly check imageId", function()
			expect(function()
				animationClass:AddSpritesheet(nil)
			end).to.throw()

			expect(function()
				animationClass:AddSpritesheet(1, Vector2.new(), {})
			end).to.never.throw()

			expect(function()
				animationClass:AddSpritesheet("1", Vector2.new(), {})
			end).to.never.throw()
		end)

		it("should correctly check size", function()
			expect(function()
				animationClass:AddSpritesheet(1, nil, {})
			end).to.throw()

			expect(function()
				animationClass:AddSpritesheet(1, Vector2.new(), {})
			end).to.never.throw()
		end)

		it("should correctly check animations", function()
			expect(function()
				animationClass:AddSpritesheet(1, Vector2.new(), nil)
			end).to.throw()

			expect(function()
				animationClass:AddSpritesheet(1, Vector2.new(), {})
			end).to.never.throw()
		end)

		it("should successfully process the animation data", function()
			animationClass:AddSpritesheet(10770144128, Vector2.new(73, 73), {
				["test"] = {
					Animator.Tools.PopulateColumn(13, 13, 6),
				},
			})

			local animationData = animationClass._AnimationData[1]

			-- Check if Animator successfully saved everything
			expect(animationClass._AnimationData[1]).to.be.ok()
			expect(animationClass._AnimationPointer["test"]).to.be.ok()
			expect(#animationClass._AnimationData).to.equal(1)

			-- Check if the animationData is currectly configured
			expect(animationData.ImageId).to.be.ok()
			expect(animationData.ImageId).to.be.a("number")
			expect(animationData.Size).to.be.ok()
			expect(type(animationData.Size) == "userdata").to.equal(true)

			-- Check that pointer points to the same data
			expect(animationClass._AnimationPointer["test"] == animationClass._AnimationData[1]).to.equal(true)
		end)
	end)
end
