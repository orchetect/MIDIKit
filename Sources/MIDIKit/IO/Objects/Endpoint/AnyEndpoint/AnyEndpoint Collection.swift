//
//  AnyEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension Set where Element == MIDI.IO.AnyEndpoint {
    
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDI.IO.EndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.EndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.AnyEndpoint {
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.EndpointIDCriteria] {
        
        map { .uniqueID($0.uniqueID) }
        
    }
    
}

#endif
