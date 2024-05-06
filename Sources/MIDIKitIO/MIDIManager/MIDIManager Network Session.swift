//
//  MIDIManager Network Session.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

extension MIDIManager {
    /// Sets up MIDI network session notification observers.
    /// Call this only once on class init.
    func addNetworkSessionObservers() {
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
        // could update some cached network MIDI session info in the MIDIManager in future?
    }
    
    @objc
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    fileprivate func midiNetworkContactsChanged(notification: NSNotification) {
        guard let session = notification.object as? MIDINetworkSession
        else { return }
    
        _ = session
        // do nothing for now.
        // could update some cached network MIDI session info in the MIDIManager in future?
    }
}

#endif
