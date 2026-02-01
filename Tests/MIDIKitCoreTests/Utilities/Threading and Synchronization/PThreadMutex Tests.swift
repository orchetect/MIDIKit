//
//  PThreadMutex Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct PThreadMutex_Tests {
    private class Wrapper: @unchecked Sendable {
        @PThreadMutex var number: Int
        
        init(number: Int = 0) {
            self.number = number
        }
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
            wrapper.number += 1
        }
        
        #expect(wrapper.number == 1000)
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
            DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
                #expect(!Thread.isMainThread)
                wrapper.number += 1
            }
        }
        
        #expect(wrapper.number == 1000)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 1000 {
                group.addTask { wrapper.number += 1 }
            }
        }
        
        #expect(wrapper.number == 1000)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_fromMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 1000 {
                group.addTask { @MainActor in wrapper.number += 1 }
            }
        }
        
        #expect(wrapper.number == 1000)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @MainActor @Test
    func concurrentMutations_fromMainActor_toMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number == 0)
        
        wrapper.number = 1
        #expect(wrapper.number == 1)
        
        wrapper.number = 0
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< 1000 {
                group.addTask { @MainActor in wrapper.number += 1 }
            }
        }
        
        #expect(wrapper.number == 1000)
    }
}
