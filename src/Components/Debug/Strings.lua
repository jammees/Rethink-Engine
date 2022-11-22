return {
	ConsoleHero = [[
		
     ____      _   _     _       _       _____             _            
    |  _ \ ___| |_| |__ (_)_ __ | | __  | ____|_ __   __ _(_)_ __   ___ 
    | |_) / _ \ __| '_ \| | '_ \| |/ /  |  _| | '_ \ / _` | | '_ \ / _ \
    |  _ <  __/ |_| | | | | | | |   <   | |___| | | | (_| | | | | |  __/
    |_| \_\___|\__|_| |_|_|_| |_|_|\_\  |_____|_| |_|\__, |_|_| |_|\___|
                                                     |___/              
    Versatile, easy-to-use 2D game engine.
    Version: 0.6.0 - DEV

    ]],

	-- Console templates
	Expected = "Expected to get %q; got %q (arg num %d)!",
	ExpectedNoArg = "Expected to get %q; got %q!",
	ObjectAlreadyAttached = "Object (%s) is already attached to camera!",
	ObjectIsNotAttached = "Object (%s) is not attached to camera!",
	RemoveErrorNoObject = "%s (%s) doesn't exist in scene!",
	EmptySceneTable = "Received an invalid SceneTable; has no items!",
	SignalNotFound = "%s is not valid signal!",
	MethodFailNoScene = "Attempted to %s the scene, but failed due to it being empty!",
}
