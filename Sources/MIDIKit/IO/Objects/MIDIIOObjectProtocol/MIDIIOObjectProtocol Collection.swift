//
//  MIDIIOObjectProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the array sorted alphabetically by name.
    public func sortedByName() -> [Element] {
        
        self.sorted(by: {
            $0.name
                .localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
        
    }
    
}

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the element where uniqueID matches if found.
    public func filterBy(uniqueID: Element.UniqueID) -> Element? {
        
        first(where: { $0.uniqueID == uniqueID })
        
    }
    
    /// Returns all elements matching the given name.
    public func filterBy(name: String) -> [Element] {
        
        filter { $0.name == name }
        
    }
    
    /// Returns all elements matching all supplied parameters.
    public func filterBy(displayName: String) -> [Element] {
        
        filter { $0.getDisplayName == displayName }
        
    }
    
}
