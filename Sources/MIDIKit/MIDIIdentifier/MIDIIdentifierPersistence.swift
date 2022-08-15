//
//  MIDIIdentifierPersistence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Defines persistence behavior of a MIDI unique ID in the system.
public enum MIDIIdentifierPersistence {
    /// Ad-Hoc identifier generation.
    /// The unique ID will be randomly generated every time the endpoint is created in the system -- with no persistent storage provided.
    /// This is default Core MIDI behavior when no identifier is provided.
    ///
    /// ⚠️ This is generally not recommended and is provided mainly for testing purposes.
    ///
    /// Use `.userDefaultsManaged(key:)` where possible, or provide your own storage with `manualStorage(::)`
    case adHoc
    
    /// Unmanaged.
    /// You are responsible for persistently storing the unique identifier.
    /// Note that this identifier may change if the event of a collision where another endpoint already has the identifier.
    /// This means at the end of your application's lifecycle you must query the `uniqueID` property on any `MIDIInput` or `MIDIOutput` ports you have created and update your persistent storage with them.
    ///
    /// In the event a collision with an existing unique ID in the system, a new random ID will be generated until there are no collisions.
    case unmanaged(MIDIIdentifier)
    
    /// Managed with UserDefaults backing (recommended).
    /// The MIDI endpoint's unique ID is managed automatically and persistently stored in `UserDefaults`. The `standard` suite is used by default unless specified.
    ///
    /// If a unique ID does not yet exist for this object, one will be generated randomly.
    ///
    /// In the event a collision with an existing MIDI endpoint unique ID in the system, a new random ID will be generated until there are no collisions.
    /// The ID will then be cached in `UserDefaults` using the key string provided - if the key exists, it will be overwritten.
    case userDefaultsManaged(
        key: String,
        suite: UserDefaults = .standard
    )
     
    /// Managed with custom storage backing (recommended).
    /// Supply handlers to facilitate persistently reading and storing the MIDI endpoint's unique ID.
    ///
    /// This is useful if you need more control over where you want to persist this information in the system.
    ///
    /// In the event a collision with an existing MIDI endpoint unique ID in the system, a new random ID will be generated until there are no collisions.
    /// The ID will then be passed into the `storeHandler` closure in order to store the updated ID.
    case managedStorage(
        readHandler: () -> MIDIIdentifier?,
        storeHandler: (MIDIIdentifier?) -> Void
    )
}

// MARK: - Read/Write Methods

extension MIDIIdentifierPersistence {
    /// Reads the unique ID from the persistent storage, if applicable.
    public func readID() -> MIDIIdentifier? {
        switch self {
        case .adHoc:
            return nil
    
        case let .unmanaged(uniqueID: uniqueID):
            return uniqueID
    
        case let .userDefaultsManaged(key: key, suite: suite):
            // test to see if key does not exist first
            // otherwise just calling integer(forKey:) returns 0 if key does not exist
            guard suite.object(forKey: key) != nil
            else { return nil }
    
            let readInt = suite.integer(forKey: key)
    
            guard let int32Exactly = Int32(exactly: readInt)
            else { return nil }
    
            return MIDIIdentifier(int32Exactly)
    
        case .managedStorage(readHandler: let readHandler, storeHandler: _):
            if let readInt = readHandler() {
                return MIDIIdentifier(readInt)
            }
    
            return nil
        }
    }
    
    /// Writes the unique ID to the persistent storage, if applicable.
    public func writeID(_ newValue: MIDIIdentifier?) {
        switch self {
        case .adHoc:
            return // no storage
    
        case .unmanaged(uniqueID: _):
            return // no storage
    
        case let .userDefaultsManaged(key: key, suite: suite):
            suite.setValue(newValue, forKey: key)
    
        case .managedStorage(readHandler: _, storeHandler: let storeHandler):
            storeHandler(newValue)
        }
    }
}

#endif
