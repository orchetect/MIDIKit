//
//  MIDI Network Session.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
    /// aka MIDINetworkNotificationSessionDidChange
    @_disfavoredOverload
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public static let midiNetworkSessionDidChange = NSNotification.Name(
        MIDINetworkNotificationSessionDidChange
    )
    
    /// aka MIDINetworkNotificationSessionDidChange
    @_disfavoredOverload
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public static let midiNetworkContactsDidChange = NSNotification.Name(
        MIDINetworkNotificationSessionDidChange
    )
}

#endif
