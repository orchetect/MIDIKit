//
//  CoreMIDIAPIVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Describes the Core MIDI API used internally in all MIDIKit I/O operations.
public enum CoreMIDIAPIVersion {
    /// Legacy Core MIDI API first introduced in early versions of OSX.
    ///
    /// Internally using `MIDIPacketList` / `MIDIPacket`.
    case legacyCoreMIDI
    
    /// New Core MIDI API introduced in macOS 11, iOS 14, and macCatalyst 14.
    ///
    /// Internally using `MIDIEventList` / `MIDIEventPacket`.
    case newCoreMIDI(MIDIProtocolVersion)
}

extension CoreMIDIAPIVersion: Equatable { }

extension CoreMIDIAPIVersion: Hashable { }

extension CoreMIDIAPIVersion: Sendable { }

extension CoreMIDIAPIVersion {
    /// MIDI protocol version.
    public var midiProtocol: MIDIProtocolVersion {
        switch self {
        case .legacyCoreMIDI:
            return .midi1_0
    
        case let .newCoreMIDI(protocolVersion):
            return protocolVersion
        }
    }
}

extension CoreMIDIAPIVersion {
    /// Returns the recommended API version for the current platform (operating system).
    public static func bestForPlatform() -> Self {
        if #available(macOS 11, iOS 14, macCatalyst 14, *) {
            return .newCoreMIDI(.midi2_0)
    
        } else {
            return .legacyCoreMIDI
        }
    }
}

extension CoreMIDIAPIVersion {
    // swiftformat:options --ifdef indent
    
    /// Returns true if API version can be used on the current platform (operating system).
    public var isValidOnCurrentPlatform: Bool {
        switch self {
        case .legacyCoreMIDI:
            #if os(macOS)
                // Apple has deprecated legacy API but not yet obsoleted.
                // TODO: Once it becomes known what macOS version fully obsoletes it, update this:
                // if #available(macOS 14, *) { return false }
                return true
            #elseif os(iOS)
                // Apple has deprecated legacy API but not yet obsoleted.
                // TODO: Once it becomes known what iOS version fully obsoletes it, update this:
                // if #available(iOS 17, *) { return false }
                return true
            #elseif os(tvOS) || os(watchOS)
                // only new API is supported on tvOS and watchOS,
                // and only a tiny subset is available
                return false
            #else
                // future or unknown/unsupported platform
                return false
            #endif
    
        case .newCoreMIDI:
            if #available(macOS 11, iOS 14, macCatalyst 14, *) {
                return true
            }
    
            return false
        }
    }
}

extension CoreMIDIAPIVersion: CustomStringConvertible {
    public var description: String {
        switch self {
        case .legacyCoreMIDI:
            return "Legacy Core MIDI API"
    
        case .newCoreMIDI:
            return "New Core MIDI API (\(midiProtocol))"
        }
    }
}
