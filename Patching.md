##### `(unit-builder opts?)`

Creates an instance of a Unit. [See full list of Units available](Units)

##### `(unit-unmount unit)`

Unmounts `unit` from the audio graph.

##### `(unit-remove unit-symbol)`

Unmounts `unit` from the audio graph and undefines the symbol binding.

##### `(-> unit inputs)`

Patch values to the inputs of `unit`. This is a variant of `->` that resets any inputs belonging to `unit`, that aren't referenced, to their default values.

**Example:**

    (-> oscillator 
        (table :freq (hz 100)
               :freq-mod (<- mod :sine)))

##### `(=> unit inputs)`

Sparse version of `->`. It only affects inputs specified and does not reset unspecified inputs.

##### `(<- unit output?)`

Returns a reference to a Unit output. If no `output` is specified the default name `out` will be used.

## Audio Engine

##### `(clear)`

Clears the audio graph and Lisp environment.

##### `(emit l r)`

Sinks audio from two output sources. One going to left channel and the other to the right channel.

