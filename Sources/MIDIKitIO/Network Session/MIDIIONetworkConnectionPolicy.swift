//
//  MIDIIONetworkConnectionPolicy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import CoreMIDI

public enum MIDIIONetworkConnectionPolicy: UInt {
    case noOne
    case hostsInContactList
    case anyone
}

extension MIDIIONetworkConnectionPolicy: Equatable { }

extension MIDIIONetworkConnectionPolicy: Hashable { }

extension MIDIIONetworkConnectionPolicy: Sendable { }

// MARK: - Internal

extension MIDIIONetworkConnectionPolicy {
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
