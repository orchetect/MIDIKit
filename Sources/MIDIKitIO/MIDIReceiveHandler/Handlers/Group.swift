//
//  Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiveHandler {
    /// ``MIDIReceiveHandler`` group.
    /// Can contain one or more ``MIDIReceiveHandler`` in series.
    class Group: MIDIIOReceiveHandlerProtocol {
        public var receiveHandlers: [MIDIReceiveHandler] = []
    
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for handler in receiveHandlers {
                handler.packetListReceived(packets)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for handler in receiveHandlers {
                handler.eventListReceived(packets, protocol: midiProtocol)
            }
        }
    
        internal init(_ receiveHandlers: [MIDIReceiveHandler]) {
            self.receiveHandlers = receiveHandlers
        }
    }
}

#endif
