//
//  ThreadSynchronizedValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct ThreadSynchronizedValue_Tests {
    private final class Wrapper: @unchecked Sendable {
        /* nonisolated(unsafe) */
        @PThreadMutex // seems redundant, however we need it to prevent overlapping access since we're storing a value type
        var number: ThreadSynchronizedValue<Int>
        
        init(number: Int = 0) {
            self.number = ThreadSynchronizedValue(number)
        }
    }
    
    // MARK: - Tests
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
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
    @Test
    func concurrentMutations() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        DispatchQueue.concurrentPerform(iterations: 100) { iteration in
            wrapper.number.value += 1
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_backgroundThread() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: 100) { iteration in
                wrapper.number.value += 1
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { wrapper.number.value += 1 }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup_fromMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.value += 1 }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @MainActor @Test
    func concurrentMutations_taskGroup_fromMainActor_toMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.value == 0)
        
        wrapper.number.value = 1
        #expect(wrapper.number.value == 1)
        
        wrapper.number.value = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.value += 1 }
            }
        }
        
        #expect(wrapper.number.value == 100)
    }
}
