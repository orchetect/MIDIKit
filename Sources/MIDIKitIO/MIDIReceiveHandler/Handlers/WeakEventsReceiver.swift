//
//  WeakEventsReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiveHandler {
    /// MIDI Event receive handler that holds a weak reference to a receiver object.
    final class WeakEventsReceiver: MIDIReceiveHandlerProtocol {
        public weak var receiver: ReceivesMIDIEvents?
        
        let midi1Parser = MIDI1Parser()
        let midi2Parser = MIDI2Parser()
        
        let options: MIDIReceiverOptions
        
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handle(events: events)
            }
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                let events = midi2Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handle(events: events)
            }
        }
        
        init(
            options: MIDIReceiverOptions,
            receiver: ReceivesMIDIEvents
        ) {
            self.options = options
            midi1Parser.translateNoteOnZeroVelocityToNoteOff = options
                .contains(.translateMIDI1NoteOnZeroVelocityToNoteOff)
            self.receiver = receiver
        }
        
        func handle(events: [MIDIEvent]) {
            if options.contains(.filterActiveSensingAndClock) {
                let filtered = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
                guard !filtered.isEmpty else { return }
                receiver?.midiIn(events: filtered)
            } else {
                receiver?.midiIn(events: events)
            }
        }
    }
}

#endif
