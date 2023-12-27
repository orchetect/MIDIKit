//
//  WeakEventsReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiveHandler {
    /// MIDI Event receive handler that holds a weak reference to a receiver object that conforms
    /// to the ``ReceivesMIDIEvents`` protocol.
    final class WeakEventsReceiver: EventsBase {
        weak var receiver: ReceivesMIDIEvents?
        
        init(
            options: MIDIReceiverOptions,
            receiver: ReceivesMIDIEvents
        ) {
            self.receiver = receiver
            
            super.init(options: options)
        }
        
        override func handle(
            events: [MIDIEvent],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
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
