//
//  Manager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

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

extension MIDI.IO.Manager {
    
    /// Sets the MIDI Network Session state.
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public func setMIDINetwork(enabled: Bool, policy: MIDI.IO.NetworkConnectionPolicy) {
        
        MIDINetworkSession.default().isEnabled = enabled
        MIDINetworkSession.default().connectionPolicy = policy.coreMIDIPolicy
        
    }
    
}
