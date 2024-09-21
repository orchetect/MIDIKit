//
//  Controller Mode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// Channel Mode Messages (CC numbers `120 ... 127`)
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// These messages are originally defined in the MIDI 1.0 Spec as channel-wide settings
    /// modifying the operation of the channel.
    public enum Mode: Equatable, Hashable {
        /// [Channel Mode Message] All Sound Off
        /// (Int: 120, Hex: 0x78)
        case allSoundOff
    
        /// [Channel Mode Message] Reset All Controllers
        /// (See MMA [RP-015](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-reset-all-controllers))
        /// (Int: 121, Hex: 0x79)
        case resetAllControllers
    
        /// [Channel Mode Message] Local Control On/Off
        /// (Int: 122, Hex: 0x7A)
        case localControl
    
        /// [Channel Mode Message] All Notes Off
        /// (Int: 123, Hex: 0x7B)
        case allNotesOff
    
        /// [Channel Mode Message] Omni Mode Off (+ all notes off)
        /// (Int: 124, Hex: 0x7C)
        case omniModeOff
    
        /// [Channel Mode Message] Omni Mode On (+ all notes off)
        /// (Int: 125, Hex: 0x7D)
        case omniModeOn
    
        /// [Channel Mode Message] Mono Mode On (+ poly off, + all notes off)
        /// (Int: 126, Hex: 0x7E)
        case monoModeOn
    
        /// [Channel Mode Message] Poly Mode On (+ mono off, + all notes off)
        /// (Int: 127, Hex: 0x7F)
        case polyModeOn
    }
}

extension MIDIEvent.CC.Controller.Mode: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.CC.Controller.Mode: Sendable { }

extension MIDIEvent.CC.Controller.Mode {
    /// Returns the controller number.
    public var controller: UInt7 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .allSoundOff:         return 120
        case .resetAllControllers: return 121
        case .localControl:        return 122
        case .allNotesOff:         return 123
        case .omniModeOff:         return 124
        case .omniModeOn:          return 125
        case .monoModeOn:          return 126
        case .polyModeOn:          return 127
        }
        // swiftformat:enable spacearoundoperators
    }
}

extension MIDIEvent.CC.Controller.Mode {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .allSoundOff:         return "All Sound Off"
        case .resetAllControllers: return "Reset All Controllers"
        case .localControl:        return "Local Control"
        case .allNotesOff:         return "All Notes Off"
        case .omniModeOff:         return "Omni Mode Off"
        case .omniModeOn:          return "Omni Mode On"
        case .monoModeOn:          return "Mono Mode On"
        case .polyModeOn:          return "Poly Mode On"
        }
        // swiftformat:enable spacearoundoperators
    }
}
