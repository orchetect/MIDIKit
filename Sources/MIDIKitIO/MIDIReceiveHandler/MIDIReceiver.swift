//
//  MIDIReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Defines the parameters for a MIDI receiver.
public enum MIDIReceiver {
    /// One or more receivers in series.
    case group([MIDIReceiver])
    
    /// Provides a closure to handle strongly-typed MIDI events including packet timestamp and
    /// source endpoint metadata. (Recommended)
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    case events(
        options: MIDIReceiverOptions = [],
        _ handler: EventsHandler
    )
    
    /// Provides a convenience to automatically log MIDI events to the console.
    /// (Only logs events in `DEBUG` preprocessor flag builds.)
    case eventsLogging(
        options: MIDIReceiverOptions = [],
        _ handler: EventsLoggingHandler? = nil
    )
    
    /// Raw packet data receive handler.
    /// This handler is provided for debugging and data introspection but is discouraged for
    /// manually parsing MIDI packets.
    /// It is recommended to use a MIDI event handler instead.
    case rawData(
        _ handler: RawDataHandler
    )
    
    /// Raw data logging handler (hex byte strings).
    /// On systems that use legacy MIDI 1.0 packets, their raw bytes will be logged.
    /// On systems that support UMP and MIDI 2.0, the raw UMP packet data is logged.
    ///
    /// If `handler` is `nil`, all raw packet data is logged to the console (but only in `DEBUG`
    /// preprocessor flag builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not
    /// automatically logged.
    case rawDataLogging(
        _ handler: RawDataLoggingHandler? = nil
    )
    
    /// Pass to a receiver object instance.
    /// MIDI Event receive handler that holds a reference to a receiver object that conforms to the
    /// ``ReceivesMIDIEvents`` protocol.
    /// The object reference may be held strongly or weakly.
    case object(
        _ object: ReceivesMIDIEvents,
        held: ReceiverRefStorage,
        options: MIDIReceiverOptions = []
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
    /// Creates a concrete receive handler class instance from the definition parameters.
    ///
    /// This is only useful for custom implementations. Do not call this method when supplying a
    /// ``MIDIReceiver`` to the ``MIDIManager``.
    public func create() -> MIDIReceiverProtocol {
        switch self {
        case let .group(definitions):
            let handlers = definitions.map { $0.create() }
            return Group(handlers)
            
        case let .events(options, handler):
            return Events(options: options, handler: handler)
            
        case let .eventsLogging(options, handler):
            return Self._eventsLogging(options: options, handler: handler)
            
        case let .rawData(handler):
            return RawData(handler: handler)
            
        case let .rawDataLogging(handler):
            return Self._rawDataLogging(handler: handler)
            
        case let .object(object, storageType, options):
            switch storageType {
            case .strongly:
                return StrongEventsReceiver(options: options, receiver: object)
                
            case .weakly:
                return WeakEventsReceiver(options: options, receiver: object)
            }
        }
    }
}

#endif
