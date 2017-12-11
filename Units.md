Units are what perform work inside Shaden. Each Unit has been designed to fulfill a specialized purpose. By connecting multiple Units together, using their inputs and outputs, you can create more complex behavior. This document details all Units available in the Shaden runtime. Each Unit builder symbol takes the form `unit/<type>` and is a function that will yield a new Unit of that type. Some Units accept an optional table that contains any initialization-time parameters.

Here are a few examples of unit creation:

    (define oscillator (unit/gen))
    (define mix (unit/mix (table :size 3)))

    (-> oscillator (table :tempo (hz "C3")))
    (-> mix
        (list (table :in (<- oscillator :sine)
              (table :in (<- oscillator :sub-pulse) :level 0.3)
              (table :in (<- oscillator :saw) :level 0.5))))

Once a Unit has been created there are three types of controls at your disposal. Those types are:

1. **Inputs**: Accept signal into a Unit.
2. **Outputs**: Emit signal from a Unit.
3. **Properties**: Configuration that can change post-creation. These do not act as part of the audio graph and cannot be connected to either **Inputs** or **Outputs**.

Depending on the purpose of the Unit, it may not provide controls of all three types.

## Signal Sources

### `(unit/gen)`

Oscillator and noise source. Uses PolyBLEP for waveform generation and is best for audio-range frequencies.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|freq|In|440Hz|-|Frequency|
|freq-mod|In|0Hz|-|Frequency modulation (added to Frequency)|
|amp|In|1|-|Amplitude|
|pulse-width|In|1|-|Pulse-width of pulse waves|
|phase-mod|In|0|-|Phase modulation|
|offset|In|0|-|Offset of waveform from 0|
|sync|In|-1|[-1,1]|Trigger to reset the phase of the oscillator.|
|sine|Out|-|-|Sine|
|sub-sine|Out|-|-|Sine (-1 octave)|
|saw|Out|-|-|Saw|
|sub-saw|Out|-|-|Saw (-1 octave)|
|pulse|Out|-|-|Pulse|
|sub-pulse|Out|-|-|Pulse (-1 octave)|
|triangle|Out|-|-|Triangle|
|noise|Out|-|-|White noise|
|cluster|Out|-|-|Sparse "clicky" noise|



### `(unit/low-gen)`

Low-frequency oscillator. Uses naive waveforms for crisp edges.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|freq|In|440Hz|-|Frequency|
|amp|In|1|-|Amplitude|
|offset|In|0|-|Offset of waveform from 0|
|pulse-width|In|1|-|Pulse-width of pulse waves|
|sync|In|-1|[-1,1]|Trigger to reset the phase of the oscillator.|
|sine|Out|-|-|Sine|
|saw|Out|-|-|Saw|
|pulse|Out|-|-|Pulse|
|triangle|Out|-|-|Triangle|



### `(unit/pitch)`

Create an equal-tempered pitch with class and octave components. This is an easy way to get patch-level transposition.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|class|In|0|[0,12]|Pitch class starting at C|
|octave|In|0|-|Octave|
|out|Out|-|-||



### `(unit/slope)`

Two/three stage envelope generator.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|trigger|In|-1|[-1,1]|Strikes the envelope generator to create a 2-stage envelope|
|gate|In|-1|[-1,1]|Strikes and holds the envelope generator to create a 3-stage envelope|
|cycle|In|0|0, 1|Toggle for cycling|
|rise|In|100ms|-|Duration of rise stage|
|fall|In|100ms|-|Duration of fall stage|
|ratio|In|0.01|-|Adjusts the inflection points of the rise/fall curves|
|out|Out|-|-|Envelope signal|
|mirror|Out|-|-|Inverted envelope signal|
|eoc|Out|-|-|End of cycle|
|eor|Out|-|-|End of rise|



### `(unit/adsr)`

