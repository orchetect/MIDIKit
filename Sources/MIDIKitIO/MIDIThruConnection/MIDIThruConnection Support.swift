//
//  MIDIThruConnection Support.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIThruConnection {
    /// Returns `true` if current platform supports MIDI play-thru connections (both persistent and
    /// non-persistent).
    /// See the header comments in MIDIThruConnection.swift for more details.
    internal static var isThruConnectionsSupported: Bool {
        if #available(macOS 13.0, /* iOS ???, */ *) {
            // Apple fixed the Core MIDI bug in macOS 13 Ventura
            return true
        } else if #available(macOS 11.0, /* iOS ???, */ *) {
            // Thru Connections is broken on macOS 11 Big Sur and macOS 12 Monterey
            // We can use a proxy to add support for non-persistent thru connections,
            // however we can't help that persistent connections are broken.
            return false
        } else {
            // macOS 10.15 Catalina and older
            return true
        }
    }
    
    internal static let persistentThruNotSupportedError: MIDIIOError = .notSupported(
        persistentThruNotSupportedErrorReason
    )
    
    internal static let persistentThruNotSupportedErrorReason: String =
        "Persistent MIDI Thru Connections cannot be created on macOS Big Sur or Monterey due to a Core MIDI bug. Consider using a non-persistent thru connection instead."
}

#endif
