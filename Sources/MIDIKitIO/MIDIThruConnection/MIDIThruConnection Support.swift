//
//  MIDIThruConnection Support.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIThruConnection {
    /// Returns `true` if current platform supports non-persistent MIDI play-thru connections.
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
}

#endif
