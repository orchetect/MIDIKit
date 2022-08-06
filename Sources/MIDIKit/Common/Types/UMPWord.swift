//
//  UMPWord.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    /// Universal MIDI Packet Word: Type representing four 8-bit bytes.
    public typealias UMPWord = UInt32
}

extension MIDI.UMPWord {
    /// Internal: Pack a `UInt32` with four 8-bit bytes.
    @inline(__always)
    internal init(
        _ byte0: MIDI.Byte,
        _ byte1: MIDI.Byte,
        _ byte2: MIDI.Byte,
        _ byte3: MIDI.Byte
    ) {
        self =
            (Self(byte0) << 24) +
            (Self(byte1) << 16) +
            (Self(byte2) << 8) +
            Self(byte3)
    }
    
    /// Internal: Pack a `UInt32` with two `UInt16`.
    @inline(__always)
    internal init(
        _ byte0and1: UInt16,
        _ byte2and3: UInt16
    ) {
        self =
            (Self(byte0and1) << 16) +
            Self(byte2and3)
    }
}

extension Collection where Element == MIDI.UMPWord {
    /// Internal: Flattens an array of `UInt32` words into an array of bytes.
    @inline(__always)
    internal func umpWordsToBytes() -> [MIDI.Byte] {
        var bytes: [MIDI.Byte] = []
        bytes.reserveCapacity(4 * count)
        
        forEach { word in
            let byte1 = MIDI.Byte((word & 0xFF00_0000) >> 24)
            let byte2 = MIDI.Byte((word & 0x00FF_0000) >> 16)
            let byte3 = MIDI.Byte((word & 0x0000_FF00) >> 8)
            let byte4 = MIDI.Byte(word & 0x0000_00FF)
            
            bytes.append(byte1)
            bytes.append(byte2)
            bytes.append(byte3)
            bytes.append(byte4)
        }
        
        return bytes
    }
}
