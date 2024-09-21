//
//  MIDIKitInternalError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum MIDIKitInternalError: LocalizedError {
    case malformed(_ verboseError: String)
    
    public var errorDescription: String? {
        switch self {
        case .malformed(let verboseError):
            return "Malformed: \(verboseError)"
        }
    }
}
