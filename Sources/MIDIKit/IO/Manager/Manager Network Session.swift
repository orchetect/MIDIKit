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
    ///
    /// Supported on macOS 10.15+, macCatalyst 13.0+ and iOS 4.2+.
    ///
    /// - Parameters:
    ///   - enabled: Enable or disable the default MIDI network session.
    ///   - policy: The policy that determines who can connect to this session.
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public func setNetworkSession(enabled: Bool,
                                  policy: MIDI.IO.NetworkConnectionPolicy) {
        
        setupNetworkSession()
        
        networkSession?.isEnabled = enabled
        networkSession?.connectionPolicy = policy.coreMIDIPolicy
        
    }
    
    fileprivate func setupNetworkSession() {
        
        guard networkSession == nil else { return }
        
        networkSession = .init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(midiNetworkChanged(notification:)),
            name: .midiNetworkSessionDidChange,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(midiNetworkContactsChanged(notification:)),
            name: .midiNetworkContactsDidChange,
            object: nil)
        
    }
    
    @objc
    fileprivate func midiNetworkChanged(notification: NSNotification) {
        
        guard let session = notification.object as? MIDINetworkSession,
              session == networkSession
        else { return }
        
        _ = session
        // do nothing for now.
        // could update some cached network MIDI session info in the Manager in future?
        
    }
    
    @objc
    fileprivate func midiNetworkContactsChanged(notification: NSNotification) {
        
        guard let session = notification.object as? MIDINetworkSession,
              session == networkSession
        else { return }
        
        _ = session
        // do nothing for now.
        // could update some cached network MIDI session info in the Manager in future?
        
    }
    
}

extension NSNotification.Name {
    
    /// aka MIDINetworkNotificationSessionDidChange
    fileprivate static let midiNetworkSessionDidChange = NSNotification.Name(MIDINetworkNotificationSessionDidChange)
    
    /// aka MIDINetworkNotificationSessionDidChange
    fileprivate static let midiNetworkContactsDidChange = NSNotification.Name(MIDINetworkNotificationSessionDidChange)
    
}
