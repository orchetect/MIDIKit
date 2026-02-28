//
//  MIDIIOObjectProperty Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDIIOObjectProperty {
    /// The result of querying Core MIDI for an object's property value.
    public enum Value<T> {
        /// Value.
        case value(_ value: T)
        
        /// Property has not been set on the MIDI object.
        case notSet
        
        /// An error occurred while querying Core MIDI for the object's property value.
        case error(_ error: MIDIIOError)
    }
}

extension MIDIIOObjectProperty.Value: Equatable where T: Equatable { }

extension MIDIIOObjectProperty.Value: Hashable where T: Hashable { }

extension MIDIIOObjectProperty.Value: Sendable where T: Sendable { }

// MARK: - Properties

extension MIDIIOObjectProperty.Value {
    /// If a value is present, it is returned.
    /// If the property is not set on the MIDI object or an error occurred while reading the property, `nil` is returned.
    @inline(__always)
    public var value: T? {
        switch self {
        case let .value(value):
            value
        case .notSet:
            nil
        case .error:
            nil
        }
    }
}

#endif
