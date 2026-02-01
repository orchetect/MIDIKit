//
//  Mutex Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing
import Synchronization

/// This suite is just a diagnostic of the Swift `Mutex` to determine its behavior.
@Suite struct Mutex_Tests {
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    private final class Wrapper: Sendable {
        let number: Mutex<Int>
        
        init(number: Int = 0) {
            self.number = Mutex(number)
        }
    }
    
    // MARK: - Tests
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func differentThreadMutation() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        // local mutation
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        // mutation from another thread
        DispatchQueue.global().sync {
            wrapper.number.value = 2
        }
        #expect(wrapper.number.value == 2)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func concurrentMutations() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        DispatchQueue.concurrentPerform(iterations: 100) { iteration in
            wrapper.number.withLock { $0 += 1 }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func concurrentMutations_backgroundThread() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: 100) { iteration in
                wrapper.number.withLock { $0 += 1 }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func concurrentMutations_taskGroup() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { wrapper.number.withLock { $0 += 1 } }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test
    func concurrentMutations_taskGroup_fromMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.withLock { $0 += 1 } }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @MainActor @Test
    func concurrentMutations_taskGroup_fromMainActor_toMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.withLock { $0 += 1 } }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
}

// MARK: - Helpers

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Mutex where Value == Int {
    fileprivate var value: Value {
        get { withLock { $0 } }
        nonmutating set { withLock { $0 = newValue } }
    }
}
