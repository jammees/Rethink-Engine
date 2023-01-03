type DatGuiType = {
	addFolder: ( string ) -> ( any )?
}

type DatGuiClass = {
	add: ( () -> (), string, any ) -> ()
}

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local PhysicsController = {}

function PhysicsController.Init(DatGui: DatGuiType)
    local datGui: DatGuiClass = DatGui.addFolder("Physics")

    datGui.add(Rethink.Physics, "Start")
    datGui.add(Rethink.Physics, "Stop")
end

return PhysicsController