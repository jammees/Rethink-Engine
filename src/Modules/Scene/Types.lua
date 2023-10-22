local Janitor = require(script.Parent.Parent.Parent.Vendors.Janitor)
local Rigidbody = require(script.Parent.Parent.Nature2D.Physics.RigidBody)
local Promise = require(script.Parent.Parent.Parent.Vendors.Promise)

export type UUID = string

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
	SymbolJanitor: Janitor,
	ID: string,
	Symbols: {
		IDs: { UUID }?,
		Permanent: boolean?,
		LinkIDs: { string }?,
	},
}

export type AvailableSymbols = {
	Property: any,
	Type: any,
	Tag: any,
	Rigidbody: any,
	Permanent: any,
	LinkTag: any,
	Event: any,
	LinkGet: any,
	Class: any,
	Children: any,
	OnReady: any,
	Value: any,
}

export type Prototype_ChunkObject = {
	Properties: { [string]: any },
	Symbols: { [Symbol]: any },
	ObjectType: string,
	ObjectClass: string,
}

return true
