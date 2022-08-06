//
//  InputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - InputEndpoint

extension MIDI.IO {
    /// A MIDI input endpoint in the system, wrapping a Core MIDI `MIDIEndpointRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
    public struct InputEndpoint: _MIDIIOEndpointProtocol {
        public var objectType: MIDI.IO.ObjectType { .inputEndpoint }
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDI.IO.EndpointRef
        
        // MARK: Init
        
        internal init(_ ref: MIDI.IO.EndpointRef) {
            assert(
                ref != MIDI.IO.EndpointRef(),
                "Encountered Core MIDI input endpoint ref value of 0 which is invalid."
            )
            
            coreMIDIObjectRef = ref
            update()
        }
        
        // MARK: - Properties (Cached)
        
        public internal(set) var name: String = ""
        
        public internal(set) var displayName: String = ""
        
        public internal(set) var uniqueID: UniqueID = 0
        
        /// Update the cached properties
        internal mutating func update() {
            name = getName() ?? ""
            displayName = getDisplayName() ?? ""
            uniqueID = getUniqueID()
        }
    }
}

extension MIDI.IO.InputEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "InputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
    }
}

#endif
