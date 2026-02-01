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
    private var storage: ValueWrapper
    
    public init(wrappedValue value: T, target: DispatchQueue? = nil) {
        let queue = DispatchQueue(label: "SerialPThreadMutexValue-\(type(of: T.self))-access", target: target)
        self.queue = queue
        storage = queue.sync { ValueWrapper(value) }
    }
    
    public var wrappedValue: T {
        get {
            return lock.withReadLock { queue.sync { storage.value } }
        }
        _modify {
            lock.writeLock()
            var value = queue.sync { storage.value }
            yield &value
            queue.sync { storage.value = value }
            lock.unlock()
        }
        set {
            lock.withWriteLock { queue.sync { storage.value = newValue } }
        }
    }
}

// TODO: not sure if this is necessary or if it does anything
extension ThreadSynchronizedPThreadMutex: Equatable where T: Equatable {
    public static func == (lhs: ThreadSynchronizedPThreadMutex<T>, rhs: ThreadSynchronizedPThreadMutex<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension ThreadSynchronizedPThreadMutex {
    private class ValueWrapper {
        var value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}