ADSR (Attack/Decay/Sustain/Release) envelope generator.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|gate|In|-1|[-1,1]|Strikes and holds the envelope generator, can also be used as trigger|
|cycle|In|0|0, 1|Toggle for cycling|
|attack|In|50ms|-|Duration of attack stage|
|decay|In|50ms|-|Duration of decay stage|
|sustain|In|0.5|-|Sustain level|
|sustain-hold|In|0ms|-|Duration of sustain stage, unused when gated|
|release|In|50ms|-|Duration of release stage|
|ratio|In|0.01|-|Adjusts the inflection points of the curves|
|out|Out|-|-|Envelope signal|
|mirror|Out|-|-|Inverted envelope signal|
|eoc|Out|-|-|End of cycle|



## Clock and Gate Sources

### `(unit/clock)`

Clock.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|tempo|In|1Hz|-||
|pulse-width|In|0.1|[0.1,1]|Width of the duty cycle|
|shuffle|In|0|[0,1]|Amount of shuffle|
|run|In|1|[-1,1]|On/off toggle for the clock|
|out|Out|-|[-1,1]||



### `(unit/clock-div)`

Clock divider.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|-1|[-1,1]|Clock signal|
|div|In|1|[1,any]|Divider|
|out|Out|-|[-1,1]|Divided clock signal|



### `(unit/clock-mult)`

Clock multiplier. Averages sequential clock pulses to derive tempo.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|-1|[-1,1]|Clock signal|
|mult|In|1|[1,any]|Multiplier|
|out|Out|-|[-1,1]|Multiplied clock signal|



### `(unit/euclid)`

Euclidean gate sequencer.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|clock|In|-1|[-1,1]|Clock signal|
|span|In|5|-|Total number of pulses|
|fill|In|2|-|Pulses to equally distribute throughout the `span`|
|offset|In|0|-|Shifts the filled pattern|
|out|Out|-|[-1,1]|Gate output|



### `(unit/gate-series options?)`

Gate series is a manual gate sequencer. Passes the clock signal through to a single output at a time and provides
outputs that represent each step of the sequence.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|4|[1,any]|Number of steps in the sequence|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|clock|In|-1|[-1,1]|Clock signal|
|advance|In|-1|[-1,1]|Trigger to step the sequencer|
|reset|In|-1|[-1,1]|Trigger to reset the sequencer|
|{index}|Out|-|[-1,1]|Gate output for step `{index}` of the sequence|



### `(unit/logic)`

Binary logic processor that can freely switch between a set of logic functions.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|-1|[-1,1]|Gate or trigger 1|
|y|In|-1|[-1,1]|Gate or trigger 2|
|mode|In|`logic/or`|`logic/or`, `logic/and`, `logic/xor`, `logic/nor`, `logic/nand`, `logic/nxor`|Logic function to use|
|out|Out|-|[-1,1]|Output of logic function|



### `(unit/stages options?)`

Sequencer modeled after some features in the Intellijel Metropolis.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|5|[1,any]|Number of stages in the sequence|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|clock|In|-1|[-1,1]|Clock signal|
|mode|In|`mode/forward`|`mode/forward`, `mode/reverse`, `mode/pingpong`, `mode/random`|Movement mode|
|reset|In|-1|[-1,1]|Reset trigger|
|stages|In|size property|-|Number of stages (of the total stages) to actually visit|
|glide-time|In|0|-|Duration to glide between stages (if `glide` is turned on for those stages)|
|{index}/freq|In|0|-|Frequency for stage|
|{index}/pulses|In|1|-|Number of pulses to spend in stage|
|{index}/mode|In|`mode/first`|`mode/rest`, `mode/first`, `mode/all`, `mode/hold`, `mode/last`|Gate mode for a stage|
|{index}/glide|In|-|-|Glide in and out of stage|
|{index}/data|In|-|-|Arbitrary data for stage|
|freq|Out|-|-|Frequency of the active stage|
|gate|Out|-|[-1,1]|Gates of the active stage|
|data|Out|-|-|Data of the active stage|
|eos|Out|-|[-1,1]|End of stage|


## Processing

### `(unit/center)`

Remove DC offset from signal; centering it at zero.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|-|-||
|out|Out|-|-||




### `(unit/clip)`

