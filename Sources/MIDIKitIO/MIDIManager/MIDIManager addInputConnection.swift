//
//  MIDIManager addInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDIManager {
    /// Adds a new managed input connection to the ``MIDIManager/managedInputConnections``
    /// dictionary of the ``MIDIManager``.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI
    /// events. It can also be instanced without providing any initial inputs and then inputs can be
    /// added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying target MIDI endpoint(s). These may be added or
    /// removed later.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - mode: Operation mode. Note that ``MIDIConnectionMode/allEndpoints`` mode overrides any
    /// criteria supplied in `toOutputs`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    /// the connection.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///
    /// - Throws: ``MIDIIOError``
    public func addInputConnection(
        toOutputs: Set<MIDIEndpointIdentity>,
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        try eventQueue.sync {
            let newCD = MIDIInputConnection(
                criteria: toOutputs,
                mode: mode,
                filter: filter,
                receiver: receiver,
                midiManager: self,
                api: preferredAPI
            )
    
            // store the connection object in the manager,
            // even if subsequent connection fails
            managedInputConnections[tag] = newCD
    
            try newCD.listen(in: self)
            try newCD.connect(in: self)
        }
    }
    
    /// Adds a new managed input connection to the ``MIDIManager/managedInputConnections``
    /// dictionary of the ``MIDIManager``.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI
    /// events. It can also be instanced without providing any initial inputs and then inputs can be
    /// added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying target MIDI endpoint(s). These may be added or
    /// removed later.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - mode: Operation mode. Note that ``MIDIConnectionMode/allEndpoints`` mode overrides any
    /// criteria supplied in `toOutputs`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    /// the connection.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///
    /// - Throws: ``MIDIIOError``
    public func addInputConnection(
        toOutputs: [MIDIEndpointIdentity],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        try addInputConnection(
            toOutputs: Set(toOutputs),
            tag: tag,
            mode: mode,
            filter: filter,
            receiver: receiver
        )
    }
    
    /// Adds a new managed input connection to the ``MIDIManager/managedInputConnections``
    /// dictionary of the ``MIDIManager``.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI
    /// events. It can also be instanced without providing any initial inputs and then inputs can be
    /// added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - mode: Operation mode. Note that ``MIDIConnectionMode/allEndpoints`` mode overrides any
    /// criteria supplied in `toOutputs`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    /// the connection.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///
    /// - Throws: ``MIDIIOError``
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDIOutputEndpoint],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        try addInputConnection(
            toOutputs: toOutputs.asIdentities(),
            tag: tag,
            mode: mode,
            filter: filter,
            receiver: receiver
        )
    }
}

#endif
