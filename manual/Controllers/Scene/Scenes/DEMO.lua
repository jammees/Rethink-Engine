return {
    SceneSettings = {
        _Config = { Type = "SceneConfig" },
        Name = "DEMO",
    },

    Structure = {
        Background = {
            _Config = { Type = "Layer" },

            ["Props: -1"] = {
                Box = {
                    Class = "ImageLabel",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(100, 100),
                    Image = "rbxassetid://30115084",

                    Tag = "Box",
                },
                Cone = {
                    Class = "ImageLabel",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.35, 0.5),
                    Size = UDim2.fromOffset(100, 100),
                    Index = 2,
                    Image = "rbxassetid://6761652003",

                    Tag = "Cone",
                }
            },
        },
    }
}