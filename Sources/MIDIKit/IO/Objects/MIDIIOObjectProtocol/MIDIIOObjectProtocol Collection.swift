//
//  MIDIIOObjectProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the array sorted alphabetically by MIDI object name.
    public func sortedByName() -> [Element] {
        
        self.sorted(by: {
            $0.name
                .localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
        
    }
    
}

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the element where uniqueID matches if found.
    public func first(whereUniqueID: Element.UniqueID) -> Element? {
        
        first(where: { $0.uniqueID.isEqual(to: whereUniqueID) })
        
    }
    
    /// Returns all elements matching the given name.
    public func filter(name: String) -> [Element] {
        
        filter { $0.name == name }
        
    }
    
}

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns all elements matching all supplied parameters.
    public func filter(displayName: String) -> [Element] {
        
        filter { $0.getDisplayName() == displayName }
        
    }
    
}
