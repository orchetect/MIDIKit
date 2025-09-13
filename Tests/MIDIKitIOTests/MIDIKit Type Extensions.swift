//
//  MIDIKit Type Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import MIDIKitIO

extension MIDIIONotification {
    enum Kind: Equatable, Hashable, Sendable, CaseIterable {
        case setupChanged
        case added
        case removed
        case propertyChanged
        case thruConnectionChanged
        case serialPortOwnerChanged
        case ioError
        case internalStart
        case other
    }
    
    func isCase(_ kind: Kind) -> Bool {
        switch (self, kind) {
        case (.setupChanged, .setupChanged): return true
        case (.added, .added): return true
        case (.removed, .removed): return true
        case (.propertyChanged, .propertyChanged): return true
        case (.thruConnectionChanged, .thruConnectionChanged): return true
        case (.serialPortOwnerChanged, .serialPortOwnerChanged): return true
        case (.ioError, .ioError): return true
        case (.internalStart, .internalStart): return true
        case (.other, .other): return true
        default: return false
        }
    }
}

#endif
