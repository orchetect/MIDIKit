//
//  Tests Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

/// MIDIKit Unit test utility: Print function that prints the return value of a closure (syntax).
///
/// For example:
///
///     print {
///         let x = 2
///         return x + 3
///     }
///
/// Prints:
///
///     5
///
public func print(_ closure: () -> Any) {
	
	print(closure())
	
}

#if !os(watchOS)
import XCTest

extension XCTestCase {
    
    /// Simple XCTest wait timer that does not block the runloop
    /// - Parameter timeout: floating-point duration in seconds
    public func XCTWait(sec timeout: Double) {
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: timeout)
        
    }
    
}
#endif
