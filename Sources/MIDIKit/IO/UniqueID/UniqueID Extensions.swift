//
//  UniqueID Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Collection

extension Set where Element == MIDI.IO.UniqueID {
    
    public func asCriteria() -> Set<MIDI.IO.EndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.EndpointIDCriteria>()) {
            $0.insert(.uniqueID($1))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.UniqueID {
    
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.EndpointIDCriteria] {
        
        map { .uniqueID($0) }
        
    }
    
}

#endif
