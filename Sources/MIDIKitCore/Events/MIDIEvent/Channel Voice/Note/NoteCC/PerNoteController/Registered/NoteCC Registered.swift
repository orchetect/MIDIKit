//
//  NoteCC Registered.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController {
    // swiftformat:disable wrapSingleLineComments
    
    /// Registered Per-Note Controller
    /// (MIDI 2.0)
    public enum Registered: Equatable, Hashable {
        // Registered Per-Note CC 0 undefined
    
        /// Modulation Wheel
        /// (Int: 1, Hex: 0x01)
        case modWheel
    
        /// Breath Controller
        /// (Int: 2, Hex: 0x02)
        case breath
    
        /// Pitch 7.25
        /// (Int: 3, Hex: 0x03)
        ///
        /// See `Pitch7_25` to convert `UInt32` value data to/from pitch 7.25 values.
        case pitch7_25
    
        // Registered Per-Note CC 4 ... 6 undefined
    
        /// Volume
        /// (Int: 7, Hex: 0x07)
        case volume
    
        /// Balance
        /// (Int: 8, Hex: 0x08)
        case balance
    
        // Registered Per-Note CC 9 undefined
    
        /// Pan
        /// (Int: 10, Hex: 0x0A)
        case pan
    
        /// Expression
        /// (Int: 11, Hex: 0x0B)
        case expression
    
        // Registered Per-Note CC 12 ... 69 undefined
    
        /// Sound Controller 1
        /// (default: Sound Variation)
        /// (Int: 70, Hex: 0x46)
        case soundCtrl1_soundVariation
    
        /// Sound Controller 2
        /// (default: Timbre/Harmonic Intensity)
        /// (Int: 71, Hex: 0x47)
        case soundCtrl2_timbreIntensity
    
        /// Sound Controller 3
        /// (default: Release Time)
        /// (Int: 72, Hex: 0x48)
        case soundCtrl3_releaseTime
    
        /// Sound Controller 4
        /// (default: Attack Time)
        /// (Int: 73, Hex: 0x49)
        case soundCtrl4_attackTime
    
        /// Sound Controller 5
        /// (default: Brightness)
        /// (Int: 74, Hex: 0x4A)
        case soundCtrl5_brightness
    
        /// Sound Controller 6
        /// (default: Decay Time - see MMA [RP-021](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/sound-controller-defaults-revised))
        /// (Int: 75, Hex: 0x4B)
        case soundCtrl6_decayTime
    
        /// Sound Controller 7
        /// (default: Vibrato Rate - see MMA [RP-021](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/sound-controller-defaults-revised))
        /// (Int: 76, Hex: 0x4C)
        case soundCtrl7_vibratoRate
    
        /// Sound Controller 8
        /// (default: Vibrato Depth - see MMA [RP-021](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/sound-controller-defaults-revised))
        /// (Int: 77, Hex: 0x4D)
        case soundCtrl8_vibratoDepth
    
        /// Sound Controller 9
        /// (default: Vibrato Delay - see MMA [RP-021](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/sound-controller-defaults-revised))
        /// (Int: 78, Hex: 0x4E)
        case soundCtrl9_vibratoDelay
    
        /// Sound Controller 10
        /// (default: Undefined - see MMA [RP-021](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/sound-controller-defaults-revised))
        /// (Int: 79, Hex: 0x4F)
        case soundCtrl10_defaultUndefined
    
        // Registered Per-Note CC 80 ... 90 undefined
    
        /// Effects 1 Depth
        /// (default: Reverb Send Level - see MMA [RP-023](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/renaming-of-cc91-and-cc93))
        /// (formerly External Effects Depth)
        /// (Int: 91, Hex: 0x5B)
        case effects1Depth_reverbSendLevel
    
        /// Effects 2 Depth
        /// (formerly Tremolo Depth)
        /// (Int: 92, Hex: 0x5C)
        case effects2Depth
    
        /// Effects 3 Depth
        /// (default: Chorus Send Level - see MMA [RP-023](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/renaming-of-cc91-and-cc93))
        /// (formerly Chorus Depth)
        /// (Int: 93, Hex: 0x5D)
        case effects3Depth_chorusSendLevel
    
        /// Effects 4 Depth
        /// (formerly Celeste [Detune] Depth)
        /// (Int: 94, Hex: 0x5E)
        case effects4Depth
    
        /// Effects 5 Depth
        /// (formerly Phaser Depth)
        /// (Int: 95, Hex: 0x5F)
        case effects5Depth
    
        // Per-Note CC 96 ... 255 undefined
    
        /// Undefined controller number
        case undefined(Undefined)
    }
    // swiftformat:enable wrapSingleLineComments
}
