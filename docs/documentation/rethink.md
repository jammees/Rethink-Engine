## API:

!!! danger

    Version below 0.6.1 automatically sets up everything once the module
    has been required and returns the modules!

    This change was introduced to have more control over initialization
    and to prepare for future support of Rethink's editor.

<hr>

### .Init()

<span class=def>:material-tag-outline: Since:</span> 0.6.2

Initializes Rethink. This includes:

- Setting up the game UI elements
- Setting up the physics engine
- Setting up global variables that can be accessed with `Template`

After Rethink has initialized successfully it's header will get printed into the console.
This behaviour can be configured in the `Settings` file under `Settings.Console.LogHeader` (true by default)

<br>

### .GetModules()

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-keyboard-return: Returns:</span> modules `Dictionary`

Returns the modules. Does not check whether if Rethink is initialized or not!

!!! warning

    Tools located in the `Prototypes` table are unstable or unfinished!
    Using such tools are highly unrecommended due to stability issues!

??? info "What Rethink returns"

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