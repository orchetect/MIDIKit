//
//  RawData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO.ReceiveHandler {
    
    /// Basic raw packet data receive handler.
    public struct RawData: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packet: MIDI.Packet) -> Void
        
        @inline(__always) public var handler: Handler
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            packetListPtr.mkUnsafeSequence().forEach { midiPacketPacketPtr in
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
            
            eventListPtr.unsafeSequence().forEach { universalMIDIPacketPtr in
                let universalPacketData = MIDI.Packet.UniversalPacketData(universalMIDIPacketPtr)
                let typeErasedPacket = MIDI.Packet.universalPacket(universalPacketData)
                handler(typeErasedPacket)
            }
            
        }
        
        public init(
            _ handler: @escaping Handler
        ) {
            
            self.handler = handler
            
        }
        
    }
    
}
