//
//  AnyMIDIEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension Set where Element == AnyMIDIEndpoint {
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDIEndpointIDCriteria> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDIEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
    }
}

extension Array where Element == AnyMIDIEndpoint {
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDIEndpointIDCriteria] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
