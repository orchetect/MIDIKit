//
//  SerialThreadSafeAccessValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A value wrapper that ensures serialized thread-safe atomic to a value.
@_documentation(visibility: internal)
public struct SerialThreadSafeAccessValue<T> {
    private let queue: DispatchQueue
    private let isMain: Bool
    private var storage: T!
    
    public init(_ value: T, target: DispatchQueue? = nil) {
        isMain = target == .main
        queue = DispatchQueue(label: "SerialThreadSafeAccessValue-\(type(of: T.self))-access", target: target)
        self.value = value
    }
}

extension SerialThreadSafeAccessValue {
    public var value: T {
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
    
    @discardableResult
    public mutating func withValue<Result>(_ mutation: (inout T) throws -> Result) rethrows -> Result {
        if isMain, Thread.isMainThread {
            return try mutation(&storage)
        } else {
            return try queue.sync { try mutation(&storage) }
        }
    }
    
    @discardableResult @_disfavoredOverload
    public mutating func withValue<Result>(_ mutation: (inout T) -> Result) -> Result {
        if isMain, Thread.isMainThread {
            return mutation(&storage)
        } else {
            return queue.sync { mutation(&storage) }
        }
    }
}
