//
//  PThreadMutex.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// `PThreadMutex`: A property wrapper that ensures thread-safe atomic access to a value.
/// Multiple read accesses can potentially read at the same time, just not during a write.
///
/// By using `pthread` to do the locking, this safer than using a `DispatchQueue/barrier` as there
/// isn't a chance of priority inversion. It is also generally more performant than queue sync or `NSLock`.
///
/// This is safe to use on collection types (`Array`, `Dictionary`, etc.).
///
/// - Warning: Do not instantiate this wrapper on a variable declaration inside a function body or
///   closure body. Only wrap static or instance variables.
@_documentation(visibility: internal)
@propertyWrapper
public final class PThreadMutex<T> /* : @unchecked Sendable where T: Sendable */ {
    private var value: T
    
    private let lock = PThreadRWLock()
    
    public init(wrappedValue value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        get {
            lock.withReadLock { value }
        }
        _modify {
            lock.writeLock()
            yield &value
            lock.unlock()
        }
        set {
            lock.withWriteLock { value = newValue }
        }
    }
}

extension PThreadMutex: Equatable where T: Equatable {
    public static func == (lhs: PThreadMutex<T>, rhs: PThreadMutex<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension PThreadMutex: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

// MARK: - Methods

extension PThreadMutex {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        try lock.withReadLock {
            try block(value)
        }
    }
    
    @discardableResult @_disfavoredOverload
    public func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        try lock.withWriteLock {
            try block(&value)
        }
    }
}

// MARK: - Helpers

final class PThreadRWLock {
    private var lock = pthread_rwlock_t()
    
    init() {
        guard pthread_rwlock_init(&lock, nil) == 0 else {
            preconditionFailure("Unable to initialize the lock")
        }
    }
    
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    func writeLock() {
        pthread_rwlock_wrlock(&lock)
    }
    
    func readLock() {
        pthread_rwlock_rdlock(&lock)
    }
    
    func unlock() {
        pthread_rwlock_unlock(&lock)
    }
    
    func withReadLock<T>(block: () throws -> T) rethrows -> T {
        readLock()
        defer { unlock() }
        return try block()
    }
    
    func withWriteLock<T>(block: () throws -> T) rethrows -> T {
        writeLock()
        defer { unlock() }
        return try block()
    }
}
