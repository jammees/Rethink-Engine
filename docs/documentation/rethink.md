!!! danger

    Version below 0.6.1 automatically sets up everything once the module
    has been required and returns the modules!

    This change was introduced to have more control over initialization
    and to prepare for future support of Rethink's editor.

## Properties

<hr>

### Self

<span class=def>:material-tag-outline: Since:</span> 0.6.2

A reference to the instance itself.

<br>

### IsInitialized

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-book-cog-outline: Read-Only</span>

Tells whether Rethink was initialized or not.

<br>

### Version

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-book-cog-outline: Read-Only</span>

Tells the current version of Rethink.

## API

<hr>

### .Init()

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-keyboard-return: Returns:</span> Rethink `Module`

Initializes Rethink. This includes:

- Setting up the game UI elements
- Setting up the physics engine
- Setting up global variables that can be accessed with `Template`

After Rethink has initialized successfully it's header will get printed into the console.
This behaviour can be configured in the `Settings` file under `Settings.Console.LogHeader` (true by default)

<br>

### .GetModules()

<span class=def>:material-tag-outline: Since:</span> 0.6.2
<span class=def>:material-keyboard-return: Returns:</span> Modules `Dictionary`

Returns the modules. Does not check whether if Rethink is initialized or not!

!!! warning

    Modules located in the `Prototypes` table are unstable or unfinished!
    Using such modules are highly unrecommended due to stability issues!

??? info "What Rethink returns"

    - Collision `module`
    - Raycast `module`
    - Animator `module`
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