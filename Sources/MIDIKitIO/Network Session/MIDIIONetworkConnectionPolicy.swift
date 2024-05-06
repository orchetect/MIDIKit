//
//  MIDIIONetworkConnectionPolicy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

// MARK: - NetworkConnectionPolicy

public enum MIDIIONetworkConnectionPolicy: UInt, Equatable {
    case noOne
    case hostsInContactList
    case anyone
    
    init(_ coreMIDIPolicy: MIDINetworkConnectionPolicy) {
        switch coreMIDIPolicy {
        case .noOne:
            self = .noOne
    
        case .hostsInContactList:
            self = .hostsInContactList
    
        case .anyone:
            self = .anyone
    
        @unknown default:
            self = .noOne
        }
    }
    
    var coreMIDIPolicy: MIDINetworkConnectionPolicy {
        switch self {
        case .noOne:
            return .noOne
    
        case .hostsInContactList:
            return .hostsInContactList
    
        case .anyone:
            return .anyone
        }
    }
}

extension MIDIIONetworkConnectionPolicy: Sendable { }
