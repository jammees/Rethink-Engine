Template is an utility module, which can save any kind of value to be retrieved later. In Rethink this tool is mainly used to pass on classes to avoid any infinite recursion errors.

<br>

## API

### .NewGlobal(`globalName`, `element`, `isLocked`)

<span class=def>:material-cog-outline: Parameter:</span> globalName `String`
<span class=def>:material-cog-outline: Parameter:</span> element `Any`
<span class=def>:material-cog-outline: Parameter:</span> isLocked `Boolean`

Saves the element in a table with a key of globalName. isLocked argument prevents it from being overwritten.

<br>

### .FetchGlobal(`target`)

<span class=def>:material-cog-outline: Parameter:</span> target `String`
<span class=def>:material-keyboard-return: Returns:</span> Element `Any`

Returns the global with the key of target.

<br>

### .UpdateGlobal(`target`, `element`)

<span class=def>:material-cog-outline: Parameter:</span> target `String`
<span class=def>:material-cog-outline: Parameter:</span> element `Any`

Updates the global value with the key of target to element.

<br>

### .new(`element`, `isLocked`)

<span class=def>:material-cog-outline: Parameter:</span> element `Any`
<span class=def>:material-cog-outline: Parameter:</span> isLocked `Boolean`

Constructs a new class with element. If isLocked is set to true [Template:Update()](#updateelement) calls will be ignored.

<br>

### :Fetch()

<span class=def>:material-keyboard-return: Returns:</span> Element `Any`

Returns the class' element. If the saved element is an instance, the duplicated version will be fetched.

<br>

### :Update(`element`)

<span class=def>:material-cog-outline: Parameter:</span> element `Any`

Updates the class' element to element. If isLocked is set to true the request will get ignored.

<br>

### :Destroy()

Destructs the class.