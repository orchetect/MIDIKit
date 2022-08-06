//
//  MIDIIOObjectProtocol Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - sorted

extension Collection where Element: MIDIIOObjectProtocol {
    /// Returns the array sorted alphabetically by MIDI object name.
    public func sortedByName() -> [Element] {
        sorted(by: {
            $0.name
                .localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
    }
}

// MARK: - first

extension Collection where Element: MIDIIOObjectProtocol {
    /// Returns the first MIDI object matching the given name.
    public func first(
        whereName name: String,
        ignoringEmpty: Bool = false
    ) -> Element? {
        ignoringEmpty
            ? first(where: { $0.name == name && !$0.name.isEmpty })
            : first(where: { $0.name == name })
    }
        
    /// Returns the MIDI object with matching unique ID.
    public func first(whereUniqueID uniqueID: MIDI.IO.UniqueID) -> Element? {
        first(where: { $0.uniqueID == uniqueID })
    }
}

// MARK: - contains

extension Collection where Element: MIDIIOObjectProtocol {
    /// Returns true if the collection contains a MIDI object matching the given name.
    public func contains(
        whereName name: String,
        ignoringEmpty: Bool = false
    ) -> Bool {
        first(
            whereName: name,
            ignoringEmpty: ignoringEmpty
        ) != nil
    }
    
    /// Returns the MIDI object with matching unique ID.
    public func contains(whereUniqueID uniqueID: MIDI.IO.UniqueID) -> Bool {
        contains(where: { $0.uniqueID == uniqueID })
    }
}

// MARK: - filter

extension Collection where Element: MIDIIOObjectProtocol {
    /// Returns all MIDI objects matching the given name.
    public func filter(
        whereName name: String,
        ignoringEmpty: Bool = false
    ) -> [Element] {
        ignoringEmpty
            ? filter { $0.name == name && !$0.name.isEmpty }
            : filter { $0.name == name }
    }
}

#endif
