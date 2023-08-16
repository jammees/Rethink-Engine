local symbolHandlers = {}

for _, module in script.Parent.Handlers:GetChildren() do
	if not (module:IsA("ModuleScript") or module.Name:match("Symbol$")) then
		continue
	end

	symbolHandlers[module.Name:gsub("Symbol", "")] = require(module)
end

return {
	-- 0 : default
	-- 1 : function
	TypeLookup = {
		Permanent = 0,
		Rigidbody = 0,
		Property = 0,
		Type = 0,
		Tag = 0,
		LinkTag = 0,
		Class = 0,

		Event = 1,
		LinkGet = 1,
	},

	SymbolHandlers = symbolHandlers,
}
