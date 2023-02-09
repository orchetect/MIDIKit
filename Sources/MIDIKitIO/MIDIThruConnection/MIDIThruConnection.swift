//
//  MIDIThruConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// Apple Core MIDI play-through connection documentation:
// https://developer.apple.com/documentation/coremidi/midi_thru_connection
//
// Thru connections are observable in:
// ~/Library/Preferences/ByHost/com.apple.MIDI.<UUID>.plist
// but you can't manually modify the plist file.

// TODO: Core MIDI Thru Bug
// There is a bug in Core MIDI's Swift bridging whereby passing nil into MIDIThruConnectionCreate
// fails to create a non-persistent thru connection and actually creates a persistent thru
// connection, despite what the Core MIDI documentation states. Only macOS 11 and 12 seem affected.
// - GitHub issue: https://github.com/orchetect/MIDIKit/issues/164
// - Radar filed: https://openradar.appspot.com/radar?id=5043482339049472
// - Essentially, the net effect of passing .nonPersistent on those OS versions would create
//   a persistent thru connection with an owner of an empty string ("") so we are blocking that
//   from happening and throwing an error on those platforms.
// The resolution for the meantime is to keep a helper method in MIDIKitC which
// is an Objective-C target in the package. The library user must import this target and supply the
// Obj-C workaround method when creating thru connections on the MIDIManager.

// TODO: Core MIDI Thru Bug Not Flowing Events
// A new issue seems to be present on macOS Big Sur and later where thru connections do not flow any
// MIDI events.
// -
// https://stackoverflow.com/questions/54871326/how-is-a-coremidi-thru-connection-made-in-swift-4-2

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI
import MIDIKitCore

/// A managed MIDI thru connection created in the system by the MIDI I/O ``MIDIManager``.
///
/// Core MIDI play-through connections can be non-persistent (client-owned, auto-disposed when
/// ``MIDIManager`` de-initializes) or persistent (maintained even after system reboots).
///
/// > Warning:
/// > ⚠️ Non-persistent MIDI play-thru connections are affected by a Core MIDI bug on **macOS Big
/// > Sur and Monterey**. Attempting to create non-persistent thru connections on those OS
/// > versions will throw an error unless the `nonPersistentConnectionBlock` parameter is
/// > provided.
/// >
/// > 1. `import MIDIKitC`
/// > 2. Pass `using: CMIDIThruConnectionCreateNonPersistent` when calling
/// > ``MIDIManager/addThruConnection(outputs:inputs:tag:lifecycle:params:using:)``
///
/// > Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible
/// call it by accessing non-persistent thru connections using the
/// ``MIDIManager/managedThruConnections`` collection. The ``MIDIManager`` owns this object and
/// maintains non-persistent thru connections' lifecycle.
/// >
/// > Ensure that it is only stored weakly and only passed by reference temporarily in order to
/// execute an operation. If it absolutely must be stored strongly, ensure it is stored for no
/// longer than the lifecycle of the managed thru connection (which is either at such time the
/// ``MIDIManager`` is de-initialized, or when calling ``MIDIManager/remove(_:_:)`` with
/// ``MIDIManager/ManagedType/nonPersistentThruConnection`` or ``MIDIManager/removeAll()`` to
/// destroy the managed thru connection.)
public final class MIDIThruConnection: _MIDIManaged {
    // _MIDIManaged
    internal weak var midiManager: MIDIManager?
    
    // MIDIManaged
    public private(set) var api: CoreMIDIAPIVersion
    
    // class-specific
    
    public private(set) var coreMIDIThruConnectionRef: CoreMIDIThruConnectionRef?
    public private(set) var outputs: [MIDIOutputEndpoint]
    public private(set) var inputs: [MIDIInputEndpoint]
    public private(set) var lifecycle: Lifecycle
    public private(set) var parameters: Parameters
    private var nonPersistentConnectionBlock: (
        (CFData, UnsafeMutablePointer<CoreMIDIThruConnectionRef>) -> OSStatus
    )?
    
