//
//  RawData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIIOReceiveHandler {
    /// Basic raw packet data receive handler.
    public final class RawData: MIDIIOReceiveHandlerProtocol {
        public typealias Handler = (_ packet: AnyMIDIPacket) -> Void
        
        @inline(__always)
        public var handler: Handler
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let typeErasedPacket = AnyMIDIPacket.packet(midiPacket)
                handler(typeErasedPacket)
            }
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                let typeErasedPacket = AnyMIDIPacket.universalPacket(midiPacket)
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

#endif
