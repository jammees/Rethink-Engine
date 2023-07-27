On the first require of the module, Rethink will initialize itself.

This includes things such as:

- Setting up the game UI elements
- Setting up the physics engine
- Setting up global variables that can be accessed with `Template`

After Rethink has initialized successfully it's header will get printed into the console.
This behaviour can be configured in the `Settings` file under `Settings.Console.LogHeader` (true by default)

After the initialization phase Rethink will return you a table full of tools, used in developing 2D games.

!!! warning

    Tools located in the `Prototypes` table are unstable or unfinished!
    Using such tools are highly unrecommended due to stability issues!

??? info "What Rethink returns (0.6.0)"

    - Collision `module`
    - Raycast `module`
    - Animation `module`
    - Outline `module`
    - Scene `module`
    - Template `module`
    - Physics `module`
    - Components `folder`
    - Tools `folder`

    - Ui `table`
        - GameFrame `frame`
        - RenderFrame `frame`
        - Viewport `frame`
        - Ui `frame`
    - Prototypes `table`
        - Camera `module`