//
//  MIDIIdentifier Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Collection

extension Set where Element == MIDIIdentifier {
    public func asCriteria() -> Set<MIDIEndpointIDCriteria> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDIEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1))
        }
    }
}

extension Array where Element == MIDIIdentifier {
    @_disfavoredOverload
    public func asCriteria() -> [MIDIEndpointIDCriteria] {
        map { .uniqueID($0) }
    }
}

#endif