    // init
    
    /// Internal init.
    /// This object is not meant to be instanced by the user. This object is automatically created
    /// and managed by the MIDI I/O ``MIDIManager`` instance when calling
    /// ``MIDIManager/addThruConnection(outputs:inputs:tag:lifecycle:params:)``, and destroyed when
    /// calling ``MIDIManager/remove(_:_:)`` with
    /// ``MIDIManager/ManagedType/nonPersistentThruConnection`` or ``MIDIManager/removeAll()``.
    ///
    /// - Parameters:
    ///   - outputs: One or more output endpoints, maximum of 8.
    ///   - inputs: One or more input endpoints, maximum of 8.
    ///   - lifecycle: Non-persistent or persistent.
    ///   - params: Optionally supply custom parameters for the connection.
    ///   - midiManager: Reference to parent ``MIDIManager`` object.
    ///   - api: Core MIDI API version.
    ///   - nonPersistentConnectionBlock: Optional connection method as a workaround for the Core
    ///     MIDI bug. See
    ///     ``MIDIManager/addThruConnection(outputs:inputs:tag:lifecycle:params:using:)`` for more
    ///     info.
    internal init(
        outputs: [MIDIOutputEndpoint],
        inputs: [MIDIInputEndpoint],
        lifecycle: Lifecycle = .nonPersistent,
        params: Parameters = .init(),
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform(),
        using nonPersistentConnectionBlock: (
            (CFData, UnsafeMutablePointer<CoreMIDIThruConnectionRef>) -> OSStatus
        )?
    ) {
        // truncate arrays to 8 members or less;
        // Core MIDI thru connections can only have up to 8 outputs and 8 inputs
    
        self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
        self.nonPersistentConnectionBlock = nonPersistentConnectionBlock
        self.outputs = Array(outputs.prefix(8))
        self.inputs = Array(inputs.prefix(8))
        self.lifecycle = lifecycle
        self.midiManager = midiManager
        parameters = params
    }
    
    deinit {
        try? dispose()
    }
}

