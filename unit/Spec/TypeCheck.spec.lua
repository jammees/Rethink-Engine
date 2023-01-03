local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local TypeCheck = require(Rethink.Components.Debug.TypeCheck)

return function()
    describe("TypeCheck.Is()", function()
        it("should pass if the argument is correct", function()
            expect(function()
                TypeCheck.Is("", 1, "number")
            end).to.never.throw()
        end)

        it("should throw if the arguments are not correct", function()
            expect(function()
                TypeCheck.Is("", true, "number")
            end).to.throw()
        end)
    end)
end