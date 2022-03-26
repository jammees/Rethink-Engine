--[[

    Template

    Very simple utility tool, to prevent copy pasting ui code

    API:

    template.new(ui element) -> parent element to nil
    template:fetch() -> returns a clone of the ui
    template:update(ui element)
    template:destroy()
    
]]

local template = {}
template.__index = template

function template.New(element)
	element.Parent = nil
	return setmetatable({
		ui = element,
	}, template)
end

function template:Fetch()
	return self.ui:Clone()
end

function template:Update(element)
	if element:IsA("GuiBase2d") and self.ui ~= element then
		self.ui = element
	end
end

function template:Destroy()
	self.ui:Destroy()
end

return template
