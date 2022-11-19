-- InputLib
-- universal input library and manager

--local UserInputService = game:GetService("UserService")

local InputLib = {}
InputLib.__index = InputLib

function InputLib.new()
	return setmetatable({
		_Entries = {},
	}, InputLib)
end

function InputLib:AddExecutor(entryKey: EnumItem, executor: () -> (), mode: string)
	-- check if the entryKey does not already exist
	if not self._Entries[entryKey] and table.find(Enum.KeyCode:GetEnumItems(), entryKey) then
		self._Entries[entryKey] = {} --> this table will hold all the executors
	else
		warn("An error occured whilst trying to create an entry!")
	end

	-- add executor
	table.insert(self._Entries[entryKey], { mode, executor })
end

return InputLib
