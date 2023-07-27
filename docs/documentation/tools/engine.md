# Rethink

## API:

<hr>

### .Init()

Initializes Rethink. This includes:

- Setting up the game UI elements
- Setting up the physics engine
- Setting up global variables that can be accessed with `Template`

After Rethink has initialized successfully it's header will get printed into the console.
This behaviour can be configured in the `Settings` file under `Settings.Console.LogHeader` (true by default)

<br>

### .GetModules()

<span style="color:rgba(197, 148, 197, 1);">@returns {dictionary} modules</span>

Returns the modules. Does not check whether if Rethink is initializes or not!

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
    - Pool `module`

    - Ui `table`
        - GameFrame `frame`
        - RenderFrame `frame`
        - Viewport `frame`
        - Ui `frame`
    - Prototypes `table`
        - Camera `module`