Hard or soft clipping of signal. If the unit is in soft-clipping mode, the signal will be compressed as it approaches
the specified level.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|1|-||
|soft|In|1|-|Toggle for soft clipping or hard clipping|
|level|In|1|-|Amplitude to clip|
|out|Out|-|-||



### `(unit/cond)`

Conditional. If `cond` is high (> 0), then `x` is output; otherwise `y` is output.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|cond|In|0|-||
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||



### `(unit/counter)`

Counter.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|trigger|In|-1|[-1,1]|Trigger to step the counter|
|reset|In|-1|[-1,1]|Trigger to reset the counter|
|limit|In|32|-|Limit to wrap the count|
|step|In|1|-|Amount to step the counter by|
|offset|In|0|-|Counter offset that's always added|
|out|Out|-|-|Count output|
|reset|Out|-|-|Gate that's high when the counter wraps or is manually reset via `reset` input|



### `(unit/decimate)`

Lower the resolution/bandwidth of a signal.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|rate|In|44100|-|Sample rate|
|bits|In|24|-|Bandwidth|
|out|Out|-|-||



### `(unit/delay)`

Delay with send/return feedback loop.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|time|In|500ms|[0,10s]|Duration of the delay|
|mix|In|0|[-1,1]|Dry/wet mix|
|fb-return|In|0|-|Return channel for a delayed signal sent out of `fb-send` output|
|fb-gain|In|0|[0,1]|Amount of feedback|
|out|Out|-|-||
|fb-send|Out|-|-|Delayed signal to be sent through other processors. Must come back in via `fb-return` if used.|



### `(unit/demux options?)`

De-multiplexer.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|1|[1,any]|Number of outputs to demux.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Signal to be demuxed|
|selection|In|1|-|Chooses the output to route to|
|{index}|Out|-|-||



### `(unit/dynamics)`

Dynamic compression.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|control|In|0|[0,1]|Level of compression|
|threshold|In|0.5|[0,1]|Threshold to start compression/expansion|
|above|In|0.3|[0,1]|Ratio above threshold|
|below|In|1|[0,1]|Ratio below threshold|
|clamp|In|10ms|-|Amount of time it takes to start compression/expansion|
|relax|In|10ms|-|Amount of time it takes to release compression/expansion|
|out|Out|-|-||



### `(unit/filter options?)`

Filter that provides simultaneous low-pass, band-pass and high-pass outputs.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|poles|4|[1,any]|Number of poles the filter has. Each pole attenuates -6dB.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|cutoff|In|1000Hz|-|Cutoff frequency.|
|res|In|1|[1,1000]|Resonance|
|lp|Out|-|-|Low-pass|
|bp|Out|-|-|Band-pass|
|hp|Out|-|-|High-pass|



### `(unit/fold)`

Folds a waveform at a specified amplitude.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Signal to fold|
|level|In|0|(0, any]|Level to fold|
|gain|In|0|-|Gain for final output|
|out|Out|-|[-1,1]|Folded signal|



### `(unit/gate)`

Gate that supports three modes:

- `mode/lp` (Low-pass Gate Mode): Only affect the frequency content of the signal
- `mode/both` (LPG + amplifier): Affect both frequency content and amplitude
- `mode/amp` (amplifier): Only affect amplitude of signal

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Signal to be modified|
|control|In|1|-|Level control|
|mode|In|1|`mode/lp`, `mode/both`, `mode/amp`|Setting of what to affect in the signal|
|cutoff-high|In|20,000Hz|-|High cutoff frequency for gated signals|
|cutoff-low|In|0Hz|-|Low cutoff frequency for gated signals|
|res|In|1|[1,1000]|Resonance of the filter|
|aux|In|0|-|Auxiliary input to be summed|
|out|Out|-|-|Gated signal|
|sum|Out|-|-|Gated signal + Auxiliary|



### `(unit/gate-mix options?)`

Mixer that combines gate signals.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|4|[1,any]|Number of inputs of the mixer.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|{index}|In|0|-|Input for mixer input `{index}`|
|out|Out|-|-||



### `(unit/lag)`

