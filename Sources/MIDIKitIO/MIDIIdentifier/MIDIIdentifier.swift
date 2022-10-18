//
//  MIDIIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

/// MIDIKit analogue for Core MIDI's `MIDIUniqueID`.
/// Most commonly used to uniquely identify MIDI endpoints in the system.
public typealias MIDIIdentifier = Int32

extension MIDIIdentifier {
    /// Constant analogous of Core MIDI's `kMIDIInvalidUniqueID` value.
    public static let invalidMIDIIdentifier: MIDIIdentifier = kMIDIInvalidUniqueID
}

// MARK: - Collection

extension Set where Element == MIDIIdentifier {
    /// Returns endpoint identity criteria formed from endpoints matching the collection's MIDI
    /// identifiers.
    public func asIdentities() -> Set<MIDIEndpointIdentity> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
    
        reduce(into: Set<MIDIEndpointIdentity>()) {
            $0.insert(.uniqueID($1))
        }
    }
}

extension Array where Element == MIDIIdentifier {
    /// Returns endpoint identity criteria formed from endpoints matching the collection's MIDI
    /// identifiers.
    @_disfavoredOverload
    public func asIdentities() -> [MIDIEndpointIdentity] {
        map { .uniqueID($0) }
    }
}

#endif
