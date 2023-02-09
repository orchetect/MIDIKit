//
//  MIDIManager addThruConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDIManager {
    /// Creates a new MIDI play-through (thru) connection.
    ///
    /// If the connection is non-persistent, a managed thru connection will be added to
    /// ``MIDIManager/managedThruConnections`` and its lifecycle will be that of the ``MIDIManager``
    /// or until ``MIDIManager/remove(_:_:)`` is called for the connection.
    ///
    /// If the connection is persistent, it is instead stored persistently by the system and
    /// references will not be directly held in the ``MIDIManager``. To access persistent
    /// connections, ``MIDIManager/unmanagedPersistentThruConnections(ownerID:)`` will retrieve a
    /// list of connections from the system, if any match the owner ID passed as argument.
    ///
    /// For every persistent thru connection your app creates, they should be assigned the same
    /// persistent ID (reverse-DNS domain) so they can be managed or removed in future.
    ///
    /// - Note: Max 8 outputs and max 8 inputs are allowed when forming a thru connection.
    ///
    /// - Warning: Be careful when creating persistent thru connections, as they can become stale
    /// and orphaned if the endpoints used to create them cease to be relevant at any point in time.
    ///
    /// > Warning:
    /// > ⚠️ Non-persistent MIDI play-thru connections are affected by a Core MIDI bug on **macOS Big
    /// > Sur and Monterey**. Attempting to create non-persistent thru connections on those OS
    /// > versions will throw an error unless the `nonPersistentConnectionBlock` parameter is
    /// > provided.
    /// >
    /// > 1. `import MIDIKitC`
    /// > 2. Pass `using: CMIDIThruConnectionCreateNonPersistent` to this method.
    ///
    /// - Parameters:
    ///   - outputs: Maximum of 8 ``MIDIOutputEndpoint``.
    ///   - inputs: Maximum of 8 ``MIDIInputEndpoint``.
    ///   - tag: Unique `String` key to refer to the new object that gets added to
    /// ``MIDIManager/managedThruConnections`` dictionary.
    ///   - lifecycle: If ``MIDIThruConnection/Lifecycle-swift.enum/nonPersistent``, thru connection
    ///   will expire when the app terminates. If
    /// ``MIDIThruConnection/Lifecycle-swift.enum/persistent(ownerID:)``, the connection persists in
    ///   the system indefinitely (even after system reboots) until explicitly removed.
    ///   - params: Optionally define custom ``MIDIThruConnection/Parameters-swift.struct``.
    ///   - connectionBlock: This may be `nil` unless creating a non-persistent thru connection
    ///   on macOS Big Sur or Monterey. In that case, passing `nil` will result in an error due to a
    ///   Core MIDI bug that prevents creating non-persistent connections through Swift. In this
    ///   case, `import MIDIKitC` and pass `CMIDIThruConnectionCreateNonPersistent` as the value for
    ///   this parameter.
    ///
    /// - Throws: ``MIDIIOError``
    public func addThruConnection(
        outputs: [MIDIOutputEndpoint],
        inputs: [MIDIInputEndpoint],
        tag: String,
        lifecycle: MIDIThruConnection.Lifecycle = .nonPersistent,
        params: MIDIThruConnection.Parameters = .init(),
        using nonPersistentConnectionBlock: (
            (CFData, UnsafeMutablePointer<CoreMIDIThruConnectionRef>) -> OSStatus
        )? = nil
    ) throws {
        if nonPersistentConnectionBlock == nil {
            try MIDIThruConnection.verifyPlatformSupport(for: lifecycle)
        }
        
        try eventQueue.sync {
            let newCT = MIDIThruConnection(
                outputs: outputs,
                inputs: inputs,
                lifecycle: lifecycle,
                params: params,
                midiManager: self,
                api: preferredAPI,
                using: nonPersistentConnectionBlock
            )
    
            // if non-persistent, add to managed array
            if lifecycle == .nonPersistent {
                // store the connection object in the manager,
                // even if subsequent connection fails
                managedThruConnections[tag] = newCT
            }
    
            // otherwise, we won't store a reference to a persistent thru connection
            // persistent connections are stored by the system
            // to analyze or delete a persistent connection,
            // access the `unmanagedPersistentThruConnections(ownerID:)` method.
    
            try newCT.create(in: self)
        }
    }
}

#endif