extension MIDIThruConnection {
    @objc
    internal func create(in manager: MIDIManager) throws {
        try MIDIThruConnection.verifyPlatformSupport(for: lifecycle)
        
        var newConnection = MIDIThruConnectionRef()
    
        let paramsData = parameters.coreMIDIThruConnectionParams(
            inputs: inputs,
            outputs: outputs
        )
        .cfData()
    
        // The underlying Objective-C method has this signature:
        // MIDIThruConnectionCreate(CFStringRef __nullable          inPersistentOwnerID,
        //                          CFDataRef                       inConnectionParams,
        //                          MIDIThruConnectionRef *         outConnection)
        //
        // inPersistentOwnerID:
        // -  NULL     == non-persistent, client-owned
        // -  non-NULL == persistent, stored in the system
        
        switch lifecycle {
        case .nonPersistent:
            // ⚠️ note that macOS Big Sur and Monterey are affected by a bug where
            // the Swift bridging of `MIDIThruConnectionCreate` is broken and
            // always creates persistent thru-connections even if nil is passed.
            
            // below are numerous fruitless experiments to find a pure Swift workaround.
            // the workaround can be done using Objective-C but it's not viable
            // if we want to keep MIDIKit pure Swift so it can work in Swift Playgrounds
            // on iPad etc.
            
            // this is the Obj-C workaround that would need to go in an Obj-C package target:
            // swiftformat:disable wrapSingleLineComments
            // OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams, MIDIThruConnectionRef *outConnection)
            // {
            //     return MIDIThruConnectionCreate(NULL, inConnectionParams, outConnection);
            // }
            // swiftformat:enable wrapSingleLineComments
            
            // MARK: Experiment 1
            
            // the idea was to attempt to recast the Obj-C method to force it to take
            // some form of C null that isn't a Swift nil,
            // however we can't access the actual Obj-C method and are still dealing with
            // the Swift bridging method which is likely where the bug exists
            
            // typealias MyMIDIThruConnectionCreate = @convention(block) (
            //     CFString?,
            //     CFData,
            //     UnsafeMutablePointer<MIDIThruConnectionRef>
            // ) -> OSStatus
            // let myCreate = unsafeBitCast(MIDIThruConnectionCreate,
            //     to: MyMIDIThruConnectionCreate.self)
            // try myCreate(nil, paramsData, &newConnection)
            // .throwIfOSStatusErr()
            
            // MARK: Experiment 2
            
            // same as above but different syntax
            
            // let myCreate = MIDIThruConnectionCreate as @convention(block) (
            //     CFString?,
            //     CFData,
            //     UnsafeMutablePointer<MIDIThruConnectionRef>
            // ) -> OSStatus
            // try myCreate(nil, paramsData, &newConnection)
            // .throwIfOSStatusErr()
            
            // MARK: Experiment 3
            
            // the idea was to attempt to force a CFNull into a CFString pointer, but
            // the method still thinks it's a CFString and throws an exception.
            // however we can't access the actual Obj-C method and are still dealing with
            // the Swift bridging method which is likely where the bug exists
            
            // var null = kCFNull
            // try withUnsafePointer(to: &null) { cfNullPtr in
            //    cfNullPtr.withMemoryRebound(to: CFString.self, capacity: 1) { cfStringPtr in
            //        MIDIThruConnectionCreate(
            //            cfStringPtr.pointee,
            //            paramsData,
            //            &newConnection
            //        )
            //    }
            // }
            // .throwIfOSStatusErr()
            
            // MARK: Experiment 4
            
            // can't import a target in the package unless it's set as a dependency in Package.swift
            // so this could never work while also keeping MIDIKit friendly to pure-Swift
            // development environments like Swift Playgrounds
            
            // #if canImport(MIDIKitC)
            //
            // try CMIDIThruConnectionCreateNonPersistent(paramsData, &newConnection)
            //     .throwIfOSStatusErr()
            //
            // #else
            
            // MARK: Official Method
            
            if let nonPersistentConnectionBlock = nonPersistentConnectionBlock {
                try nonPersistentConnectionBlock(
                    paramsData,
                    &newConnection
                )
                .throwIfOSStatusErr()
            } else {
                // this is the official way to create a non-persistent thru connection
                // however it always creates persistent connections on macOS 11 and 12
                // nil does not translate to C NULL so the connection is created persistently (bad).
                try MIDIThruConnectionCreate(
                    nil,
                    paramsData,
                    &newConnection
                )
                .throwIfOSStatusErr()
            }
            
        case .persistent(ownerID: let ownerID):
            let cfPersistentOwnerID = ownerID as CFString
            
            try MIDIThruConnectionCreate(
                cfPersistentOwnerID,
                paramsData,
                &newConnection
            )
            .throwIfOSStatusErr()
        }
        
        coreMIDIThruConnectionRef = newConnection
    }
    
    /// Disposes of the the thru connection if it's already been created in the system via the
    /// ``create(in:)`` method.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func dispose() throws {
        // don't dispose if it's a persistent connection
        guard lifecycle == .nonPersistent else { return }
    
        guard let unwrappedThruConnectionRef = coreMIDIThruConnectionRef else { return }
    
        defer {
            self.coreMIDIThruConnectionRef = nil
        }
    
        try MIDIThruConnectionDispose(unwrappedThruConnectionRef)
            .throwIfOSStatusErr()
    }
}

extension MIDIThruConnection: CustomStringConvertible {
    public var description: String {
        var thruConnectionRefString = "nil"
        if let unwrappedThruConnectionRef = coreMIDIThruConnectionRef {
            thruConnectionRefString = "\(unwrappedThruConnectionRef)"
        }
    
        return "MIDIThruConnection(ref: \(thruConnectionRefString), outputs: \(outputs), inputs: \(inputs), \(lifecycle)"
    }
}

#endif
