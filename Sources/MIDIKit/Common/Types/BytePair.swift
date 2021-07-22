//
//  BytePair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// Type that holds a pair of `MIDI.Byte`s - one MSB `Byte`, one LSB `Byte`
    public struct BytePair: Equatable, Hashable {
        
        public let MSB: MIDI.Byte
        public let LSB: MIDI.Byte
        
        @inline(__always) public init(MSB: MIDI.Byte, LSB: MIDI.Byte) {
            self.MSB = MSB
            self.LSB = LSB
        }
        
    }
    
}
