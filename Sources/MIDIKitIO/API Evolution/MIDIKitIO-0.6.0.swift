//
//  MIDIKitIO-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore

// Symbols that were renamed or removed.

// MARK: MIDIUniqueID -> MIDIIdentifier

extension Set<MIDIIdentifier> {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> Set<MIDIEndpointIdentity> { fatalError() }
}

extension [MIDIIdentifier] {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> [MIDIEndpointIdentity] { fatalError() }
}

// MARK: UniqueIDPersistence -> MIDIIdentifierPersistence

extension MIDIIdentifierPersistence {
    @available(*, unavailable, renamed: "adHoc")
    @_disfavoredOverload
    public static let none: Self = { fatalError() }()
    
    @available(*, unavailable, renamed: "unmanaged")
    @_disfavoredOverload
    public static func preferred(_: MIDIIdentifier) -> Self { fatalError() }
    
    // case userDefaultsManaged was not renamed
    
    @available(*, unavailable, renamed: "managedStorage")
    @_disfavoredOverload
    public static func manualStorage(
        readHandler: () -> MIDIIdentifier?,
        storeHandler: (MIDIIdentifier?) -> Void
    ) -> Self { fatalError() }
}

#endif
