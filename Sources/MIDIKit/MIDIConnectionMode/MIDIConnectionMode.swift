//
//  MIDIConnectionMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

/// Behavior of a managed MIDI connection.
public enum MIDIConnectionMode: Equatable, Hashable {
    /// Specific endpoint criteria.
    case definedEndpoints
        
    /// Automatically adds all endpoints in the system and adds any new endpoints that appear in the system at any time thereafter.
    /// (Endpoint filters are respected.)
    ///
    /// Note that this mode overrides `criteria`.
    case allEndpoints
}

#endif
