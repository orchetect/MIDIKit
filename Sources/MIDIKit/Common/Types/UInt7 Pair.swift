//
//  UInt7 Pair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.UInt7 {
    
    /// Type that holds a pair of `MIDI.UInt7`s - one MSB `UInt7`, one LSB `UInt7`.
    public struct Pair: Equatable, Hashable {
        
        public let msb: MIDI.UInt7
        public let lsb: MIDI.UInt7
        
        @inline(__always)
        public init(msb: MIDI.UInt7, lsb: MIDI.UInt7) {
            
            self.msb = msb
            self.lsb = lsb
            
        }
        
        public var uInt14Value: MIDI.UInt14 {
            
            .init(uInt7Pair: self)
            
        }
        
    }
    
}
