//
//  SerialThreadSafeAccess.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A property wrapper that ensures serialized thread-safe access to a value.
@_documentation(visibility: internal)
@propertyWrapper
public final class SerialThreadSafeAccess<T> {
    private let queue: DispatchQueue
    private let isMain: Bool
    private var storage: T!
    
    public init(wrappedValue value: T, target: DispatchQueue? = nil) {
        isMain = target == .main
        queue = DispatchQueue(label: "SerialThreadSafeAccess-\(type(of: T.self))-access", target: target)
        self.wrappedValue = value
    }
    
    public var wrappedValue: T {
        get {
            if isMain, Thread.isMainThread {
                return storage
            } else {
                return queue.sync { storage }
            }
        }
        set {
            if isMain, Thread.isMainThread {
                storage = newValue
            } else {
                queue.sync { storage = newValue }
            }
        }
    }
}
