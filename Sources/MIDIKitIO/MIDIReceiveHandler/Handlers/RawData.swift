//
//  RawData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    public typealias RawDataHandler = (_ packet: AnyMIDIPacket) -> Void
}

extension MIDIReceiveHandler {
    /// Raw packet data receive handler.
    /// This handler is provided for debugging and data introspection but is discouraged for
    /// manually parsing MIDI packets. It is recommended to use a MIDI event handler instead.
    internal final class RawData: MIDIReceiveHandlerProtocol {
        public var handler: MIDIReceiver.RawDataHandler
    
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let typeErasedPacket = AnyMIDIPacket.packet(midiPacket)
                handler(typeErasedPacket)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
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
            _ handler: @escaping MIDIReceiver.RawDataHandler
        ) {
            self.handler = handler
        }
    }
}

#endif
