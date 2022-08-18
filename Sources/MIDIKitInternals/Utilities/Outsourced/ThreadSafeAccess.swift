/// ------------------------------------------------
/// ------------------------------------------------
/// OTAtomics/OTAtomicsThreadSafe.swift
///
/// Borrowed from OTAtomics 1.0.0 under MIT license.
/// https://github.com/orchetect/OTAtomics
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ------------------------------------------------
/// ------------------------------------------------

import Foundation

/// `ThreadSafeAccess`: A property wrapper that ensures thread-safe atomic access to a value.
/// Multiple read accesses can potentially read at the same time, just not during a write.
///
/// By using `pthread` to do the locking, this safer than using a `DispatchQueue/barrier` as there isn't a chance of priority inversion.
///
/// This is safe to use on collection types (`Array`, `Dictionary`, etc.).
///
/// - Warning: Do not instance this wrapper on a variable declaration inside a function. Only wrap class-bound, struct-bound, or global-bound variables.
@propertyWrapper
public final class ThreadSafeAccess<T> {
    private var value: T
    
    private let lock: ThreadLock = RWThreadLock()
    
    public init(wrappedValue value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        get {
            lock.readLock()
            defer { self.lock.unlock() }
            return value
        }
    
        set {
            lock.writeLock()
            value = newValue
            lock.unlock()
        }
    
        // _modify { } is an internal Swift computed setter, similar to set { }
        // however it gives in-place exclusive mutable access
        // which allows get-then-set operations such as collection subscripts
        // to be performed in a single thread-locked operation
        _modify {
            self.lock.writeLock()
            yield &value
            self.lock.unlock()
        }
    }
}

/// Defines a basic signature to which all locks will conform. Provides the basis for atomic access to stuff.
private protocol ThreadLock {
    init()
    
    /// Lock a resource for writing. So only one thing can write, and nothing else can read or write.
    func writeLock()
    
    /// Lock a resource for reading. Other things can also lock for reading at the same time, but nothing else can write at that time.
    func readLock()
    
    /// Unlock a resource
    func unlock()
}

private final class RWThreadLock: ThreadLock {
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
}
