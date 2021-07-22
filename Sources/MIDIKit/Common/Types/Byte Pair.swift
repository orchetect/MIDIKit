//
//  BytePair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Byte {
    
    /// Type that holds a pair of `MIDI.Byte`s - one MSB `Byte`, one LSB `Byte`
    public struct Pair: Equatable, Hashable {
        
        public let msb: MIDI.Byte
        public let lsb: MIDI.Byte
        
        @inline(__always) public init(msb: MIDI.Byte, lsb: MIDI.Byte) {
            self.msb = msb
            self.lsb = lsb
        }
        
    }
    
}
