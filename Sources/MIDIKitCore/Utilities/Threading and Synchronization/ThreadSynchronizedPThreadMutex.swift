//
//  ThreadSynchronizedPThreadMutex.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value by synchronizing reads and writes on a queue.
@_documentation(visibility: internal)
@propertyWrapper
public final class ThreadSynchronizedPThreadMutex<T> {
    private nonisolated let queue: DispatchQueue
    private let lock = PThreadRWLock()
    nonisolated(unsafe) private let storage: ValueWrapper
    
    public init(wrappedValue value: T, target: DispatchQueue? = nil) {
        let queue = DispatchQueue(
            label: "ThreadSynchronizedPThreadMutex-\(type(of: T.self))-access",
            target: target
        )
        self.queue = queue
        storage = queue.sync { ValueWrapper(value) }
    }
    
    public var wrappedValue: T {
        get {
            lock.readLock()
            defer { lock.unlock() }
            return queue.sync { storage.value }
        }
        _modify {
            lock.writeLock()
            defer { lock.unlock() }
            var value = queue.sync { storage.value }
            yield &value
            queue.sync { storage.value = value }
        }
        set {
            lock.writeLock()
            defer { lock.unlock() }
            queue.sync { storage.value = newValue }
        }
    }
}

extension ThreadSynchronizedPThreadMutex: Equatable where T: Equatable {
    public static func == (lhs: ThreadSynchronizedPThreadMutex<T>,
                           rhs: ThreadSynchronizedPThreadMutex<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension ThreadSynchronizedPThreadMutex: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension ThreadSynchronizedPThreadMutex: Sendable where T: Sendable { }

// MARK: - Methods

extension ThreadSynchronizedPThreadMutex {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        lock.readLock()
        defer { lock.unlock() }
        return try queue.sync { try block(storage.value) }
    }
    
    @discardableResult @_disfavoredOverload
    public func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        return try queue.sync { try block(&storage.value) }
    }
}

// MARK: - Helpers

extension ThreadSynchronizedPThreadMutex {
    fileprivate final class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}

extension ThreadSynchronizedPThreadMutex.ValueWrapper: Equatable where T: Equatable {
    static func == (lhs: ThreadSynchronizedPThreadMutex<T>.ValueWrapper,
                    rhs: ThreadSynchronizedPThreadMutex<T>.ValueWrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension ThreadSynchronizedPThreadMutex.ValueWrapper: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
