//
//  Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension MIDI.IO.ReceiveHandler {
    /// `ReceiveHandler` group.
    /// Can contain one or more `ReceiveHandler` in series.
    public class Group: MIDIIOReceiveHandlerProtocol {
        public var receiveHandlers: [MIDI.IO.ReceiveHandler] = []
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDI.IO.Packet.PacketData]
        ) {
            for handler in receiveHandlers {
                handler.packetListReceived(packets)
            }
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [MIDI.IO.Packet.UniversalPacketData],
            protocol midiProtocol: MIDI.IO.ProtocolVersion
        ) {
            for handler in receiveHandlers {
                handler.eventListReceived(packets, protocol: midiProtocol)
            }
        }
        
        internal init(_ receiveHandlers: [MIDI.IO.ReceiveHandler]) {
            self.receiveHandlers = receiveHandlers
        }
    }
}

#endif
