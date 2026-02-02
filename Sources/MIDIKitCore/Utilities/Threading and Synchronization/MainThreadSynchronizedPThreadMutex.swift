//
//  MainThreadSynchronizedPThreadMutex.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value by synchronizing reads and writes on the main thread.
@_documentation(visibility: internal)
@propertyWrapper
public final class MainThreadSynchronizedPThreadMutex<T> {
    private nonisolated let queue: DispatchQueue = .main
    private let lock = PThreadRWLock()
    nonisolated(unsafe) private let storage: ValueWrapper
    
    public init(wrappedValue value: T) {
        if Thread.isMainThread {
            storage = ValueWrapper(value)
        } else {
            storage = queue.sync { ValueWrapper(value) }
        }
    }
    
    public var wrappedValue: T {
        get {
            lock.readLock()
            defer { lock.unlock() }
            if Thread.isMainThread {
                return storage.value
            } else {
                return queue.sync { storage.value }
            }
        }
        _modify {
            lock.writeLock()
            defer { lock.unlock() }
            if Thread.isMainThread {
                yield &storage.value
            } else {
                var value = queue.sync { storage.value }
                yield &value
                queue.sync { storage.value = value }
            }
        }
        set {
            lock.writeLock()
            defer { lock.unlock() }
            if Thread.isMainThread {
                storage.value = newValue
            } else {
                queue.sync { storage.value = newValue }
            }
        }
    }
}

extension MainThreadSynchronizedPThreadMutex: Equatable where T: Equatable {
    public static func == (lhs: MainThreadSynchronizedPThreadMutex<T>,
                           rhs: MainThreadSynchronizedPThreadMutex<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension MainThreadSynchronizedPThreadMutex: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension MainThreadSynchronizedPThreadMutex: Sendable where T: Sendable { }

// MARK: - Methods

extension MainThreadSynchronizedPThreadMutex {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        lock.readLock()
        defer { lock.unlock() }
        
        if Thread.isMainThread {
            return try block(storage.value)
        } else {
            return try queue.sync { try block(storage.value) }
        }
    }
    
    @discardableResult @_disfavoredOverload
    public func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        
        if Thread.isMainThread {
            return try block(&storage.value)
        } else {
            return try queue.sync { try block(&storage.value) }
        }
    }
}

// MARK: - Helpers

extension MainThreadSynchronizedPThreadMutex {
    fileprivate final class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}

extension MainThreadSynchronizedPThreadMutex.ValueWrapper: Equatable where T: Equatable {
    static func == (lhs: MainThreadSynchronizedPThreadMutex<T>.ValueWrapper,
                    rhs: MainThreadSynchronizedPThreadMutex<T>.ValueWrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension MainThreadSynchronizedPThreadMutex.ValueWrapper: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
