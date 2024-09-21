//
//  Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    /// ``MIDIReceiveHandler`` group.
    /// Can contain one or more ``MIDIReceiver`` in series.
    final class Group: MIDIReceiverProtocol {
        var receiveHandlers: [MIDIReceiverProtocol] = []
    
        func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for handler in receiveHandlers {
                handler.packetListReceived(packets)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for handler in receiveHandlers {
                handler.eventListReceived(packets, protocol: midiProtocol)
            }
        }
    
        init(_ receiveHandlers: [MIDIReceiverProtocol]) {
            self.receiveHandlers = receiveHandlers
        }
    }
}

#endif
