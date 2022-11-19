export type Tween = {
	Duration: number,
	Style: Enum.EasingStyle,
	Direction: Enum.EasingDirection,
}

export type SceneConfig = {
	Name: string?,
	CompileMode: string?,
}

export type Symbol = {
	Type: string,
	Name: string,
}

export type SymbolCompiler = {
	[string]: {
		Type: string,
		Name: string,
	},
}

export type Table = {
	[string]: any,
}

export type RequiredData = {
	Physics: ModuleScript,
	Ui: {
		[string]: Frame,
	},
}

type Wrapper = {
	Physics: ModuleScript?,
	Environment: Folder?,
	Components: Folder?,
	Utility: Folder?,
	Core: Folder?,
	Ui: {
		RenderFrame: Frame,
		CameraCont: Frame,
		GameFrame: Frame,
		ViewScale: frame,
		Canvas: frame,
		Layer: frame,
		Ui: frame,
	}?
}

return nil
