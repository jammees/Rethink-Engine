Outline is a simple utility module that was made to create fake outlines for images/UI elements.
Devforum post: [Give images strokes, with Outline!](https://devforum.roblox.com/t/give-images-strokes-with-outline/1596996)

!!! warning

    Outline does not work with transparent UI elements! All UI elements must have a transparency of 0!

<br>

## API

<hr>

### .New(`config`)

<span class=def>:material-cog-outline: Parameter:</span> config `Config`



| Name      | Required  | Default value     | Description                                           |
| --------- | --------- | ----------------- | ----------------------------------------------------- |  
| Object    | yes       | -                 | Module will use as the clone template                 |
| Size      | no        | 3                 | How thicc the outline will be                         |
| Parent    | no        | Object            | Where to parent it                                    |
| Data      | no        | DEFAULT_DATA		| Positional data                                       |
| Sides     | no        | 8                 | For the loop and for the positional data              |
| Rotation  | no        | 0                 | How much the module should rotate the outlines        |
| Customize | no        | -                 | `Color` and `Gradient(boolean)` can be specified      |

??? tip "DEFAULT_DATA"

	```lua
	{
		[1] = { "-%s", "0" },
		[2] = { "-%s", "-%s" },
		[3] = { "0", "-%s" },
		[4] = { "%s", "-%s" },
		[5] = { "0", "%s" },
		[6] = { "%s", "%s" },
		[7] = { "-%s", "%s" },
		[8] = { "%s", "0" },
	}
	```

<br>

### :Rebake()

Re-renders the outlines again.

<br>

### :Destroy()

Destroys the outline class.