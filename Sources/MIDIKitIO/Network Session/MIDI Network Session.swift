//
//  MIDI Network Session.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

/// Sets the application's MIDI Network Session connection policy.
/// Passing `nil` disables network MIDI connections.
///
/// Supported on macOS 10.15+, macCatalyst 13.0+ and iOS 4.2+.
@available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
public func setMIDINetworkSession(policy: MIDIIONetworkConnectionPolicy?) {
    if let policy = policy {
        MIDINetworkSession.default().isEnabled = true
        MIDINetworkSession.default().connectionPolicy = policy.coreMIDIPolicy
    } else {
        MIDINetworkSession.default().isEnabled = false
        MIDINetworkSession.default().connectionPolicy = .noOne
    }
}

// MARK: - Notification Names

extension NSNotification.Name {
    /// a.k.a. `MIDINetworkNotificationSessionDidChange`
    ///
    /// > Core MIDI Documentation:
    /// > Indicates that other aspects of the session changed, such as the
    /// > connection list, connection policy, and so on.
    @_disfavoredOverload
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public static let midiNetworkSessionDidChange = NSNotification.Name(
        MIDINetworkNotificationSessionDidChange
    )
    
    /// a.k.a. `MIDINetworkNotificationContactsDidChange`
    ///
    /// > Core MIDI Documentation:
    /// > Indicates that the list of contacts changed.
    @_disfavoredOverload
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public static let midiNetworkContactsDidChange = NSNotification.Name(
        MIDINetworkNotificationContactsDidChange
    )
}

#endif
