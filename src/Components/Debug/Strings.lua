return {
	ConsoleHero = [[
		
     ____      _   _     _       _       _____             _            
    |  _ \ ___| |_| |__ (_)_ __ | | __  | ____|_ __   __ _(_)_ __   ___ 
    | |_) / _ \ __| '_ \| | '_ \| |/ /  |  _| | '_ \ / _` | | '_ \ / _ \
    |  _ <  __/ |_| | | | | | | |   <   | |___| | | | (_| | | | | |  __/
    |_| \_\___|\__|_| |_|_|_| |_|_|\_\  |_____|_| |_|\__, |_|_| |_|\___|
                                                     |___/              
    Versatile, easy-to-use 2D game engine.
    Version: 1.0.0-alpha
    ]],

	Expected = "Expected to get %q; got %q (arg num %d)!",
	ExpectedNoArg = "Expected to get %q; got %q!",
	ExpectedVariable = "Expected %s to be a %s; got %q!",

	ObjectAlreadyAttached = "%s (%s) is already attached to %s!",
	ObjectIsNotAttached = "%s (%s) is not attached to %s!",
	RemoveErrorNoObject = "%s (%s) doesn't exist in scene!",
	EmptySceneTable = "Received an invalid SceneTable; has no items!",
	SignalNotFound = "%s is not valid signal!",
	MethodFailNoScene = "Attempted to %s the scene, but failed due to it being empty!",
	IsWrongType = "Error whilst trying to call %q, expected to get %q; got %q!",

	-- Pretty sure there was a much better way of doing this, but since
	-- I already took my time writing these down, I decided not to worry
	Animator = {
		NoAnimation = "Error whilst trying to call :Play(), no animation was specified!",
		NoObjectsAttached = "Error whilst trying to call :Play(), no objects were attached!",
		NotValidObject = "Error whilst trying to call :AttachObject(), expected an ImageLabel or ImageButton got; %q!",
		AnimationRunning = "Error whilst trying to call %s, Animator is running! Please use :Stop() before this method!",
		ObjectAlreadyAttached = "Error whilst trying to call :AttachObject(), object already attached!",
	},

	TaskDistributor = {
		AlreadyProcessing = "Error whilst trying to call :Distribute(), already processing a chunk!"
	}
}
