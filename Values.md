The data that flows between the [various Units](Units) in Shaden can be grouped into three categories: 

1. **Floating-Point**: These represent audio signals and control signals. These values are usually constrained to be in
   the range [-1,1], but can sometimes be higher.
1. **Integer**: Used to represent various modes in Unit inputs or scalar values.
1. **Binary**: High or low signals which are represented by the bi-polar range [-1,1]  

## Units

These functions help by taking a human-readable value and converting it to the appropriate real (float64) value that the
engine can use.

### `(hz x)`

Returns a frequency. `x` can be one of the following:
- Numeric frequency: `(hz 100)`
- Scientific pitch notation string: `(hz "A4")`
- Pitch using [music theory](#music-theory) transpositions: 
    ```
    (define C3 (theory/pitch "C3"))

    (hz C3)
    ; 130.81  

    (hz (theory/transpose C3 (theory/interval :minor 2)))
    ; 138.59Hz
    ```

### `(ms x)`

Returns a duration in milliseconds.

### `(bpm x)`

Returns a frequency for beats-per-minute.

### `(db x)`

Returns a level represented in dB.

**Example:**

    (db -6)
    ; 0.5011872336272722

## Music Theory

### `(theory/pitch pitch-notation)`

Returns a pitch using scientific notation. This is different from `hz` in that its used for transposition.

**Example:**

    (theory/pitch "C#4")
    (theory/pitch "Eb2")

### `(theory/interval interval step)`

Returns an interval at a specific integer step. `interval` can be a string or keyword.

**Example:**

    (theory/interval :perfect 5)
    (theory/interval :minor 7)

### `(theory/transpose pitch interval)`

Return a new pitch that's transposed by a specific interval.

**Example:**

    (theory/transpose (theory/pitch "C3") 
                      (theory/interval :minor 2))
    ; C#3

## Constants

### General Modes

|Symbol|Value|
|-|-|
|`mode/on`|1|
|`mode/off`|0|
|`mode/high`|1|
|`mode/low`|-1|

### Note Qualities

|Symbol|Value|
|-|-|
|`quality/perfect`|0|
|`quality/minor`|1|
|`quality/major`|2|
|`quality/diminished`|3|
|`quality/augmented`|4|
    
### [Stages Sequencer](Units#unitstages-options) Modes

#### Movement

|Symbol|Value|
|-|-|
|`mode/forward`|0|
|`mode/reverse`|1|
|`mode/pingpong`|2|
|`mode/random`|3|

#### Gate

|Symbol|Value|
|-|-|
|`mode/rest`|0|
|`mode/first`|1|
|`mode/all`|2|
|`mode/last`|3|
|`mode/hold`|4|

### [Gate](Units#unitgate) Modes

|Symbol|Value|
|-|-|
|`mode/lp`|0|
|`mode/both`|1|
|`mode/amp`|2|
