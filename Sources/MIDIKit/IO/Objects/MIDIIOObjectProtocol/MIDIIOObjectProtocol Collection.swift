//
//  MIDIIOObjectProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - sorted

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the array sorted alphabetically by MIDI object name.
    public func sortedByName() -> [Element] {
        
        self.sorted(by: {
            $0.name
                .localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
        
    }
    
}

// MARK: - first

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns the first element matching the given name.
    public func first(withName name: String,
                      ignoringEmpty: Bool = false) -> Element? {
        
        ignoringEmpty
            ? first(where: { $0.name == name && !$0.name.isEmpty })
            : first(where: { $0.name == name })
        
    }
        
    /// Returns the element with matching unique ID.
    public func first(whereUniqueID: Element.UniqueID) -> Element? {
        
        first(where: { $0.uniqueID.isEqual(to: whereUniqueID) })
        
    }
    
}

// MARK: - filter

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Returns all elements matching the given name.
    public func filter(name: String,
                       ignoringEmpty: Bool = false) -> [Element] {
        
        ignoringEmpty
            ? filter { $0.name == name && !$0.name.isEmpty }
            : filter { $0.name == name }
        
    }
    
}
