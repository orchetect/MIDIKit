//
//  MIDIReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Defines the parameters for a MIDI receiver.
public enum MIDIReceiver {
    /// One or more receivers in series.
    case group([MIDIReceiver])
        
    /// Provides a closure to handle strongly-typed MIDI events. (Recommended)
    case events(
        translateMIDI1NoteOnZeroVelocityToNoteOff: Bool = true,
        EventsHandler
    )
        
    /// Provides a convenience to automatically log MIDI events to the console. (Only logs events in `DEBUG` preprocessor flag builds.)
    case eventsLogging(
        filterActiveSensingAndClock: Bool = false,
        _ handler: EventsLoggingHandler? = nil
    )
        
    /// Basic raw packet data receive handler.
    /// This handler is provided for debugging and data introspection but is discouraged for manually parsing MIDI packets.
    /// It is recommended to use a MIDI event handler instead.
    case rawData(RawDataHandler)
        
    /// Raw data logging handler (hex byte strings).
    ///
    /// If `handler` is `nil`, all raw packet data is logged to the console (but only in `DEBUG` preprocessor flag builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not automatically logged.
    case rawDataLogging(
        filterActiveSensingAndClock: Bool = false,
        _ handler: RawDataLoggingHandler? = nil
    )
    
    /// Pass to a receiver object instance.
    /// MIDI Event receive handler that holds a reference to a receiver object that conforms to the `ReceivesMIDIEvents` protocol.
    /// The object reference may be held strongly or weakly.
    case receiver(
        ReceivesMIDIEvents,
        held: ReceiverRefStorage,
        translateMIDI1NoteOnZeroVelocityToNoteOff: Bool = true
    )
}

extension MIDIReceiver {
    /// Class instance storage semantics.
    public enum ReceiverRefStorage {
        case weakly
        case strongly
    }
}

extension MIDIReceiver {
    /// Internal:
    /// Creates a concrete receive handler class instance from the definition parameters.
    internal func createReceiveHandler() -> MIDIReceiveHandler {
        switch self {
        case let .group(definitions):
            let handlers = definitions.map { $0.createReceiveHandler() }
            return .init(MIDIReceiveHandler.Group(handlers))
            
        case let .events(
            translateMIDI1NoteOnZeroVelocityToNoteOff,
            handler
        ):
            return .init(
                MIDIReceiveHandler.Events(
                    translateMIDI1NoteOnZeroVelocityToNoteOff: translateMIDI1NoteOnZeroVelocityToNoteOff,
                    handler
                )
            )
            
        case let .eventsLogging(
            filterActiveSensingAndClock,
            handler
        ):
            return .init(
                MIDIReceiveHandler.EventsLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
            
        case let .rawData(handler):
            return .init(MIDIReceiveHandler.RawData(handler))
            
        case let .rawDataLogging(filterActiveSensingAndClock, handler):
            return .init(
                MIDIReceiveHandler.RawDataLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
            
        case let .receiver(
            object,
            storageType,
            translateMIDI1NoteOnZeroVelocityToNoteOff
        ):
            switch storageType{
            case .strongly:
                return .init(
                    MIDIReceiveHandler.StrongEventsReceiver(
                        translateMIDI1NoteOnZeroVelocityToNoteOff: translateMIDI1NoteOnZeroVelocityToNoteOff,
                        receiver: object
                    )
                )
            case .weakly:
                return .init(
                    MIDIReceiveHandler.WeakEventsReceiver(
                        translateMIDI1NoteOnZeroVelocityToNoteOff: translateMIDI1NoteOnZeroVelocityToNoteOff,
                        receiver: object
                    )
                )
            }
        }
    }
}

#endif
