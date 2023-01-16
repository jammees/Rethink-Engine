local ObjectPool = require(game:GetService("ReplicatedStorage").Benchmarks.Bench.ObjectPool)

local objectClass = ObjectPool.new({
	Frame = 100,
})

return function()
	describe("ObjectPool.new()", function()
		it("should return a table", function()
			expect(objectClass).to.be.ok()
			expect(objectClass).to.be.a("table")
		end)

		it("should be a parent of the root module", function()
			expect(getmetatable(objectClass) == ObjectPool).to.equal(true)
		end)

		it("should process pool data correctly", function()
			-- Check if data has been processed successfully
			expect(#objectClass.AvailableObjects["Frame"]).to.equal(100)
			expect(objectClass.AvailableObjects["Frame"][1].Object).to.be.a("Frame")
			expect(#objectClass.ObjectLookup).to.equal(100)
		end)
	end)

	describe("ObjectPool:Get()", function()
		it("should return an object specified by type", function()
			local obj = objectClass:Get("Frame")

			expect(obj).to.be.ok()
			expect(obj.ClassName == "Frame").to.equal(true)

			objectClass:Return(obj)
		end)

		it("should correctly track state of the objects", function()
			local obj = objectClass:Get("Frame")

			expect(objectClass.ObjectLookup[obj].BusyRegistry).to.never.equal(0)
			expect(objectClass.BusyObjects[1] == obj).to.equal(true)

			objectClass:Return(obj)
		end)
	end)
end
