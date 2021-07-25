//
//  Exception.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

/// Raises an `NSException`
internal func raiseException(_ exceptionName: NSExceptionName,
                             reason: String? = nil) {
    
    let exception = NSException(name: exceptionName, reason: reason, userInfo: nil)
    
    exception.raise()
    
}

/// Pre-formed `NSException` cases.
internal enum Exception {
    
    case overflow
    case underflow
    case divisionByZero
    
    internal func raise() {
        
        switch self {
        case .overflow:
            raiseException(.decimalNumberOverflowException, reason: nil)
            
        case .underflow:
            raiseException(.decimalNumberUnderflowException, reason: nil)
            
        case .divisionByZero:
            raiseException(.decimalNumberDivideByZeroException, reason: nil)
            
        }
        
    }
    
}
