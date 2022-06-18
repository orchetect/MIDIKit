//
//  ThruConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// Apple Core MIDI play-through connection documentation:
// https://developer.apple.com/documentation/coremidi/midi_thru_connection
//
// Thru connections are observable in:
// ~/Library/Preferences/ByHost/com.apple.MIDI.<UUID>.plist
// but you can't manually modify the plist file.

// TODO: Core MIDI Thru Bug
// There is a bug in Core MIDI's Swift bridging whereby passing nil into MIDIThruConnectionCreate fails to create a non-persistent thru connection and actually creates a persistent thru connection, despite what the Core MIDI documentation states.
// - Radar filed: https://openradar.appspot.com/radar?id=5043482339049472
// - So having passed .nonPersistent has the effect of creating a persistent
//   connection with an empty ownerID.

// TODO: Core MIDI Thru Bug
// A new issue seems to be present on macOS Big Sur and later where thru connections do not flow any MIDI events.
// - https://stackoverflow.com/questions/54871326/how-is-a-coremidi-thru-connection-made-in-swift-4-2

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI thru connection created in the system by the MIDI I/O `Manager`.
    ///
    /// ⚠️ **Note** ⚠️
    /// - MIDI play-thru connections only function on **macOS Catalina or earlier** due to Core MIDI bugs on later macOS releases. Attempting to create thru connections on macOS Big Sur or later will throw an error.
    ///
    /// Core MIDI play-through connections can be non-persistent (client-owned, auto-disposed when `Manager` de-initializes) or persistent (maintained even after system reboots).
    ///
    /// - Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible call it by accessing non-persistent thru connections using the `Manager`'s `managedThruConnections` collection.
    ///
    /// Ensure that it is only stored weakly and only passed by reference temporarily in order to execute an operation. If it absolutely must be stored strongly, ensure it is stored for no longer than the lifecycle of the managed thru connection (which is either at such time the `Manager` is de-initialized, or when calling `.remove(.nonPersistentThruConnection, ...)` or `.removeAll` on the `Manager` to destroy the managed thru connection.)
    public class ThruConnection: _MIDIIOManagedProtocol {
        
        // _MIDIIOManagedProtocol
        internal weak var midiManager: MIDI.IO.Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: MIDI.IO.APIVersion
        
        // class-specific
        
        public private(set) var coreMIDIThruConnectionRef: MIDI.IO.CoreMIDIThruConnectionRef? = nil
        public private(set) var outputs: [OutputEndpoint]
        public private(set) var inputs: [InputEndpoint]
        public private(set) var lifecycle: Lifecycle
        public private(set) var parameters: Parameters
        
        // init
        
        /// Internal init.
        /// This object is not meant to be instanced by the user. This object is automatically created and managed by the MIDI I/O `Manager` instance when calling `.addThruConnection()`, and destroyed when calling `.remove(.nonPersistentThruConnection, ...)` or `.removeAll()`.
        ///
        /// - Parameters:
        ///   - outputs: One or more output endpoints, maximum of 8.
        ///   - inputs: One or more input endpoints, maximum of 8.
        ///   - lifecycle: Non-persistent or persistent.
        ///   - params: Optionally supply custom parameters for the connection.
        ///   - midiManager: Reference to I/O Manager object.
        ///   - api: Core MIDI API version.
        internal init(outputs: [OutputEndpoint],
                      inputs: [InputEndpoint],
                      lifecycle: Lifecycle = .nonPersistent,
                      params: Parameters = .init(),
                      midiManager: MIDI.IO.Manager,
                      api: MIDI.IO.APIVersion = .bestForPlatform()) {
            
            // truncate arrays to 8 members or less;
            // Core MIDI thru connections can only have up to 8 outputs and 8 inputs
            
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            self.outputs = Array(outputs.prefix(8))
            self.inputs = Array(inputs.prefix(8))
            self.lifecycle = lifecycle
            self.midiManager = midiManager
            self.parameters = params
            
        }
        
        deinit {
            
            try? dispose()
            
        }
        
    }
    
}

extension MIDI.IO.ThruConnection {
    
    internal func create(in manager: MIDI.IO.Manager) throws {
        
        var newConnection = MIDIThruConnectionRef()
        
        let paramsData = parameters.coreMIDIThruConnectionParams(
            inputs: inputs,
            outputs: outputs
        )
        .cfData()
        
        // nil == non-persistent, client-owned
        // non-nil == persistent, stored in the system
        var cfPersistentOwnerID: CFString? = nil
        
        if case .persistent(ownerID: let ownerID) = lifecycle {
            cfPersistentOwnerID = ownerID as CFString
        }
        
        try MIDIThruConnectionCreate(
            cfPersistentOwnerID,
            paramsData,
            &newConnection
        )
        .throwIfOSStatusErr()
        
        coreMIDIThruConnectionRef = newConnection
        
    }
    
    /// Disposes of the the thru connection if it's already been created in the system via the `create()` method.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func dispose() throws {
        
        // don't dispose if it's a persistent connection
        guard lifecycle == .nonPersistent else { return }
        
        guard let unwrappedThruConnectionRef = self.coreMIDIThruConnectionRef else { return }
        
        defer {
            self.coreMIDIThruConnectionRef = nil
        }
        
        try MIDIThruConnectionDispose(unwrappedThruConnectionRef)
            .throwIfOSStatusErr()
        
    }
    
}

extension MIDI.IO.ThruConnection: CustomStringConvertible {
    
    public var description: String {
        
        var thruConnectionRefString: String = "nil"
        if let unwrappedThruConnectionRef = coreMIDIThruConnectionRef {
            thruConnectionRefString = "\(unwrappedThruConnectionRef)"
        }
        
        return "ThruConnection(ref: \(thruConnectionRefString), outputs: \(outputs), inputs: \(inputs), \(lifecycle)"
        
    }
    
}
