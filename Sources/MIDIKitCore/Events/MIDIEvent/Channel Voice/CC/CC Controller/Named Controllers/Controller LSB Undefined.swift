//
//  Controller LSB Undefined.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller.LSB {
    /// Undefined MIDI CC LSB Controllers
    /// (MIDI 1.0 / MIDI 2.0)
    public enum Undefined {
        /// LSB for Undefined controller number 3
        /// (Int: 35, Hex: 0x23)
        case cc3
    
        /// LSB for Undefined controller number 9
        /// (Int: 41, Hex: 0x29)
        case cc9
    
        /// LSB for Undefined controller number 14
        /// (Int: 46, Hex: 0x2E)
        case cc14
    
        /// LSB for Undefined controller number 15
        /// (Int: 47, Hex: 0x2F)
        case cc15
    
        /// LSB for Undefined controller number 20
        /// (Int: 52, Hex: 0x34)
        case cc20
    
        /// LSB for Undefined controller number 21
        /// (Int: 53, Hex: 0x35)
        case cc21
    
        /// LSB for Undefined controller number 22
        /// (Int: 54, Hex: 0x36)
        case cc22
    
        /// LSB for Undefined controller number 23
        /// (Int: 55, Hex: 0x37)
        case cc23
    
        /// LSB for Undefined controller number 24
        /// (Int: 56, Hex: 0x38)
        case cc24
    
        /// LSB for Undefined controller number 25
        /// (Int: 57, Hex: 0x39)
        case cc25
    
        /// LSB for Undefined controller number 26
        /// (Int: 58, Hex: 0x3A)
        case cc26
    
        /// LSB for Undefined controller number 27
        /// (Int: 59, Hex: 0x3B)
        case cc27
    
        /// LSB for Undefined controller number 28
        /// (Int: 60, Hex: 0x3C)
        case cc28
    
        /// LSB for Undefined controller number 29
        /// (Int: 61, Hex: 0x3D)
        case cc29
    
        /// LSB for Undefined controller number 30
        /// (Int: 62, Hex: 0x3E)
        case cc30
    
        /// LSB for Undefined controller number 31
        /// (Int: 63, Hex: 0x3F)
        case cc31
    }
}

extension MIDIEvent.CC.Controller.LSB.Undefined: Equatable { }

extension MIDIEvent.CC.Controller.LSB.Undefined: Hashable { }

extension MIDIEvent.CC.Controller.LSB.Undefined: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.CC.Controller.LSB.Undefined: Sendable { }

extension MIDIEvent.CC.Controller.LSB.Undefined {
    /// Returns the controller number.
    @inlinable
    public var controller: UInt7 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .cc3:  35
        case .cc9:  41
        case .cc14: 46
        case .cc15: 47
        case .cc20: 52
        case .cc21: 53
        case .cc22: 54
        case .cc23: 55
        case .cc24: 56
        case .cc25: 57
        case .cc26: 58
        case .cc27: 59
        case .cc28: 60
        case .cc29: 61
        case .cc30: 62
        case .cc31: 63
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns the LSB's corresponding MSB controller number.
    @inlinable
    public var msbController: UInt7 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .cc3:  3
        case .cc9:  9
        case .cc14: 14
        case .cc15: 15
        case .cc20: 20
        case .cc21: 21
        case .cc22: 22
        case .cc23: 23
        case .cc24: 24
        case .cc25: 25
        case .cc26: 26
        case .cc27: 27
        case .cc28: 28
        case .cc29: 29
        case .cc30: 30
        case .cc31: 31
        }
        // swiftformat:enable spacearoundoperators
    }
}

extension MIDIEvent.CC.Controller.LSB.Undefined {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        "Undefined CC\(msbController) LSB"
    }
}
