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
            
            for midiPacketPacketPtr in packetListPtr.mkUnsafeSequence() {
                let packetData = MIDI.Packet.PacketData(midiPacketPacketPtr)
                let typeErasedPacket = MIDI.Packet.packet(packetData)
                handler(typeErasedPacket)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            for universalMIDIPacketPtr in eventListPtr.unsafeSequence() { 
                let universalPacketData = MIDI.Packet.UniversalPacketData(universalMIDIPacketPtr)
                let typeErasedPacket = MIDI.Packet.universalPacket(universalPacketData)
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
