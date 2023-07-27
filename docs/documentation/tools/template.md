# Template

Template is an utility module, which can save any kind of value to be retrieved later. In Rethink this tool is mainly used to pass on classes to avoid any infinite recursion errors.

<br>

## API

### .NewGlobal(`globalName`, `element`, `isLocked`)

<span style="color:rgba(197, 148, 197, 1);">@param {string} globalName</span>

<span style="color:rgba(197, 148, 197, 1);">@param {any} element</span>

<span style="color:rgba(197, 148, 197, 1);">@param {boolean} isLocked</span>

Saves the `element` in a table with a key of `globalName`. `isLocked` prevents it from being overwritten.

<br>

### .FetchGlobal(`target`)

<span style="color:rgba(197, 148, 197, 1);">@param {string} target</span>

Returns the global with the key of `target`.

<br>

### .UpdateGlobal(`target`, `element`)

<span style="color:rgba(197, 148, 197, 1);">@param {string} target</span>

<span style="color:rgba(197, 148, 197, 1);">@param {any} element</span>

Updates the global value with the key of `target` to `element`.

<br>

### .new(`element`, `isLocked`)

<span style="color:rgba(197, 148, 197, 1);">@param {any} element</span>

<span style="color:rgba(197, 148, 197, 1);">@param {boolean} isLocked</span>

<span style="color:rgba(197, 148, 197, 1);">@class</span>

Constructs a new class with `element`. If `isLocked` is set to true `:Update` calls will be ignored.

<br>

### :Fetch()

<span style="color:rgba(197, 148, 197, 1);">@return {any}</span>

Returns the class' element. If the saved element is an instance, the duplicated version will be fetched.

<br>

### :Update(`element`)

Updates the class' element to `element`. If `isLocked` is set to true the request will get ignored.

<br>

### :Destroy()

<span style="color:rgba(197, 148, 197, 1);">@destructor</span>

Destructs the class.