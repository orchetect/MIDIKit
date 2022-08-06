//
//  OutputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - OutputEndpoint

extension MIDI.IO {
    /// A MIDI output endpoint in the system, wrapping a Core MIDI `MIDIEndpointRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
    public struct OutputEndpoint: _MIDIIOEndpointProtocol {
        public var objectType: MIDI.IO.ObjectType { .outputEndpoint }
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDI.IO.EndpointRef
        
        // MARK: Init
        
        internal init(_ ref: MIDI.IO.EndpointRef) {
            assert(
                ref != MIDI.IO.EndpointRef(),
                "Encountered Core MIDI output endpoint ref value of 0 which is invalid."
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

extension MIDI.IO.OutputEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "OutputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
    }
}

#endif
