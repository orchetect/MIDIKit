//
//  MIDIIOEndpointProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension Collection where Element : MIDIIOEndpointProtocol {
    
    // Note: sortedByName() is already implemented on MIDIIOEndpointProtocol
    // and requires no special implementation here for endpoints.
    
    /// Returns the array sorted alphabetically by MIDI object name.
    public func sortedByDisplayName() -> [Element] {
        
        self.sorted(by: {
            $0.displayName
                .localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        })
        
    }
    
}

// MARK: - first

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the first endpoint matching the given name.
    public func first(whereDisplayName displayName: String,
                      ignoringEmpty: Bool = false) -> Element? {
        
        ignoringEmpty
        ? first(where: { ($0.displayName == displayName) && !$0.displayName.isEmpty })
        : first(where: { $0.displayName == displayName })
        
    }
    
    /// Returns the endpoint with matching unique ID.
    /// If not found, the first element matching the given display name is returned.
    public func first(whereUniqueID uniqueID: MIDI.IO.UniqueID,
                      fallbackDisplayName: String,
                      ignoringEmpty: Bool = false) -> Element? {
        
        first(whereUniqueID: uniqueID) ??
        first(whereDisplayName: fallbackDisplayName,
              ignoringEmpty: ignoringEmpty)
        
    }
    
}

// MARK: - contains

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// eturns true if the collection contains an endpoint matching the given name.
    public func contains(whereDisplayName displayName: String,
                         ignoringEmpty: Bool = false) -> Bool {
        
        first(whereDisplayName: displayName,
              ignoringEmpty: ignoringEmpty) != nil
        
    }
    
    /// Returns true if the collection contains an endpoint with matching unique ID.
    /// If not found, the first element matching the given display name is checked.
    public func contains(whereUniqueID uniqueID: MIDI.IO.UniqueID,
                         fallbackDisplayName: String,
                         ignoringEmpty: Bool = false) -> Bool {
        
        first(whereUniqueID: uniqueID,
              fallbackDisplayName: fallbackDisplayName,
              ignoringEmpty: ignoringEmpty) != nil
        
    }
    
}

// MARK: - filter

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns all endpoints matching the given name.
    public func filter(whereName name: String,
                       ignoringEmpty: Bool = false) -> [Element] {
        
        ignoringEmpty
        ? filter { (name == $0.name) && !$0.name.isEmpty }
        : filter { $0.name == name }
        
    }
    
    /// Returns all endpoints matching the given display name.
    public func filter(whereDisplayName displayName: String,
                       ignoringEmpty: Bool = false) -> [Element] {
        
        ignoringEmpty
        ? filter { ($0.displayName == displayName) && !$0.displayName.isEmpty }
        : filter { $0.displayName == displayName }
        
    }
    
}
