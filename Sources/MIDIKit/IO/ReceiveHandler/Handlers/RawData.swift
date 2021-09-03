//
//  RawData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO.ReceiveHandler {
    
    /// Basic raw packet data receive handler.
    public class RawData: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packet: MIDI.Packet) -> Void
        
        @inline(__always) public var handler: Handler
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            for midiPacket in packetListPtr.packets() {
                let typeErasedPacket = MIDI.Packet.packet(midiPacket)
                handler(typeErasedPacket)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            for midiPacket in eventListPtr.packets() {
                let typeErasedPacket = MIDI.Packet.universalPacket(midiPacket)
                handler(typeErasedPacket)
            }
            
        }
        
        internal init(
            _ handler: @escaping Handler
        ) {
            
            self.handler = handler
            
        }
        
    }
    
}
