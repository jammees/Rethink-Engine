--[[

    Template

    Very simple utility tool, to prevent copy pasting and to save data!

    API:

    Template.new(object) -> any element
    Template:Fetch() -> returns the object, if possible clone it
    Template:Update(object)
    Template:Destroy()

	Template.NewGlobal()
	Template.FetchGlobal()
	Template.UpdateGlobal()
    
]]

local Log = require(script.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Vendors.t)

local globalTemplate = {}

local Template = {}
Template.__index = Template

--[=[
	Same as .New but it creates the target in a global table.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	Template.NewGlobal("PrintHello", function()
		print("Hello")
	end)
	```
]=]
function Template.NewGlobal(globalName: string, element: any, isLocked: boolean?)
	Log.TAssert(t.string(globalName))
	Log.TAssert(t.any(element))
	Log.TAssert(t.optional(t.boolean)(isLocked))

	globalTemplate[globalName] = { Locked = isLocked, Element = element }
end

--[=[
	Same as :Fetch() but it looks for the target in a global table.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local myPrintHello = Template.NewGlobal("PrintHello", function()
		print("Hello")
	end)

	local receivedPrintHello = Template.FetchGlobal("PrintHello")

	receivedPrintHello()
	```
]=]
function Template.FetchGlobal(target: string)
	Log.TAssert(t.string(target))

	local registry = globalTemplate[target]

	if registry ~= nil then
		return globalTemplate[target].Element
	end

	-- return warn("Failed to find " .. target)
	Log.Error(`Failed to find requested item {target}\nStracktrace:\n{debug.traceback()}`)
end

--[=[
	Same as :Update() but it updates the target in a global table.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local myPrintHello = Template.NewGlobal("PrintHello", function()
		print("Hello")
	end)

	local receivedPrintHello = Template.FetchGlobal("PrintHello")

	receivedPrintHello()

	Template.UpdateGlobal("PrintHello", function()
		warn("Hello")
	end)

	local newPrintHello = Template.FetchGlobal("PrintHello")

	newPrintHello()
	```
]=]
function Template.UpdateGlobal(target: string, element: any)
	Log.TAssert(t.string(target))
	Log.TAssert(t.any(element))

	local globalTarget = globalTemplate[target]

	if globalTarget.Locked == false or globalTarget.Locked == nil then
		globalTarget.Element = element
		return
	end

	return warn(("Global (%s) is locked!"):format(target))
end

--[=[
	Used for constructing a new template class.

	Anything can be saved, such as a required module, a table, an instance, etc..

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local mySavedFunction = Template.New(function()
		print("Hello world!")
	end)
	```
]=]
function Template.new(element: any, isLocked: boolean?)
	Log.TAssert(t.any(element))
	Log.TAssert(t.optional(t.boolean)(isLocked))

	if t.Instance(element) then
		element.Parent = nil
	end

	return setmetatable({
		instance = element,
		isLocked = isLocked,
	}, Template)
end

--[=[
	Used to get back the saved object.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local mySavedFunction = Template.New(function()
		print("Hello world!")
	end)

	mySavedFunction:Fetch()()
	```
]=]
function Template:Fetch(): Instance | any
	if t.Instance(self.instance) then
		return self.instance:Clone()
	else
		return self.instance
	end
end

--[=[
	Used for updating the saved object.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local mySavedFunction = Template.New(function()
		print("Hello world!")
	end)

	mySavedFunction:Update(function()
		warn("Hello world!")
	end)

	mySavedFuncion:Fetch()()
	```
]=]
function Template:Update(element: any)
	Log.TAssert(t.any(element))

	if t.boolean(self.isLocked) and self.isLocked then
		return
	end

	self.instance = element
end

--[=[
	Destroys the object if it's an instance, else it will set it to nil.

	```lua
	local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
	local Template = Rethink.Template

	local mySavedFunction = Template.New(function()
		print("Hello world!")
	end)

	mySavedFunction:Fetch()()

	mySavedFunction:Destroy()

	-- This wil now throw an error, since it got cleaned up by the garbage collector.
	mySavedFunction:Fetch()()
	```
]=]
function Template:Destroy()
	if t.Instance(self.instance) then
		self.instance:Destroy()
	end

	self.instance = nil
end

return Template
