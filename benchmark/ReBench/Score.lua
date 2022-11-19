type localIndex = {
	Name: string,
	IsTimedOut: boolean,
	TimeOutLimit: number,
}
type CycleAmount = {
	[string]: {
		Current: number,
		Max: number,
	},
}
type results = { [localIndex]: { [string]: number } }

local REPORT_START = "\nBenchmark results:\n"
local REPORT_TREE = "\t%s (%d/%d cycles // %s %%):\n"
local REPORT_TREE_TIMEOUT = "\t[Timed out(%d s)] %s (%d/%d cycles // %s %%):\n"
local REPORT_RESULT = "\t\t%s: %f μs\n"

local DATA_ORDER = {
	"Avarage",
	"Maximum",
	"Minimum",
	"Elapsed",
}

local DEFAULT_DECIMAL_AMOUNT = 6

local archivedBenchmarkData = {}

local function SimplifyFloat(number: number, decimals: number)
	return ("%" .. ("0.%sf"):format(tostring(decimals or DEFAULT_DECIMAL_AMOUNT))):format(number)
end

local Score = {}
Score.Group = {}

function Score.CalculateScore(functionScores: { [number | string]: number }, calls: number): { [string]: number }
	local scores = functionScores

	-- sort table from highest to lowest
	table.sort(scores, function(a, b)
		return a > b
	end)

	return {
		Avarage = scores.All / calls,
		Maximum = scores[1],
		Minimum = scores[#scores],
		Elapsed = scores.All,
	}
end

function Score.Report(method: (string) -> nil, benchmarkData: results, cyclesData: CycleAmount)
	local report = REPORT_START

	for label: localIndex, data in pairs(benchmarkData) do
		if label.IsTimedOut then
			report = report
				.. string.format(
					REPORT_TREE_TIMEOUT,
					label.TimeOutLimit,
					label.Name,
					cyclesData[label].Current,
					cyclesData[label].Max,
					("%0.1f"):format(tostring(cyclesData[label].Current / cyclesData[label].Max * 100))
				)
		else
			report = report
				.. string.format(
					REPORT_TREE,
					label.Name,
					cyclesData[label].Current,
					cyclesData[label].Max,
					("%0.1f"):format(tostring(cyclesData[label].Current / cyclesData[label].Max * 100))
				)
		end

		for i = 1, #DATA_ORDER do
			local index = DATA_ORDER[i]

			pcall(function()
				report = report .. string.format(REPORT_RESULT, index, SimplifyFloat(data[index]))
			end)
		end
	end

	method(report)
end

function Score.Group.SaveData(index: localIndex, data: { [string]: number }, cycles: number)
	archivedBenchmarkData[index] = { Data = data, Cycle = cycles }
end

function Score.Group.GetData(): { any }
	local results = {}
	local cycles = {}

	-- unpack the archived benchmarking datas, and sort them into 2 tables
	for i: localIndex, v in pairs(archivedBenchmarkData) do
		results[i] = v.Data
		cycles[i] = v.Cycle
	end

	return results, cycles
end

function Score.Group.ResetData()
	archivedBenchmarkData = {}
end

return Score
