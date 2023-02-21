local Janitor = require(script.Parent.Parent.Parent.Parent.Components.Library.Janitor)
local Rigidbody = require(script.Parent.Parent.Parent.Environment.Physics.Physics.RigidBody)

export type Janitor = typeof(Janitor.new())

export type Rigidbody = typeof(Rigidbody.new())

export type Symbol = {
	Type: string,
	Name: string,
	SymbolData: {
		Symbol: any?,
		Attached: any,
	},

	__identifier: string,
}

export type SceneObject = {
	Object: Instance | Rigidbody,
	ObjectJanitor: Janitor,
	Index: number, -- TODO: Remove index
	ShouldFlush: boolean?, -- TODO: Add a flags table to contain properties such as this
}

export type Prototype_ChunkObject = {
	Properties: { [string]: any },
	Symbols: { [Symbol]: any },
	ObjectType: string,
	ObjectClass: string,
}

return true
