//
//  ThreadSynchronizedValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value by synchronizing reads and writes on a queue.
@_documentation(visibility: internal)
public struct ThreadSynchronizedValue<T> {
    private nonisolated let queue: DispatchQueue
    nonisolated(unsafe) private let storage: ValueWrapper
    
    public init(_ value: T, target: DispatchQueue? = nil) {
        let queue = DispatchQueue(
            label: "ThreadSynchronizedValue-\(type(of: T.self))-access",
            target: target
        )
        self.queue = queue
        storage = queue.sync { ValueWrapper(value) }
    }
    
    public var value: T {
        get {
            queue.sync { storage.value }
        }
        _modify {
            var value = queue.sync { storage.value }
            yield &value
            queue.sync { storage.value = value }
        }
        set {
            queue.sync { storage.value = newValue }
        }
    }
}

extension ThreadSynchronizedValue: Equatable where T: Equatable {
    public static func == (lhs: ThreadSynchronizedValue<T>,
                           rhs: ThreadSynchronizedValue<T>) -> Bool {
        lhs.value == rhs.value
    }
}

extension ThreadSynchronizedValue: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension ThreadSynchronizedValue: Sendable where T: Sendable { }

// MARK: - Methods

extension ThreadSynchronizedValue {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        try queue.sync { try block(storage.value) }
    }
    
    @discardableResult @_disfavoredOverload
    public func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        try queue.sync { try block(&storage.value) }
    }
}

// MARK: - Helpers

extension ThreadSynchronizedValue {
    fileprivate final class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}

extension ThreadSynchronizedValue.ValueWrapper: Equatable where T: Equatable {
    static func == (lhs: ThreadSynchronizedValue<T>.ValueWrapper,
                    rhs: ThreadSynchronizedValue<T>.ValueWrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension ThreadSynchronizedValue.ValueWrapper: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
