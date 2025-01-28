//
//  Threading.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DispatchQueue {
    /// Same as `sync { }` but reuses current context if execution is already on the queue.
    @inline(__always)
    @discardableResult
    package func syncNonNesting<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.current == self {
            return try work()
        } else {
            return try self.sync {
                try work()
            }
        }
    }
}

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
    
    nonisolated(unsafe)
    private var value: Value
    
    // nonisolated
    package var wrappedValue: Value {
        @storageRestrictions(initializes: value)
        init {
            value = newValue
        }
        get {
            return queue.syncNonNesting {
                value
            }
        }
        _modify {
            var valueCopy = queue.syncNonNesting { value }
            yield &valueCopy
            queue.syncNonNesting {
                value = valueCopy
            }
        }
        set {
            queue.syncNonNesting {
                value = newValue
            }
        }
    }
    
    package init(wrappedValue: Value, on queue: @autoclosure () -> DispatchQueue) {
        self.queue = queue()
        self.wrappedValue = wrappedValue
    }
}
