//
//  MIDIProtocolVersion Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

extension MIDIProtocolVersion {
    /// Initializes from the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    init(_ coreMIDIProtocol: CoreMIDI.MIDIProtocolID) {
        switch coreMIDIProtocol {
        case ._1_0:
            self = .midi1_0
    
        case ._2_0:
            self = .midi2_0
    
        @unknown default:
            self = .midi2_0
        }
    }
    
    /// Returns the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    var coreMIDIProtocol: CoreMIDI.MIDIProtocolID {
        switch self {
        case .midi1_0:
            return ._1_0
    
        case .midi2_0:
            return ._2_0
        }
    }
}
