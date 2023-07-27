local Janitor = require(script.Parent.Parent.Parent.Library.Janitor)
local Rigidbody = require(script.Parent.Parent.Physics.Physics.RigidBody)
local Promise = require(script.Parent.Parent.Parent.Library.Promise)

type UUID = string

export type Janitor = Janitor.Janitor

export type Rigidbody = typeof(Rigidbody.new())

export type Promise = typeof(Promise.new())

export type Symbol = {
	Type: string,
	Name: string,
	SymbolData: {
		Symbol: any?,
		Attached: any,
	},

	__identifier: string,
}

export type ObjectReference = {
	Object: GuiObject | Rigidbody,
	Janitor: Janitor,
	SymbolJanitor: Janitor?,
	ID: string,
	Symbols: {
		IDs: { UUID },
		ShouldFlush: boolean?,
	}?,
}

export type Prototype_ChunkObject = {
	Properties: { [string]: any },
	Symbols: { [Symbol]: any },
	ObjectType: string,
	ObjectClass: string,
}

return true
