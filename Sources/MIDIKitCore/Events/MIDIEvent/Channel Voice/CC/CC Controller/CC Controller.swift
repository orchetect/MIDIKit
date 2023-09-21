//
//  CC Controller.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC {
    // swiftformat:disable wrapSingleLineComments
    
    /// MIDI Control Change Controller
    /// (MIDI 1.0 / MIDI 2.0)
    public enum Controller: Equatable, Hashable {
        /// Bank Select
        /// (Int: 0, Hex: 0x00)
        case bankSelect
    
        /// Modulation Wheel
        /// (Int: 1, Hex: 0x01)
        case modWheel
    
        /// Breath Controller
        /// (Int: 2, Hex: 0x02)
        case breath
    
        // CC 3 undefined
    
        /// Foot Controller
        /// (Int: 4, Hex: 0x04)
        case footController
    
        /// Portamento Time
        /// (Int: 5, Hex: 0x05)
        case portamentoTime
    
        /// Data Entry MSB
        /// (Int: 6, Hex: 0x06)
        case dataEntry
    
        /// Channel Volume
        /// (Int: 7, Hex: 0x07)
        case volume
    
        /// Balance
        /// (Int: 8, Hex: 0x08)
        case balance
    
        // CC 9 undefined
    
        /// Pan
        /// (Int: 10, Hex: 0x0A)
        case pan
    
        /// Expression Controller
        /// (Int: 11, Hex: 0x0B)
        case expression
    
        /// Effect Control 1
        /// (Int: 12, Hex: 0x0C)
        case effectControl1
    
        /// Effect Control 2
        /// (Int: 13, Hex: 0x0D)
        case effectControl2
    
        // CC 14 ... 15 undefined
    
        /// General Purpose Controller 1
        /// (Int: 16, Hex: 0x10)
        case generalPurpose1
    
        /// General Purpose Controller 2
        /// (Int: 17, Hex: 0x11)
        case generalPurpose2
    
        /// General Purpose Controller 3
        /// (Int: 18, Hex: 0x12)
        case generalPurpose3
    
        /// General Purpose Controller 4
        /// (Int: 19, Hex: 0x13)
        case generalPurpose4
    
        // CC 20 ... 31 undefined
    
        /// LSB CCs for controllers `0 ... 31`, corresponding to `32 ... 63`
        /// (Int: `32 ... 63`, Hex: `0x20 ... 0x3F`)
        case lsb(for: LSB)
    
        /// Sustain Pedal (Damper Pedal)
        /// (Int: 64, Hex: 0x40)
        ///
        /// Values: `0 ... 63` off, `64 ... 127` on.
        ///
        /// However, some hardware and synths respond variably to continuous values 0-127.
        case sustainPedal
    
        /// Portamento
        /// (Int: 65, Hex: 0x41)
        ///
        /// Values: `0 ... 63` off, `64 ... 127` on.
        case portamento
    
        /// Sostenuto Pedal
        /// (Int: 66, Hex: 0x42)
        ///
        /// Values: `0 ... 63` off, `64 ... 127` on.
        ///
        /// However, some hardware and synths support variably to continuous values 0-127.
        case sostenutoPedal
    
        /// Soft Pedal
        /// (Int: 67, Hex: 0x43)
        ///
        /// Values: `0 ... 63` off, `64 ... 127` on.
        ///
        /// However, some hardware and synths support variably to continuous values 0-127.
        case softPedal
    
        /// Legato Footswitch
        /// (Int: 68, Hex: 0x44)
        ///
        /// Values: `0 ... 63` = Normal, `64 ... 127` = Legato.
        case legatoFootswitch
    
        /// Hold 2
        /// (Int: 69, Hex: 0x45)
        ///
        /// Values: `0 ... 63` off, `64 ... 127` on.
        case hold2
    
        /// Sound Controller 1 (default: Sound Variation)
        /// (Int: 70, Hex: 0x46)
        case soundCtrl1_soundVariation
    
        /// Sound Controller 2
        /// (default: Timbre/Harmonic Intens.)
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
    
        /// General Purpose Controller 5
        /// (Int: 80, Hex: 0x50)
        case generalPurpose5
    
        /// General Purpose Controller 6
        /// (Int: 81, Hex: 0x51)
        case generalPurpose6
    
        /// General Purpose Controller 7
        /// (Int: 82, Hex: 0x52)
        case generalPurpose7
    
        /// General Purpose Controller 8
        /// (Int: 83, Hex: 0x53)
        case generalPurpose8
    
        /// Portamento Control
        /// (Int: 84, Hex: 0x54)
        case portamentoControl
    
        // CC 85 ... 87 undefined
    
        /// High Resolution Velocity Prefix
        /// (Int: 88, Hex: 0x58)
        ///
        /// Defined in Addenda [CA-031](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/high-resolution-velocity-prefix)
        /// of MIDI 1.0
        case highResolutionVelocityPrefix
    
        // CC 89 ... 90 undefined
    
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
    
        /// Data Increment (Data Entry +1)
        /// (see MMA [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers))
        /// (Int: 96, Hex: 0x60)
        ///
        /// Typically this message does not contain a value byte,
        /// so it is recommended to pass `nil`.
        case dataIncrement
    
        /// Data Decrement (Data Entry -1)
        /// (see MMA [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers))
        /// (Int: 97, Hex: 0x61)
        ///
        /// Typically this message does not contain a value byte,
        /// so it is recommended to pass `nil`.
        case dataDecrement
    
        /// NRPN LSB (Non-Registered Parameter Number)
        /// (Int: 98, Hex: 0x62)
        case nrpnLSB
    
        /// NRPN MSB (Non-Registered Parameter Number)
        /// (Int: 99, Hex: 0x63)
        case nrpnMSB
    
        /// RPN LSB (Registered Parameter Number)
        /// (Int: 100, Hex: 0x64)
        case rpnLSB
    
        /// RPN MSB (Registered Parameter Number)
        /// (Int: 101, Hex: 0x65)
        case rpnMSB
    
        /// Channel Mode Message
        /// (Includes: `120 ... 127`)
        case mode(Mode)
    
        /// Undefined controller number
        /// (Includes: 9, 14, 15, 20 ... 31, 85 ... 87, 89, 90, 102 ... 119)
        case undefined(Undefined)
    }
    // swiftformat:enable wrap
}
