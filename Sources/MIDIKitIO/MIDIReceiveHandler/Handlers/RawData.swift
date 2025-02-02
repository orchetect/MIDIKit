//
//  RawData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    /// Handler for the ``rawData(_:)`` MIDI receiver.
    public typealias RawDataHandler = @Sendable (_ packet: AnyMIDIPacket) -> Void
    
    /// Raw packet data receive handler.
    /// This handler is provided for debugging and data introspection but is discouraged for
    /// manually parsing MIDI packets. It is recommended to use a MIDI event handler instead.
    final class RawData: MIDIReceiverProtocol {
        let handler: RawDataHandler
    
        func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let typeErasedPacket = AnyMIDIPacket.packet(midiPacket)
                handler(typeErasedPacket)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                let typeErasedPacket = AnyMIDIPacket.universalPacket(midiPacket)
                handler(typeErasedPacket)
            }
        }
    
        init(
            handler: @escaping MIDIReceiver.RawDataHandler
        ) {
            self.handler = handler
        }
    }
}

#endif
