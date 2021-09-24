//
//  UMPWord.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// Universal MIDI Packet Word: Type representing four 8-bit bytes
    public typealias UMPWord = UInt32
    
}

extension MIDI.UMPWord {
    
    /// Internal: Pack a UInt32 with four 8-bit bytes.
    @inline(__always) internal init(
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
    
    /// Internal: Pack a UInt32 with two 16-bit UInt16r.
    @inline(__always) internal init(
        _ byte0and1: UInt16,
        _ byte2and3: UInt16
    ) {
        
        self =
            (Self(byte0and1) << 16) +
            Self(byte2and3)
        
    }
    
}
