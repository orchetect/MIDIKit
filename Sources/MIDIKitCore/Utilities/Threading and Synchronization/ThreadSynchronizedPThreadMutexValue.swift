//
//  ThreadSynchronizedPThreadMutexValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value by synchronizing reads and writes on a queue.
@_documentation(visibility: internal)
public struct ThreadSynchronizedPThreadMutexValue<T> {
    private nonisolated let queue: DispatchQueue
    private let lock = PThreadRWLock()
    nonisolated(unsafe) private let storage: ValueWrapper
    
    public init(_ value: T, target: DispatchQueue? = nil) {
        let queue = DispatchQueue(label: "SerialPThreadMutexValue-\(type(of: T.self))-access", target: target)
        self.queue = queue
        storage = queue.sync { ValueWrapper(value) }
    }
    
    public var value: T {
        get {
            lock.readLock()
            defer { lock.unlock() }
            return queue.sync { storage.value }
        }
        mutating _modify {
            lock.writeLock()
            defer { lock.unlock() }
            var value = queue.sync { storage.value }
            yield &value
            queue.sync { storage.value = value }
        }
        mutating set {
            lock.writeLock()
            defer { lock.unlock() }
            queue.sync { storage.value = newValue }
        }
    }
}

extension ThreadSynchronizedPThreadMutexValue: Equatable where T: Equatable {
    public static func == (lhs: ThreadSynchronizedPThreadMutexValue<T>,
                           rhs: ThreadSynchronizedPThreadMutexValue<T>) -> Bool {
        lhs.value == rhs.value
    }
}

extension ThreadSynchronizedPThreadMutexValue: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension ThreadSynchronizedPThreadMutexValue: Sendable where T: Sendable { }

// MARK: - Methods

extension ThreadSynchronizedPThreadMutexValue {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        lock.readLock()
        defer { lock.unlock() }
        return try queue.sync { try block(storage.value) }
    }
    
    @discardableResult @_disfavoredOverload
    public mutating func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        return try queue.sync { try block(&storage.value) }
    }
}

// MARK: - Helpers

extension ThreadSynchronizedPThreadMutexValue {
    fileprivate final class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}

extension ThreadSynchronizedPThreadMutexValue.ValueWrapper: Equatable where T: Equatable {
    static func == (lhs: ThreadSynchronizedPThreadMutexValue<T>.ValueWrapper,
                    rhs: ThreadSynchronizedPThreadMutexValue<T>.ValueWrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension ThreadSynchronizedPThreadMutexValue.ValueWrapper: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
