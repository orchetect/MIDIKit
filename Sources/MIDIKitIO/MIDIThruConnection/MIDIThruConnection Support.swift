//
//  MIDIThruConnection Support.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIThruConnection {
    /// Convenience method to throw an error on affected systems where the Core MIDI thru connection bug
    /// exists.
    /// See the header comments in MIDIThruConnection.swift for more details.
    internal static func verifyPlatformSupport(for lifecycle: MIDIThruConnection.Lifecycle) throws {
        try verifyPlatformSupport(persistent: lifecycle.isPersistent)
    }
    
    /// Convenience method to throw an error on affected systems where the Core MIDI thru connection bug
    /// exists.
    /// See the header comments in MIDIThruConnection.swift for more details.
    internal static func verifyPlatformSupport(persistent: Bool) throws {
        if persistent {
            guard isNonPersistentThruConnectionsSupported else {
                throw midiThruConnectionsNotSupportedOnCurrentPlatformError
            }
        } else {
            return
        }
    }
    
    /// Returns `true` if current platform supports MIDI play-thru connections.
    /// See the header comments in MIDIThruConnection.swift for more details.
    internal static var isNonPersistentThruConnectionsSupported: Bool {
        if #available(macOS 13.0, /* iOS ???, */ *) {
            // Apple fixed the Core MIDI bug in macOS 13 Ventura
            return true
        } else if #available(macOS 11.0, /* iOS ???, */ *) {
            // Non-Persistent Thru Connections using Swift Core MIDI bridging is broken
            // on macOS 11 Big Sur and macOS 12 Monterey
            return false
        } else {
            // macOS 10.15 Catalina and older
            return true
        }
    }
    
    internal static let midiThruConnectionsNotSupportedOnCurrentPlatformError: MIDIIOError = .notSupported(
        midiThruConnectionsNotSupportedOnCurrentPlatformErrorReason
    )
    
    internal static let midiThruConnectionsNotSupportedOnCurrentPlatformErrorReason: String =
    "Non-Persistent MIDI Thru Connections are not supported on macOS Big Sur or Monterey due to a Core MIDI bug. It is still possible, but requires a Objective-C workaround and MIDIKit is built to be pure Swift."
}

#endif
