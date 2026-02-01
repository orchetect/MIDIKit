//
//  MainThreadSynchronizedPThreadMutex.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value by synchronizing
/// reads and writes on the main thread.
@_documentation(visibility: internal)
@propertyWrapper
public struct MainThreadSynchronizedPThreadMutex<T> {
    private var storage: ValueWrapper
    private let lock = PThreadRWLock()
    
    public init(wrappedValue value: T) {
        if Thread.isMainThread {
            storage = ValueWrapper(value)
        } else {
            storage = DispatchQueue.main.sync { ValueWrapper(value) }
        }
    }
    
    public var wrappedValue: T {
        get {
            return lock.withReadLock {
                if Thread.isMainThread {
                    return storage.value
                } else {
                    return DispatchQueue.main.sync { storage.value }
                }
            }
        }
        _modify {
            lock.writeLock()
            if Thread.isMainThread {
                yield &storage.value
            } else {
                var value = DispatchQueue.main.sync { storage.value }
                yield &value
                DispatchQueue.main.sync { storage.value = value }
            }
            lock.unlock()
        }
        set {
            lock.withWriteLock {
                if Thread.isMainThread {
                    storage.value = newValue
                } else {
                    DispatchQueue.main.sync { storage.value = newValue }
                }
            }
        }
    }
}

extension MainThreadSynchronizedPThreadMutex: Equatable where T: Equatable {
    public static func == (lhs: MainThreadSynchronizedPThreadMutex<T>, rhs: MainThreadSynchronizedPThreadMutex<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension MainThreadSynchronizedPThreadMutex: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

// MARK: - Methods

extension MainThreadSynchronizedPThreadMutex {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        try lock.withReadLock {
            if Thread.isMainThread {
                try block(storage.value)
            } else {
                try DispatchQueue.main.sync { try block(storage.value) }
            }
        }
    }
    
    @discardableResult @_disfavoredOverload
    public func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        try lock.withWriteLock {
            if Thread.isMainThread {
                try block(&storage.value)
            } else {
                try DispatchQueue.main.sync { try block(&storage.value) }
            }
        }
    }
}

// MARK: - Helpers

extension MainThreadSynchronizedPThreadMutex {
    private class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}
