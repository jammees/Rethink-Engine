return {
	["Looping trough a table looking for an object"] = {
		before = function(setContext)
			local myTable = {}
			local indexes = 1000

			local alreadyUsed = false
			local selectedInstance = Instance.new("Folder")

			for i = 1, indexes do
				if math.random(1, 25) == 21 and not alreadyUsed then
					alreadyUsed = true
					myTable[i] = selectedInstance
				else
					myTable[i] = true
				end
			end

			if not alreadyUsed then
				local randomIndex = math.random(1, indexes)
				myTable[randomIndex] = selectedInstance
			end

			setContext(myTable, selectedInstance)
		end,

		after = function(myTable, myInstance)
			myInstance:Destroy()
			table.clear(myTable)
		end,

		run = function(setContext, myTable, myInstance)
			for _, v in ipairs(myTable) do
				if v == myInstance then
					return
				end
			end

			setContext(myTable, myInstance)
		end,
	},
}
