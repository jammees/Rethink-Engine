TaskDistributor is a module created for handling tasks in a large scale. This module is mainly used in
Scene. For instance to handle the creation of thousans of objects or to flush them.

## API

<hr>

### TaskDistributor.new()

Constructs a new TaskDistributor class.

<br>

### TaskDistributor.GenerateChunk(`data`, `chunkSize`)

<span class=def>:material-cog-outline: Parameter:</span> data `{[Any]: Any}`
<span class=def>:material-cog-outline: Parameter:</span> chunkSize `Number`
<span class=def>:material-keyboard-return: Returns:</span> chunkData `CachedChunk`

Splits up the data table into smaller chunks based on the chunkSize argument and 
than returns it in the form of a CachedChunk object.

```lua
type CachedChunk = {
    Chunk: { [ number ]: { [ number ]: any } },
    DataSize: number,
}
```

??? example

    ```lua
    local TaskDistributor = require(PATH.TO.MODULE)

    -- This will split up a table that has 100 objects into tables of 10
    local chunk = TaskDistributor.GenerateChunk(table.create(100, Instance.new("Part", game.Lighting)), 10)

    print(chunk)
    ```

    The example above creates a table with an index of 100, which holds instances parented
    to Lighting and splits it up based on `CHUNK_SIZE`. Printing out the table results in having 10 tables,
    which hold 10 objects.

<br>

### TaskDistributor:Distribute(`chunkData`, `processor`): `Promise`

<span class=def>:material-cog-outline: Parameter:</span> chunkData `CachedChunk`
<span class=def>:material-cog-outline: Parameter:</span> processor `(Object) -> ()`
<span class=def>:material-keyboard-return: Returns:</span> Promise `Promise`

Distributes the chunkData among multiple promise instances and by each
iteration the object gets fed to the processor function.

!!! info "Processor"

    The processor function should always accept as the first argument the objects themselves.
    Check below for an example of an example of how the function should look like!

!!! warning

    It is generally a good practice to attach `:await` aftter the `:Distribute` function, because in default
    ROBLOX would not wait for the function to finish, because Promise by default makes the attached function asynchronous.

    If the asynchronous behaviour is desired to be kept, a recommended way to still know when it finished is by
    attaching `:andThen(function() end)` to your code!

    It is recommended to check out the [documentation of Promise](https://eryn.io/roblox-lua-promise/)!

??? example

    ```lua
    local TaskDistributor = require(PATH.TO.MODULE)

    local chunk = TaskDistributor.GenerateChunk(table.create(100, Instance.new("Part", game.Lighting)), 10)

    TaskDistributor:Distribute(chunk, function(object)
        -- In this function we can put any code that is related to the object
        -- For example renaming each part and moving them to workspace
        object.Name = "Hello TaskDistributor!"
        object.Parent = workspace
    end):await()

    print("Done processing!")
    ```

    The example above extends on the previous example, where the data was split up.
    This time however, the chunk is processed using [TaskDistributor:Distribute()](#taskdistributorgeneratechunkdata-chunksize).