Slow rate-of-change of a signal.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|rise|In|5ms|-|Rise rate|
|fall|In|5ms|-|Fall rate|
|out|Out|-|-|Slowed signal|



### `(unit/latch)`

Sample and Hold.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|trigger|In|-1|[-1,1]|Trigger for locking the incoming value|
|out|Out|-|-|Latched signal|



### `(unit/lerp options?)`

Linear interpolate between two values.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|smooth-time|10ms|-|Milliseconds over which to smooth the input|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-||
|min|In|0|-|Minimum|
|max|In|1|-|Maximum|
|scale|In|1|[0,1]|Point between the `min` and `max`|
|out|Out|-|-|Interpolated value|



### `(unit/mix options?)`

Mixer.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|4|[1,any]|Number of inputs of the mixer.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|master|In|1|-|Master level for the mixer.|
|{index}/in|In|0|-|Input for mixer input `{index}`|
|{index}/level|In|1|-|Level for mixer input `{index}`|
|out|Out|-|-||



### `(unit/mux options?)`

Multiplexer.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|1|[1,any]|Number of inputs to mux.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|select|In|1|-|Chooses the input channel to route|
|{index}|In|0|-||
|out|Out|-|-||



### `(unit/overload)`

Sigmoid function that simulates overloading. Similar to soft-clip.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Input signal|
|gain|In|1|-|Gain before overloading|
|out|Out|-|-|Overloaded signal|



### `(unit/pan)`

Pan input between two outputs.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|1|-|Master level for the mixer.|
|pan|In|1|[-1,1]|Pan between `a` and `b`|
|a|Out|-|-||
|b|Out|-|-||



### `(unit/pan-mix options?)`

Panning mixer.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|4|[1,any]|Number of inputs of the mixer.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|master|In|1|-|Master level for the mixer.|
|{index}/in|In|0|-|Input for mixer input `{index}`|
|{index}/level|In|1|-|Level for mixer input `{index}`|
|{index}/pan|In|1|[-1,1]|Pan for mixer input `{index}`|
|a|Out|-|-|Left channel|
|b|Out|-|-|Right channel|



### `(unit/reverb)`

Reverb.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|a|In|0|-|Left channel input|
|b|In|0|-|Right channel input|
|defuse|In|0.5||All-pass gain|
|mix|In|0|[-1,1]|Wet/dry mix.|
|cutoff-pre|In|300Hz|-|Cutoff frequency for filter that is placed after stage one of all-pass filters.|
|cutoff-post|In|500Hz|-|Cutoff frequency for filter that is placed after stage two of all-pass filters.|
|decay|In|0.5|-|Amount of amplitude attenuation each cycle signal takes through the chamber.|
|size|In|0.1|[0.01,1]|Size of the chamber.|
|shift-semitones|In|0|[-12,12]|Semitones to shift each reverberation. Produces interesting chorus effects.|
|a|Out|-|-|Left channel output|
|b|Out|-|-|Right channel output|



### `(unit/quantize)`

Quantize a pitch to a set of intervals. 

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|intervals|Property|-|Any `theory/interval`|A `list` of `theory/interval`s to quantize to. Maximum size 32.|
|tonic|In|A4|-|Tonic to base all `theory/interval` transpositions around|
|in|In|0|[0,1]|Unipolar value that's to be quantized|
|out|Out|-|-|Quantized frequency|

Example:

```lisp
(define oscillator (unit/gen))
(define quant (unit/quantize))

; the output of the elided "source" Unit will be quantized to one of the three intervals
; P1, m3 and P5 around the tonic C4 resulting in the pitches: C4, Eb4 and G4
(-> quant
    (table :tonic (hz "C4")
           :in (<- source)
           :intervals (list (theory/interval :perfect 1) 
                            (theory/interval :minor 3) 
                            (theory/interval :perfect 5))))
(-> oscillator (table :freq (<- quant)))
(emit (<- oscillator :sine))
```



### `(unit/switch options?)`

Sequential switch.

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|size|4|[1,any]|Number of inputs of the switch.|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|trigger|In|-1|-1, 1|Advance to the next input|
|reset|In|-1|-1, 1|Reset to first input|
|{index}|In|0|-|Switch input|
|out|Out|-|-|Currently routed input signal|



