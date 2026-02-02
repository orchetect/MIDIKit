//
//  PThreadMutexValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures exclusive access to a value.
/// Multiple read accesses can potentially read at the same time, just not during a write.
///
/// By using `pthread` to do the locking, this safer than using a `DispatchQueue/barrier` as there
/// isn't a chance of priority inversion. It is also generally more performant than queue sync or `NSLock`.
///
/// - Warning: Do not instantiate this wrapper on a variable declaration inside a function body or
///   closure body. Only wrap static or instance variables.
@_documentation(visibility: internal)
public struct PThreadMutexValue<T> {
    nonisolated(unsafe) private var storage: T
    
    private let lock = PThreadRWLock()
    
    public init(_ value: T) {
        self.storage = value
    }
    
    public var value: T {
        get {
            lock.readLock()
            defer { lock.unlock() }
            return storage
        }
        mutating _modify {
            lock.writeLock()
            defer { lock.unlock() }
            yield &storage
        }
        mutating set {
            lock.writeLock()
            defer { lock.unlock() }
            storage = newValue
        }
    }
}

extension PThreadMutexValue: Equatable where T: Equatable {
    public static func == (lhs: PThreadMutexValue<T>, rhs: PThreadMutexValue<T>) -> Bool {
        lhs.value == rhs.value
    }
}

extension PThreadMutexValue: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension PThreadMutexValue: Sendable where T: Sendable { }

// MARK: - Methods

extension PThreadMutexValue {
    @discardableResult
    public func withReadLock<Result>(_ block: (T) throws -> Result) rethrows -> Result {
        lock.readLock()
        defer { lock.unlock() }
        return try block(storage)
    }
    
    @discardableResult @_disfavoredOverload
    public mutating func withWriteLock<Result>(_ block: (inout T) throws -> Result) rethrows -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        return try block(&storage)
    }
}
