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
        if #available(macOS 13.0, iOS 16.0, *) {
            // Apple fixed the Core MIDI bug in macOS 13.0 and iOS 16.0
            return true
        } else if #available(macOS 11.0, iOS 14.0, *) {
            // Thru Connections is broken on macOS 11 & 12 and iOS 14 & 15
            // We can use a proxy to add support for non-persistent thru connections,
            // however we can't help that persistent connections are broken.
            return false
        } else {
            // macOS 10.15.x Catalina and older, or iOS 13.x or older
            return true
        }
    }
    
    internal static let persistentThruNotSupportedError: MIDIIOError = .notSupported(
        persistentThruNotSupportedErrorReason
    )
    
    internal static let persistentThruNotSupportedErrorReason: String =
        "Persistent MIDI Thru Connections cannot be created on macOS 11 & 12 and iOS 14 & 15 due to a Core MIDI bug. Consider using a non-persistent thru connection instead."
}

#endif
