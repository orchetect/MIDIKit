//
//  Controller LSB.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// MIDI Controller Change LSB
    /// (MIDI 1.0 / MIDI 2.0)
    public enum LSB {
        /// LSB for Control 0 (Bank Select)
        /// (Int: 32, Hex: 0x20)
        case bankSelect
    
        /// LSB for Control 1 (Modulation Wheel)
        /// (Int: 33, Hex: 0x21)
        case modWheel
    
        /// LSB for Control 2 (Breath Controller)
        /// (Int: 34, Hex: 0x22)
        case breath
    
        // CC 35 undefined
    
        /// LSB for Control 4 (Foot Controller)
        /// (Int: 36, Hex: 0x24)
        case footController
    
        /// LSB for Control 5 (Portamento Time)
        /// (Int: 37, Hex: 0x25)
        case portamentoTime
    
        /// LSB for Control 6 (Data Entry)
        /// (Int: 38, Hex: 0x26)
        case dataEntry
    
        /// LSB for Control 7 (Channel Volume)
        /// (Int: 39, Hex: 0x27)
        case channelVolume
    
        /// LSB for Control 8 (Balance)
        /// (Int: 40, Hex: 0x28)
        case balance
    
        // CC 41 undefined
    
        /// LSB for Control 10 (Pan)
        /// (Int: 42, Hex: 0x2A)
        case pan
    
        /// LSB for Control 11 (Expression Controller)
        /// (Int: 43, Hex: 0x2B)
        case expression
    
        /// LSB for Control 12 (Effect control 1)
        /// (Int: 44, Hex: 0x2C)
        case effectControl1
    
        /// LSB for Control 13 (Effect control 2)
        /// (Int: 45, Hex: 0x2D)
        case effectControl2
    
        // CC 46 ... 47 undefined
    
        /// LSB for Control 16 (General Purpose Controller 1)
        /// (Int: 48, Hex: 0x30)
        case generalPurpose1
    
        /// LSB for Control 17 (General Purpose Controller 2)
        /// (Int: 49, Hex: 0x31)
        case generalPurpose2
    
        /// LSB for Control 18 (General Purpose Controller 3)
        /// (Int: 50, Hex: 0x32)
        case generalPurpose3
    
        /// LSB for Control 19 (General Purpose Controller 4)
        /// (Int: 51, Hex: 0x33)
        case generalPurpose4
    
        // CC 52 ... 63 undefined
    
        /// LSBs for Undefined controller numbers
        /// (Includes undefined controllers `20 ... 31`,
        /// corresponding to undefined LSBs of `52 ... 63`)
        case undefined(LSB.Undefined)
    }
}

extension MIDIEvent.CC.Controller.LSB: Equatable { }

extension MIDIEvent.CC.Controller.LSB: Hashable { }

extension MIDIEvent.CC.Controller.LSB: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.CC.Controller.LSB: Sendable { }

extension MIDIEvent.CC.Controller.LSB {
    /// Returns the controller number.
    @inlinable
    public var controller: UInt7 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .bankSelect:      32
        case .modWheel:        33
        case .breath:          34
        case .footController:  36
        case .portamentoTime:  37
        case .dataEntry:       38
        case .channelVolume:   39
        case .balance:         40
        case .pan:             42
        case .expression:      43
        case .effectControl1:  44
        case .effectControl2:  45
        case .generalPurpose1: 48
        case .generalPurpose2: 49
        case .generalPurpose3: 50
        case .generalPurpose4: 51
        case let .undefined(undefinedCC):
            undefinedCC.controller
        }
        // swiftformat:enable spacearoundoperators
    }
}

extension MIDIEvent.CC.Controller.LSB {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .bankSelect:      "Bank Select LSB"
        case .modWheel:        "Mod Wheel LSB"
        case .breath:          "Breath Controller LSB"
        case .footController:  "Foot Controller LSB"
        case .portamentoTime:  "PortamentoTime LSB"
        case .dataEntry:       "Data Entry LSB"
        case .channelVolume:   "Volume LSB"
        case .balance:         "Balance LSB"
        case .pan:             "Pan LSB"
        case .expression:      "Expression LSB"
        case .effectControl1:  "Effect Control 1 LSB"
        case .effectControl2:  "Effect Control 2 LSB"
        case .generalPurpose1: "General Purpose 1 LSB"
        case .generalPurpose2: "General Purpose 2 LSB"
        case .generalPurpose3: "General Purpose 3 LSB"
        case .generalPurpose4: "General Purpose 4 LSB"
        case let .undefined(undefinedCC):
            undefinedCC.name
        }
        // swiftformat:enable spacearoundoperators
    }
}
