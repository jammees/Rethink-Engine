--[[
	Edited version of the original for ReBenchmark.

	------------
	TIMER MODULE
	------------
	
	====METHODS====
	
	Timer.new(duration,count)
		Returns a new Timer with the specified duration.
		'Completed' event will fire when the Timer finishes.
		'Count' event will fire every 'count' seconds, until the Timer finishes.
	
	Timer:Start()
		Starts a Timer, or unpauses a paused Timer.
		
	Timer:Destroy()
		Cancels a Timer early, destroying it.
		
	Timer:Reset()
		Resets a Timer, starting it counting from 0.
		The timer will still be running! It does not get paused.
		Recommended to pause first before using :Reset() if you intend
		to keep it paused, otherwise it will start running immediately and could
		bleed over.
		
	Timer:Pause()
		Pauses a Timer, allowing it to be continued later using :Start()
	
	
	====EVENTS====
	
	Timer.Completed(TimeElapsed)
		An event fired when the specified Timer ends.
	
	Timer.Tick(TimeElapsed)
		An event fired when the specified count ticks (default 1).
		This means every x seconds, the event will be fired.
	
	
	====PROPERTIES====
	
	Timer.StartTime
		When the timer was started.
		(or an equivalent time based on when it was unpaused)
		
	Timer.Duration
		How long the timer lasts.
		If Timer.Duration is 0 or less, the timer will be infinite.
	
	Timer.CountStep
		The time between each Count (defined in the constructor)
		
	Timer.TimeElapsed
		The current time elapsed since starting the Timer.
		Paused time is not taken into account.
	
	Timer.Counts
		The amount of Counts the Timer has taken.
		
	Timer.Paused
		Whether or not the Timer is currently paused.
	
	--------------
	EXAMPLE OF USE
	--------------
	
	local Timer = require(game.ReplicatedStorage.Timer)
	
	local tenSeconds = Timer.new(10)
	
	tenSeconds.Completed:Connect(function()
		print("10 second timer completed.")
	end)
	
	tenSeconds.Tick:Connect(function()
		print("Tick")
	end)
	
	tenSeconds:Start()
	
	-------
	UPDATES
	-------
	
	19-May-2022
	- Switched from using bindable events to signal
	- Code cleanup
	- Timer to longer gets destroyed after it finishes counting
	- Added :Stop() for pausing and resetting Timer

	22-May-2021:
	-Uses os.clock() instead of tick() now. My bad!
	
	19-May-2021:
	-Added infinite duration condition (Duration can be 0 or less to be infinite)
	-Added pause function with :Pause(), which can be unpaused using :Start()
	-Added Timer.TimeElapsed (shows how long it has been since the timer started. Paused timespan not taken into account)
	-Further polishing, should function cleanly and as expected now
	-Changed some variables.
	-Changed :Stop() method to :Destroy() (more consistent with Roblox instances)
	
	29-Mar-2021:
	-It was very bad. Made it less buggy so it behaves as expected.
	-Added Reset() method (timer continues from 0 once reset)
	
	02-Jan-2020:
	-Added Count event
	
	-----
	NOTES
	-----
	
	The main issue with any timer or wait module - framerate WILL affect it.
	Anyway, I think I've made it a whole lot less scuffed, and I'd actually be
	happy to see people using this now (since it 
	
	Report any bugs or ask any questions at:
	Lightlim#8531
	
--]]
local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)

local Timer = {}
Timer.__index = Timer

function Timer.new(duration, count) -- Creates a new timer
	local newTimer = {}

	newTimer.Paused = true
	newTimer.Duration = duration
	newTimer.StartTime = os.clock()
	newTimer.TimeElapsed = 0

	newTimer.Completed = Signal.new()
	newTimer.Tick = Signal.new()

	newTimer.CountStep = count or 1 -- defaults to 1
	newTimer.Counts = 0

	return setmetatable(newTimer, Timer)
end

function Timer:Start() -- Begins, or unpauses a timer
	if not self.Paused then
		warn("Timer is already running")
		return
	end

	self.Paused = false
	self.StartTime = os.clock() - self.TimeElapsed

	self.Counter = RunService.Heartbeat:Connect(function()
		self.TimeElapsed = os.clock() - self.StartTime

		if os.clock() > (self.StartTime + (self.Counts + 1 * self.CountStep)) then
			self.Tick:Fire(self.TimeElapsed) -- return accurate time
			self.Counts = self.Counts + 1
		end

		if self.TimeElapsed >= self.Duration then
			self.Completed:Fire(self.TimeElapsed) -- return accurate time
		end
	end)
end

function Timer:Reset()
	self.StartTime = os.clock()
	self.Counts = 0
end

function Timer:Pause()
	if self.Counter then
		self.Counter:Disconnect()
		self.Paused = true
		self.TimeElapsed = os.clock() - self.StartTime
	end
end

function Timer:Stop()
	self:Pause()
	self:Reset()
end

function Timer:Destroy()
	self.Counter:Disconnect()
	self.Completed:Destroy()
	self.Tick:Destroy()
end

return Timer
