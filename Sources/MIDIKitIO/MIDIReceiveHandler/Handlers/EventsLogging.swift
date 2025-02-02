//
//  EventsLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import os.log

extension MIDIReceiver {
    /// Handler for the ``eventsLogging(options:_:)`` MIDI receiver.
    public typealias EventsLoggingHandler = @Sendable (_ eventString: String) -> Void
    
    /// MIDI Event logging handler (event description strings).
    /// If `handler` is nil, all events are logged to the console (but only in `DEBUG` preprocessor
    /// flag builds).
    /// If `handler` is provided, the event description string is supplied as a parameter and not
    /// automatically logged.
    static func _eventsLogging(
        options: MIDIReceiverOptions,
        log: OSLog = .default,
        handler: EventsLoggingHandler?
    ) -> Events {
        let stringLogHandler: EventsLoggingHandler = handler
            ?? { packetBytesString in
                #if DEBUG
                os_log(
                    "%{public}@",
                    log: log,
                    type: .debug,
                    packetBytesString
                )
                #endif
            }
        
        return Events(options: options) { events, timeStamp, source in
            let logString = generateLogString(
                events: events,
                timeStamp: timeStamp,
                source: source,
                options: options
            )
            stringLogHandler(logString)
        }
    }
    
    fileprivate static func generateLogString(
        events: [MIDIEvent],
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?,
        options: MIDIReceiverOptions
    ) -> String {
        var events = events
        
        if options.contains(.filterActiveSensingAndClock) {
            events = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
        }
        
        var stringOutput: String = events
            .map { "\($0)" }
            .joined(separator: ", ")
            + " timeStamp:\(timeStamp)"
        
        // not all packets will contain source refs
        if let source {
            stringOutput += " source:\(source.displayName.quoted)"
        }
        
        return stringOutput
    }
}

#endif
