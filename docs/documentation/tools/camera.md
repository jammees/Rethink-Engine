!!! warning

    Camera is still in prototyping phase. Due to incompatibility with Nature2D. As of today
    the use of this tool is higly un-recommended!

    Thank you for your understanding!


# Camera

Simple camera implementation that supports Nature2D.

## Properties

### Handlers

Handlers are functions which determine the attached object's position.

Available handlers:

- NonBody
- AnchoredBody
- NonAnchoredBody

## API

### .Render(`deltaTime`)

Updates every attached object's position by using handlers.

If `deltaTime` argument is present, it will use it in the calculations.

### .IsAttached(`object`)

Returns a boolean and tells whether that object is attached or not.

### .Attach(`object`)

Attaches the object to the camera and the next time `.Render` is called
it's position will get updated as well.

### .Detach(`object`)

Removes the object from the camera if present.

### .SetPosition(`x`, `y`)

Sets the position of the projection to the specified x and y coordinates.
Takes into account the boundaries set by `.SetBoundary`

### .Start()

Attaches the `.Render` method to Nature2D's `Updated` event.

Shorthand for doing:

```lua
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    Rethink.Prototypes.Camera.Render(deltaTime)
end)
```

### .Stop()

Disconnects the `.Render` connection.

### .SetBoundary(`XBounds`, `YBounds`)

Sets a minimum and a maximum boundary that the camera's position cannot surpass.