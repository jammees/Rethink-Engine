export type Symbol = {
	Type: string,
	Name: string,
	SymbolData: {
		Symbol: any,
		Attached: any,
	},

	__identifier: string,
}

export type SceneObject = {
	Object: Instance | { any },
	ShouldFlush: boolean,
	ObjectJanitor: any,
	Index: number,
}

return true
