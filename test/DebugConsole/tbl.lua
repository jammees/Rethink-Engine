-- tbl
-- Some utility functions that I found useful while developing
-- RDC(Rethink Debug Console)

local tbl = {}

function tbl.GetLenght<T>(tblElement: { T })
	local lenght = 0

	for _ in tblElement do
		lenght += 1
	end

	return lenght
end

function tbl.Concat<T>(tblElement: { T }, template: string, separator: string?)
	local ivPairs = {}

	for i, v in tblElement do
		table.insert(ivPairs, template:format(tostring(i), tostring(v)))
	end

	return table.concat(ivPairs, separator)
end

return tbl
