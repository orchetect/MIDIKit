//
//  MIDIKit-0.9.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// Symbols that were renamed or removed.

@available(
    *,
    deprecated,
    message: "Please use MIDIInputConnectionMode or MIDIOutputConnectionMode."
)
public enum MIDIConnectionMode: Equatable, Hashable {
    case definedEndpoints
    case allEndpoints
}

// MARK: MIDIManager addInputConnection

extension MIDIManager {
    @available(
        *,
        deprecated,
        renamed: "addInputConnection(to:tag:filter:receiver:)",
        message: "`toOutputs:` has been renamed `to:` which now accepts `.outputs(matching:)`. `mode:` has been removed in favor of using `to: .allOutputs`."
    )
    public func addInputConnection(
        toOutputs: Set<MIDIEndpointIdentity>,
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addInputConnection(
                to: .outputs(matching: toOutputs),
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        case .allEndpoints:
            try addInputConnection(
                to: .allOutputs,
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        }
    }
    
    @available(
        *,
        deprecated,
        renamed: "addInputConnection(to:tag:filter:receiver:)",
        message: "`toOutputs:` has been renamed `to:` which now accepts `.outputs(matching:)`. `mode:` has been removed in favor of using `to: .allOutputs`."
    )
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDIEndpointIdentity],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addInputConnection(
                to: .outputs(matching: toOutputs),
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        case .allEndpoints:
            try addInputConnection(
                to: .allOutputs,
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        }
    }
    
    @available(
        *,
        deprecated,
        renamed: "addInputConnection(to:tag:filter:receiver:)",
        message: "`toOutputs:` has been renamed `to:` which now accepts `.outputs(matching:)`. `mode:` has been removed in favor of using `to: .allOutputs`."
    )
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDIOutputEndpoint],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addInputConnection(
                to: .outputs(toOutputs),
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        case .allEndpoints:
            try addInputConnection(
                to: .allOutputs,
                tag: tag,
                filter: filter,
                receiver: receiver
            )
        }
    }
}

// MARK: MIDIManager addOutputConnection

extension MIDIManager {
    @available(
        *,
        deprecated,
        renamed: "addOutputConnection(to:tag:filter:)",
        message: "`toInputs:` has been renamed `to:` which now accepts `.inputs(matching:)`. `mode:` has been removed in favor of using `to: .allInputs`."
    )
    public func addOutputConnection(
        toInputs: Set<MIDIEndpointIdentity>,
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addOutputConnection(
                to: .inputs(matching: toInputs),
                tag: tag,
                filter: filter
            )
        case .allEndpoints:
            try addOutputConnection(
                to: .allInputs,
                tag: tag,
                filter: filter
            )
        }
    }
    
    @available(
        *,
        deprecated,
        renamed: "addOutputConnection(to:tag:filter:)",
        message: "`toInputs:` has been renamed `to:` which now accepts `.inputs(matching:)`. `mode:` has been removed in favor of using `to: .allInputs`."
    )
    @_disfavoredOverload
    public func addOutputConnection(
        toInputs: [MIDIEndpointIdentity],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addOutputConnection(
                to: .inputs(matching: toInputs),
                tag: tag,
                filter: filter
            )
        case .allEndpoints:
            try addOutputConnection(
                to: .allInputs,
                tag: tag,
                filter: filter
            )
        }
    }
    
    @available(
        *,
        deprecated,
        renamed: "addOutputConnection(to:tag:filter:)",
        message: "`toInputs:` has been renamed `to:` which now accepts `.inputs(matching:)`. `mode:` has been removed in favor of using `to: .allInputs`."
    )
    @_disfavoredOverload
    public func addOutputConnection(
        toInputs: [MIDIInputEndpoint],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        switch mode {
        case .definedEndpoints:
            try addOutputConnection(
                to: .inputs(toInputs),
                tag: tag,
                filter: filter
            )
        case .allEndpoints:
            try addOutputConnection(
                to: .allInputs,
                tag: tag,
                filter: filter
            )
        }
    }
}

#endif
