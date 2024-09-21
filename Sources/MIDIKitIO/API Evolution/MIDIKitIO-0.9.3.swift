//
//  MIDIKitIO-0.9.3.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDIReceiver {
    @available(
        *,
        deprecated,
        renamed: "events(options:_:)",
        message: "`translateMIDI1NoteOnZeroVelocityToNoteOff` property is now an OptionSet set flag."
    )
    @_disfavoredOverload
    public static func events(
        translateMIDI1NoteOnZeroVelocityToNoteOff: Bool,
        _ handler: @escaping EventsHandler
    ) -> Self {
        .events(
            options: translateMIDI1NoteOnZeroVelocityToNoteOff ? [.translateMIDI1NoteOnZeroVelocityToNoteOff] : [],
            handler
        )
    }
    
    @available(
        *,
        deprecated,
        renamed: "events(options:_:)",
        message: "`translateMIDI1NoteOnZeroVelocityToNoteOff` property is now an OptionSet flag."
    )
    @_disfavoredOverload
    public static func eventsWithMetadata(
        translateMIDI1NoteOnZeroVelocityToNoteOff: Bool,
        _ handler: @escaping EventsHandler
    ) -> Self {
        .events(
            options: translateMIDI1NoteOnZeroVelocityToNoteOff ? [.translateMIDI1NoteOnZeroVelocityToNoteOff] : [],
            handler
        )
    }
    
    @available(
        *,
        deprecated,
        renamed: "eventsLogging(options:_:)",
        message: "`filterActiveSensingAndClock` property is now an OptionSet flag."
    )
    @_disfavoredOverload
    public static func eventsLogging(
        filterActiveSensingAndClock: Bool,
        _ handler: EventsLoggingHandler? = nil
    ) -> Self {
        .eventsLogging(
            options: filterActiveSensingAndClock ? [.filterActiveSensingAndClock] : [],
            handler
        )
    }
    
    @available(
        *,
        deprecated,
        renamed: "rawDataLogging(_:)",
        message: "`filterActiveSensingAndClock` has been removed from rawDataLogging."
    )
    @_disfavoredOverload
    public static func rawDataLogging(
        filterActiveSensingAndClock: Bool,
        _ handler: RawDataLoggingHandler? = nil
    ) -> Self {
        .rawDataLogging(handler)
    }
    
    @available(
        *,
         deprecated,
         renamed: "object(_:held:options:)",
         message: "`translateMIDI1NoteOnZeroVelocityToNoteOff` property is now an OptionSet flag. `object(_:held:translateMIDI1NoteOnZeroVelocityToNoteOff:)` is also now replaced by `strong(_:options:)` or `weak(_:options:)` and as such, no longer carries a `held` property."
    )
    @_disfavoredOverload
    public static func object(
        _ object: ReceivesMIDIEvents,
        held: ReceiverRefStorage,
        translateMIDI1NoteOnZeroVelocityToNoteOff: Bool
    ) -> Self {
        .object(
            object,
            held: held,
            options: translateMIDI1NoteOnZeroVelocityToNoteOff ? [.translateMIDI1NoteOnZeroVelocityToNoteOff] : []
        )
    }
}

#endif
