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
    
    /// Converts the underlying value if it is present.
    /// If self is `notSet` or `error`, the instance is returned unmodified since no value is present.
    ///
    /// > Note:
    /// >
    /// > In order to throw a new error from the conversion closure, still as of Swift 6.2 it is required to
    /// > imperatively annotate the closure signature to indicate that it throws a typed error. For example:
    /// >
    /// > ```swift
    /// > foo.convertValue { value throws(MIDIIOError) in
    /// >     // ...
    /// > }
    /// > ```
    public func convertValue<V>(_ block: (_ value: T) throws(MIDIIOError) -> V?) -> MIDIIOObjectProperty.Value<V> {
        switch self {
        case let .error(error):
            return .error(error)
        case .notSet:
            return .notSet
        case let .value(value):
            do {
                guard let newValue = try block(value) else { return .notSet }
                return .value(newValue)
            } catch {
                // conversion generated an error
                return .error(error)
            }
        }
    }
}

#endif
