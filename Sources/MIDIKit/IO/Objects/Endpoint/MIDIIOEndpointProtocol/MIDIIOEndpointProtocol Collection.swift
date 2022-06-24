//
//  MIDIIOEndpointProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - sorted

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the array sorted alphabetically by MIDI endpoint display name.
    public func sortedByDisplayName() -> [Element] {
        
        self.sorted(by: {
            $0.displayName
                .localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        })
        
    }
    
}

// MARK: - first

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the first element matching the given name.
    public func first(withDisplayName displayName: String,
                      ignoringEmpty: Bool = false) -> Element? {
        
        ignoringEmpty
        ? first(where: {
            guard let elementDisplayName = $0.getDisplayName(),
                  !elementDisplayName.isEmpty else { return false }
            return elementDisplayName == displayName
        })
        : first(where: { $0.displayName == displayName })
        
    }
    
    /// Returns the element with matching unique ID.
    /// If not found, the first element matching the given display name is returned.
    public func first(whereUniqueID: MIDI.IO.UniqueID,
                      fallbackDisplayName: String,
                      ignoringEmpty: Bool = false) -> Element? {
        
        first(whereUniqueID: whereUniqueID) ??
        first(withDisplayName: fallbackDisplayName, ignoringEmpty: ignoringEmpty)
        
    }
    
}

// MARK: - filter

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns all elements matching the given display name.
    public func filter(displayName: String,
                       ignoringEmpty: Bool = false) -> [Element] {
        
        ignoringEmpty
        ? filter { (displayName == $0.displayName) && !$0.displayName.isEmpty }
        : filter { $0.displayName == displayName }
        
    }
    
}
