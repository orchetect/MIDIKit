//
//  MIDIIONetworkConnectionPolicy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import CoreMIDI

// MARK: - NetworkConnectionPolicy

public enum MIDIIONetworkConnectionPolicy: UInt, Equatable {
    case noOne
    case hostsInContactList
    case anyone
    
    internal init(_ coreMIDIPolicy: MIDINetworkConnectionPolicy) {
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
    
    internal var coreMIDIPolicy: MIDINetworkConnectionPolicy {
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
