//
//  IO Network.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

// MARK: - NetworkConnectionPolicy

extension MIDI.IO {
    public enum NetworkConnectionPolicy: UInt, Equatable {
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
}
