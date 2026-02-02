//
//  ThreadSynchronized Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct ThreadSynchronized_Tests {
    private class Wrapper: @unchecked Sendable {
        @ThreadSynchronized var number: Int
        
        init(number: Int = 0) {
            self.number = number
        }
    }
    
    // MARK: - Tests
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func differentThreadMutation() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        // local mutation
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        // mutation from another thread
        DispatchQueue.global().sync {
            wrapper.number = 2
        }
        #expect(wrapper.number == 2)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        DispatchQueue.concurrentPerform(iterations: 100) { iteration in
            wrapper.number += 1
        }
        
        withKnownIssue("Thread synchronization does not guarantee atomic reads and writes.") {
            #expect(wrapper.number == 100)
        }
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_backgroundThread() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: 100) { iteration in
                wrapper.number += 1
            }
        }
        
        withKnownIssue("Thread synchronization does not guarantee atomic reads and writes.") {
            #expect(wrapper.number == 100)
        }
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { wrapper.number += 1 }
            }
        }
        
        withKnownIssue("Thread synchronization does not guarantee atomic reads and writes.") {
            #expect(wrapper.number == 100)
        }
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup_fromMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number += 1 }
            }
        }
        
        #expect(wrapper.number == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @MainActor @Test
    func concurrentMutations_taskGroup_fromMainActor_toMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withTaskGroup { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number += 1 }
            }
        }
        
        #expect(wrapper.number == 100)
    }
}
