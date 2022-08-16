//
//  AnyMIDIEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension Set where Element == AnyMIDIEndpoint {
    /// Returns endpoint identity criteria describing the endpoints.
    public func asIdentities() -> Set<MIDIEndpointIdentity> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
    
        reduce(into: Set<MIDIEndpointIdentity>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
    }
}

extension Array where Element == AnyMIDIEndpoint {
    /// Returns endpoint identity criteria describing the endpoints.
    @_disfavoredOverload
    public func asIdentities() -> [MIDIEndpointIdentity] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
