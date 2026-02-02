//
//  MainThreadSynchronizedPThreadMutex Variable Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct MainThreadSynchronizedPThreadMutex_Variable_Tests {
    private final class Wrapper: Sendable {
        let number: MainThreadSynchronizedPThreadMutex<Int>
        
        init(number: Int = 0) {
            self.number = MainThreadSynchronizedPThreadMutex(wrappedValue: number)
        }
    }
    
    // MARK: - Tests
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func differentThreadMutation() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        // local mutation
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        // mutation from another thread
        DispatchQueue.global().sync {
            wrapper.number.wrappedValue = 2
        }
        #expect(wrapper.number.wrappedValue == 2)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        wrapper.number.wrappedValue = 0
        DispatchQueue.concurrentPerform(iterations: 100) { iteration in
            wrapper.number.wrappedValue += 1
        }
        
        #expect(wrapper.number.wrappedValue == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_backgroundThread() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        wrapper.number.wrappedValue = 0
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: 100) { iteration in
                #expect(!Thread.isMainThread)
                wrapper.number.wrappedValue += 1
            }
        }
        
        #expect(wrapper.number.wrappedValue == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_taskGroup() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        wrapper.number.wrappedValue = 0
        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 100 {
                group.addTask { wrapper.number.wrappedValue += 1 }
            }
        }
        
        #expect(wrapper.number.wrappedValue == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @Test
    func concurrentMutations_fromMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        wrapper.number.wrappedValue = 0
        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.wrappedValue += 1 }
            }
        }
        
        #expect(wrapper.number.wrappedValue == 100)
    }
    
    /// - Note: This test requires Thread Sanitizer enabled in the Test Plan.
    @MainActor @Test
    func concurrentMutations_fromMainActor_toMainActor() async throws {
        let wrapper = Wrapper()
        
        #expect(wrapper.number.wrappedValue == 0)
        
        wrapper.number.wrappedValue = 1
        #expect(wrapper.number.wrappedValue == 1)
        
        wrapper.number.wrappedValue = 0
        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 100 {
                group.addTask { @MainActor in wrapper.number.wrappedValue += 1 }
            }
        }
        
        #expect(wrapper.number.wrappedValue == 100)
    }
}
