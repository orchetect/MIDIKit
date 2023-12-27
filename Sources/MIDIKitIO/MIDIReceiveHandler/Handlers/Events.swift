//
//  Events.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    /// Handler for events-based MIDI receivers.
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    public typealias EventsHandler = (
        _ events: [MIDIEvent],
        _ timeStamp: CoreMIDITimeStamp,
        _ source: MIDIOutputEndpoint?
    ) -> Void
    
    /// MIDI Event receive handler including packet timestamp and source endpoint.
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    final class Events: EventsBase {
        var handler: MIDIReceiver.EventsHandler
        
        init(
            options: MIDIReceiverOptions,
            handler: @escaping MIDIReceiver.EventsHandler
        ) {
            if options.contains(.filterActiveSensingAndClock) {
                self.handler = { events, timeStamp, source in
                    let filtered = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
                    guard !filtered.isEmpty else { return }
                    handler(filtered, timeStamp, source)
                }
            } else {
                self.handler = handler
            }
            
            super.init(options: options)
        }
        
        override func handle(
            events: [MIDIEvent],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
            handler(events, timeStamp, source)
        }
    }
}

#endif
