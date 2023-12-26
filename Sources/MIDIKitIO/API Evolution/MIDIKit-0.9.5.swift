//
//  MIDIKit-0.9.5.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    public typealias LegacyEventsHandler = (
        _ events: [MIDIEvent]
    ) -> Void
    
    @available(
        *,
         deprecated,
         renamed: "events",
         message: "This receive handler's closure now takes 3 parameters instead of one. (events, timeStamp, source)"
    )
    public static func events(
        options: MIDIReceiverOptions = [],
        _ handler: @escaping LegacyEventsHandler
    ) -> Self {
        .events(options: options) { events, _, _ in
            handler(events)
        }
    }
    
    @available(
        *,
        deprecated,
        renamed: "events",
        message: "`eventsWithMetadata` is now renamed to `events`, and the old `events` receive handler without metadata has been removed."
    )
    public static func eventsWithMetadata(
        options: MIDIReceiverOptions = [],
        _ handler: @escaping EventsHandler
    ) -> Self {
        .events(options: options, handler)
    }
}

#endif
