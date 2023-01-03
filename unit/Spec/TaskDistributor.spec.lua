local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local TaskDistributor = require(Rethink.Components.Library.TaskDistributor)

local TaskDistributorClass = TaskDistributor.new()

return function()
    describe("TaskDistributor.new()", function()
        it("should return a table", function()
            expect(TaskDistributorClass).to.be.ok()
            expect(TaskDistributorClass).to.be.a("table")
        end)

        it("should be a parent of the root module", function()
            expect(getmetatable(TaskDistributorClass) == TaskDistributor).to.equal(true)
        end)
    end)

    describe("TaskDistributor:GenerateChunk()", function()
        it("should throw if `data` is not a table", function()
            expect(function()
                TaskDistributorClass:GenerateChunk(nil, 5)
            end).to.throw()
        end)

        it("should throw if `chunkSize` is not a number", function()
            expect(function()
                TaskDistributorClass:GenerateChunk({}, nil)
            end).to.throw()
        end)

        it("should return a table with `Chunk` and `DataSize`", function()
            local result = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)
            expect(result).to.be.ok()
            expect(result).to.be.a("table")
            expect(result.Chunk).to.be.ok()
            expect(result.DataSize).to.be.ok()
            expect(result.Chunk).to.be.a("table")
            expect(result.DataSize).to.be.a("number")
        end)

        it("should contain as many chunks as dividng the data by the `chunkSize`", function()
            local data = table.create(100, 1)
            local chunkSize = 5
            local result = TaskDistributorClass:GenerateChunk(data, chunkSize).Chunk
            expect(#result).to.equal(#data / chunkSize)
        end)
    end)

    describe("TaskDistributor:Distribute()", function()
        beforeEach(function()
            TaskDistributorClass:Cancel()
        end)
        
        it("should throw if `chunkData` is not a table", function()
            expect(function()
                TaskDistributorClass:Distribute(nil)
            end).to.throw()
        end)

        it("should throw if `processor` is not a function", function()
            expect(function()
                TaskDistributorClass:Distribute({}, nil)
            end).to.throw()
        end)

        it("should throw if `ProcessingChunks` is true", function()
            local accumulator = 0
            local chunk = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)
            
            TaskDistributorClass.ProcessingChunks = true
            TaskDistributorClass:Distribute(chunk, function()
                accumulator += 1
            end)

            expect(accumulator).to.equal(0)
        end)

        it("should call processor", function()
            local calledProcessor = false

            local chunk = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)

            TaskDistributorClass:Distribute(chunk, function()
                calledProcessor = true
            end):await()

            expect(calledProcessor).to.equal(true)
        end)

        it("should increment the .Processed counter", function()
            local accumulator = 0
            local chunk = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)

            TaskDistributorClass:Distribute(chunk, function()
                accumulator += 1
            end):await()

            expect(TaskDistributorClass.Processed).to.equal(accumulator)
        end)

        it("should increment the .ProcessedMax counter", function()
            local accumulator = 0
            local chunk = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)

            TaskDistributorClass:Distribute(chunk, function()
                accumulator += 1
            end):await()

            expect(TaskDistributorClass.ProcessedMax).to.equal(accumulator)
        end)

        it("should give a chunkObject in the processor function", function()
            local lastObject = false

            local chunk = TaskDistributorClass:GenerateChunk(table.create(100, 1), 5)

            TaskDistributorClass:Distribute(chunk, function(object)
                lastObject = object
            end):await()

            expect(lastObject).to.be.ok()
            expect(lastObject).to.never.equal(nil)
        end)
    end)
end
