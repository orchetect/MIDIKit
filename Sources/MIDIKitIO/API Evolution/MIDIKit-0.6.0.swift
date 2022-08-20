//
//  MIDIKit-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore

// Symbols that were renamed or removed.

// NOTE: This is not by any means exhaustive, as nearly every symbol had namespace changes from 0.5.x -> 0.6.0 but the most common symbols are covered here to help guide code migration.

extension MIDI {
    @available(
        *, unavailable,
         message: "The `MIDI.IO` namespace has been removed and first-generation nested types have been renamed `MIDIManager`, `MIDIInputEndpoint`, etc."
    )
    public enum IO {
        // MARK: Core MIDI Aliased Types
        
        public typealias UniqueID = MIDIIdentifier
        public typealias ObjectRef = UInt32
        public typealias ClientRef = CoreMIDIObjectRef
        public typealias DeviceRef = CoreMIDIObjectRef
        public typealias EntityRef = CoreMIDIObjectRef
        public typealias PortRef = CoreMIDIObjectRef
        public typealias EndpointRef = CoreMIDIObjectRef
        public typealias ThruConnectionRef = CoreMIDIObjectRef
        public typealias TimeStamp = UInt64
        public typealias CoreMIDIOSStatus = Int32
        
        // MARK: Manager
        
        public class Manager {
            @available(*, unavailable)
            public init(
                clientName: String,
                model: String,
                manufacturer: String,
                notificationHandler: ((
                    _ notification: MIDIIONotification,
                    _ manager: MIDIManager
                ) -> Void)? = nil
            ) { fatalError() }
            
            public func addInput(
                name: String,
                tag: String,
                uniqueID: MIDIIdentifierPersistence,
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            // MARK: - Add Methods
            
            public func addInputConnection(
                toOutputs: Set<MIDIEndpointIdentity>,
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            public func addInputConnection(
                toOutputs: [MIDIEndpointIdentity],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            @_disfavoredOverload
            public func addInputConnection(
                toOutputs: [MIDIOutputEndpoint],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            public func addOutput(
                name: String,
                tag: String,
                uniqueID: MIDIIdentifierPersistence
            ) throws { fatalError() }
            
            public func addOutputConnection(
                toInputs: Set<MIDIEndpointIdentity>,
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            public func addOutputConnection(
                toInputs: [MIDIEndpointIdentity],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            @_disfavoredOverload
            public func addOutputConnection(
                toInputs: [MIDIInputEndpoint],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            public func addThruConnection(
                outputs: [MIDIOutputEndpoint],
                inputs: [MIDIInputEndpoint],
                tag: String,
                lifecycle: MIDIThruConnection.Lifecycle = .nonPersistent,
                params: MIDIThruConnection.Parameters = .init()
            ) throws { fatalError() }
            
            // MARK: - Remove Methods
            
            public func remove(
                _ type: MIDIManager.ManagedType,
                _ tagSelection: MIDIManager.TagSelection
            ) { fatalError() }
            
            // MARK: State
            
            public func start() throws { fatalError() }
        }
        
        // MARK: Network Session
        
        @available(
            *, unavailable,
             message: "setMIDINetworkSession() is now a top-level global method."
        )
        public static func setMIDINetworkSession(policy: MIDIIONetworkConnectionPolicy?) {
            fatalError()
        }
        
        // MARK: UniqueIDPersistence -> MIDIIdentifierPersistence
        
        @available(*, unavailable, message: "Renamed to MIDIIdentifierPersistence")
        public enum UniqueIDPersistence {
            case none
            case preferred(MIDIIdentifier)
            case userDefaultsManaged(key: String)
            case manualStorage(
                readHandler: () -> MIDIIdentifier?,
                storeHandler: (MIDIIdentifier?) -> Void
            )
        }
    }
}

// MARK: MIDIUniqueID -> MIDIIdentifier

extension Set where Element == MIDIIdentifier {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> Set<MIDIEndpointIdentity> { fatalError() }
}

extension Array where Element == MIDIIdentifier {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> [MIDIEndpointIdentity] { fatalError() }
}

// MARK: UniqueIDPersistence -> MIDIIdentifierPersistence

extension MIDIIdentifierPersistence {
    @available(*, unavailable, renamed: "adHoc")
    @_disfavoredOverload
    public static let none: Self = { fatalError() }()
    
    @available(*, unavailable, renamed: "unmanaged")
    @_disfavoredOverload
    public static func preferred(_: MIDIIdentifier) -> Self { fatalError() }
    
    // case userDefaultsManaged was not renamed
    
    @available(*, unavailable, renamed: "managedStorage")
    @_disfavoredOverload
    public static func manualStorage(
        readHandler: () -> MIDIIdentifier?,
        storeHandler: (MIDIIdentifier?) -> Void
    ) -> Self { fatalError() }
}

#endif
