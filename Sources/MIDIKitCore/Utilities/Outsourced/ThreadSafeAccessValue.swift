//
//  ThreadSafeAccessValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// `ThreadSafeAccess`: A struct that ensures thread-safe atomic access to a value.
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
public struct ThreadSafeAccessValue<T> /* : @unchecked Sendable where T: Sendable */ {
    private var storage: T
    
    private let lock = RWThreadLock()
    
    public init(value: T) {
        storage = value
    }
    
    public var value: T {
        get {
            lock.readLock()
            defer { self.lock.unlock() }
            return storage
        }
        
        set {
            lock.writeLock()
            storage = newValue
            lock.unlock()
        }
        
        // _modify { } is an internal Swift computed setter, similar to set { }
        // however it gives in-place exclusive mutable access
        // which allows get-then-set operations such as collection subscripts
        // to be performed in a single thread-locked operation
        _modify {
            lock.writeLock()
            yield &storage
            lock.unlock()
        }
    }
    
    @discardableResult
    public mutating func withValue<Result>(_ mutation: (inout T) throws -> Result) rethrows -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        return try mutation(&storage)
    }
    
    @discardableResult @_disfavoredOverload
    public mutating func withValue<Result>(_ mutation: (inout T) -> Result) -> Result {
        lock.writeLock()
        defer { lock.unlock() }
        return mutation(&storage)
    }
}
