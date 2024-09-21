//
//  MIDIKitIO-0.8.1.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// Symbols that were renamed or removed.

extension MIDIIONotification {
    @available(*, deprecated, renamed: "added(object:parent:)")
    public static func added(parent: AnyMIDIIOObject?, child: AnyMIDIIOObject) -> Self {
        .added(object: child, parent: parent)
    }
    
    @available(*, deprecated, renamed: "removed(object:parent:)")
    public static func removed(parent: AnyMIDIIOObject?, child: AnyMIDIIOObject) -> Self {
        .removed(object: child, parent: parent)
    }
    
    @available(*, deprecated, renamed: "propertyChanged(property:forObject:)")
    public static func propertyChanged(
        object: AnyMIDIIOObject,
        property: AnyMIDIIOObject.Property
    ) -> Self {
        .propertyChanged(property: property, forObject: object)
    }
}

extension MIDIIOObject {
    @available(*, deprecated, renamed: "propertyStringValues(relevantOnly:)")
    public func propertiesAsStrings(
        onlyIncludeRelevant: Bool
    ) -> [(key: String, value: String)] {
        propertyStringValues(relevantOnly: onlyIncludeRelevant)
    }
}

#endif
