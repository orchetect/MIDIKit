//
//  PacketData PacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.Packet {
    
    /// Clean consolidated data encapsulation of raw data from a CoreMIDI MIDI 1.0 `MIDIPacket`.
    public struct PacketData {
        
        let bytes: [MIDI.Byte]
        
        let timeStamp: MIDITimeStamp
        
        //@inline(__always) public init(data: Data, timeStamp: MIDITimeStamp) {
        //
        //    self.data = data
        //    self.timeStamp = timeStamp
        //
        //}
        
        @inline(__always) public init(bytes: [MIDI.Byte], timeStamp: MIDITimeStamp) {
            
            self.bytes = bytes
            self.timeStamp = timeStamp
            
        }
        
    }
    
}
