//
//  Threading.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Synchronizes access to a property on a specified dispatch queue.
///
/// > Note:
/// >
/// > This cannot be used within a `Sendable` object, as the hidden underscore-prefixed variable
/// > that Swift synthesizes for the property wrapper is a `var`. The only known workaround is to make the object
/// > `@unchecked Sendable` instead.
@propertyWrapper
package struct SyncAccess<Value>: Sendable {
    private let queue: DispatchQueue
    
    private nonisolated(unsafe)
    var value: Value
    
    // nonisolated
    package var wrappedValue: Value {
        @storageRestrictions(initializes: value)
        init {
            value = newValue
        }
        get {
            queue.sync {
                value
            }
        }
        _modify {
            var valueCopy = queue.sync { value }
            yield &valueCopy
            queue.sync {
                value = valueCopy
            }
        }
        set {
            queue.sync {
                value = newValue
            }
        }
    }
    
    package init(wrappedValue: Value, on queue: @autoclosure () -> DispatchQueue) {
        self.queue = queue()
        self.wrappedValue = wrappedValue
    }
}
