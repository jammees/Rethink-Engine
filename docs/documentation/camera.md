!!! warning

    Camera is still in prototyping phase. Due to incompatibility with Nature2D. As of today
    the use of this tool is higly un-recommended!

    Thank you for your understanding!


Simple camera implementation that supports Nature2D.

## Properties

<hr>

### Handlers

Handlers are functions which determine the attached object's position.
Available handlers:

- NonBody
- AnchoredBody
- NonAnchoredBody

## API

<hr>

### .Render(`deltaTime`)

<span class=def>:material-cog-outline: Parameter:</span> deltaTime `Number?`

Updates every attached object's position by using handlers.
If deltaTime argument is present, it will use it in the calculations.

<br>

### .IsAttached(`object`)

<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`

Returns a boolean and tells whether that object is attached or not.

<br>

### .Attach(`object`)

<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`

Attaches the object to the camera and the next time [Camera.Render](#renderdeltatime) is called
it's position will get updated as well.

<br>

### .Detach(`object`)

<span class=def>:material-cog-outline: Parameter:</span> object `GuiObject | Rigidbody`

Removes the object from the camera if present.

<br>

### .SetPosition(`x`, `y`)

<span class=def>:material-cog-outline: Parameter:</span> x `Number`
<span class=def>:material-cog-outline: Parameter:</span> y `Number`

Sets the position of the projection to the specified x and y coordinates.
Takes into account the boundaries set by [Camera.SetBoundary](#setboundaryxbounds-ybounds).

<br>

### .Start()

Attaches the [Camera.Render](#renderdeltatime) method to Nature2D.Updated event.
Shorthand for doing:

```lua
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    Rethink.Prototypes.Camera.Render(deltaTime)
end)
```

<br>

### .Stop()

Disconnects the `.Render` connection.

<br>

### .SetBoundary(`XBounds`, `YBounds`)

<span class=def>:material-cog-outline: Parameter:</span> XBounds `NumberRange`
<span class=def>:material-cog-outline: Parameter:</span> YBounds `NumberRange`

Sets a minimum and a maximum boundary that the camera's position cannot surpass.