### `(unit/toggle)`

High/low toggle 

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|trigger|In|-1|[-1,1]|Toggle state|
|out|Out|-|-1, 1|High or low signal|



### `(unit/transpose)`

Transpose a frequency by a number of equally-tempered semitones.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Frequency|
|semitones|In|0|-|Number of semitones to transpose by (+/-)|
|out|Out|-|-||



### `(unit/transpose-interval)`

Similar to `unit/transpose` except uses an interval quality and step instead of semitones.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|in|In|0|-|Frequency|
|quality|In|`quality/perfect`|`quality/perfect`, `quality/minor`, `quality/major`, `quality/diminished`, `quality/augmented`|Quality of the interval|
|step|In|0|-|Step of the interval|
|out|Out|-|-||



### `(unit/xfade)`

Crossfade two channels.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|a|In|0|-||
|b|In|0|-||
|mix|In|0|[-1,1]||
|out|Out|-|-||



### `(unit/xfeed)`

Variable bleed between two channels.

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|a|In|0|-||
|b|In|0|-||
|amount|In|0|[0,1]|Level of `a` bleeding into `b` and `b` bleeding into `a`.|
|a|Out|-|-||
|b|Out|-|-||







## Binary Operators

### `(unit/sum)`

`x + y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||

### `(unit/diff)`

`x - y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||

### `(unit/mult)`

`x * y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||

### `(unit/div)`

`x / y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|1||Cannot be zero.|
|out|Out|-|-||

### `(unit/mod)`

Remainder of `x/y`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|1||Cannot be zero.|
|out|Out|-|-||

### `(unit/gt)`

`x > y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/lt)`

`x < y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/and)`

`x and y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/or)`

`x or y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/xor)`

`x xor y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/nor)`

`x nor y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/imply)`

`x imply y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/xnor)`

`x xnor y`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|[-1,1]||

### `(unit/max)`

Maximum of `x` and `y`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||

### `unit/min`

Minimum of `x` and `y`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|y|In|0|-||
|out|Out|-|-||





## Unary Operators

### `(unit/abs)`

Absolute value of `x`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|[0,any]||

### `(unit/bipolar)`

Convert unipolar signal (x) to bipolar signal.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/ceil)`

Ceiling of `x`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/floor)`

Floor of `x`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/invert)`

`-x`

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/not)`

Not `x`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/noop)`

Direct passthrough of `x`.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

### `(unit/unipolar)`

Convert bipolar signal (x) to unipolar signal.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||

## MIDI Input

### `(unit/midi-clock options?)`

MIDI clock input

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|device|0|-|Index of the device in the `lumen -device-list` listing.|
|frame-rate|24|-|Expected frame rate of clock source|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|out|Out|-|[-1,1]|Clock signal|
|reset|Out|-|[-1,1]|Clock reset (move playhead back to beginning in DAW)|
|start|Out|-|[-1,1]|Start clock|
|stop|Out|-|[-1,1]|Stop clock|
|spp|Out|-|-|Song Position Pointer (SPP)|

### `(unit/midi-input options?)`

MIDI controller input

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|device|0|-|Index of the device in the `lumen -device-list` listing.|
|channels|`(list 1)`|-|List of channels to track and provide outputs for|

#### Inputs and Outputs

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|{channel}/pitch|Out|-|-|Frequency|
|{channel}/pitch-raw|Out|-|-|Raw MIDI pitch code|
|{channel}/gate|Out|-|-|Gate|
|{channel}/bend|Out|-|-|Pitch bend|
|{channel}/cc/{cc-number}|Out|-|-|CC number (1-128)|

## MIDI Output

None yet 😉

## Debug

### `(unit/debug options?)`

#### Options

|Name|Default|Range|Description|
|-|-|-|-|
|fmt|"%.8f"|-|Format to use for printing|

Format and print x to standard out.

|Name|Type|Default|Range|Description|
|-|-|-|-|-|
|x|In|0|-||
|out|Out|-|-||
