## Elements

### Strings

Strings are represented as a series of characters between double quotes: `"Hello, World"`

### Keywords

Keywords are identifiers that lead with a colon (`:`). The `:` character is not part of the name. Keywords are typically
used as keys in `table` data structures.

Keywords implement the underlying Go interface `lisp.Function` and therefore can be used as a function. The function is
to be used with a `table` as an argument to fetch an associated value. Here's an example:

    (define t (table :key "value"))
    (:key t)
    ; "value"

### Numbers

Both floats (represented as Go `float64`) and integers (represented as Go `int`) are supported.


## Builtin

#### `(load filepath)`

**Function**

Read and Eval the contents of a file.

#### `load-path`

**List**

Path to search for files. Controlled by the `LUMEN_LISP_PATH` environment variable.

#### `eval`

#### `read`
