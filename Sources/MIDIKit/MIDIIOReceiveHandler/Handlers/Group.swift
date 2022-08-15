//
//  Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIIOReceiveHandler {
    /// `ReceiveHandler` group.
    /// Can contain one or more `ReceiveHandler` in series.
    public final class Group: MIDIIOReceiveHandlerProtocol {
        public var receiveHandlers: [MIDIIOReceiveHandler] = []
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for handler in receiveHandlers {
                handler.packetListReceived(packets)
            }
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for handler in receiveHandlers {
                handler.eventListReceived(packets, protocol: midiProtocol)
            }
        }
        
        internal init(_ receiveHandlers: [MIDIIOReceiveHandler]) {
            self.receiveHandlers = receiveHandlers
        }
    }
}

#endif
