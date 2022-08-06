//
//  Manager Network Session.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    /// Sets up MIDI network session notification observers.
    /// Call this only once on class init.
    internal func addNetworkSessionObservers() {
        guard #available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *) else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(midiNetworkChanged(notification:)),
            name: .midiNetworkSessionDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(midiNetworkContactsChanged(notification:)),
            name: .midiNetworkContactsDidChange,
            object: nil
        )
    }
    
    @objc
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    fileprivate func midiNetworkChanged(notification: NSNotification) {
        guard let session = notification.object as? MIDINetworkSession
        else { return }
        
        _ = session
        // do nothing for now.
        // could update some cached network MIDI session info in the Manager in future?
    }
    
    @objc
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    fileprivate func midiNetworkContactsChanged(notification: NSNotification) {
        guard let session = notification.object as? MIDINetworkSession
        else { return }
        
        _ = session
        // do nothing for now.
        // could update some cached network MIDI session info in the Manager in future?
    }
}

#endif
