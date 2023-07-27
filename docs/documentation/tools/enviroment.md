Here are all of the external libraries that Rethink uses:

<br>

### Physics `Nature2D`

[GitHub](https://github.com/jaipack17/Nature2D) | [Documentation](https://jaipack17.github.io/Nature2D/docs/api/Engine)

Made by: [@jaipack17](https://twitter.com/jaipack17)

<hr>

In Rethink Nature2D is a modified release of currently v0.7.1

These changes include some fixes, such fixing canvas not scaling dynamically when the viewport's size changes.
Or some compatibility such as not destroying the UI element.

### Raycast `RayCast2`

[GitHub](https://github.com/jaipack17/RayCast2) | [Documentation](https://jaipack17.gitbook.io/raycast2/)

Made by: [@jaipack17](https://twitter.com/jaipack17)

<hr>

Unmodified

### Collision `GuiCollisionService`

[GitHub](https://github.com/jaipack17/GuiCollisionService)

Made by: [@jaipack17](https://twitter.com/jaipack17)

<hr>

Fixed `.isInCore` not working as expected.
GuiCollisionService will be used to implement culling into Rethink, to hopefully slice down the amount of UI elements ROBLOX has to render.
As well as replacing deprecated variables.