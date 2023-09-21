//
//  MIDIProtocolVersion Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

@_implementationOnly import CoreMIDI

extension MIDIProtocolVersion {
    /// Initializes from the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    init(_ coreMIDIProtocol: CoreMIDI.MIDIProtocolID) {
        switch coreMIDIProtocol {
        case ._1_0:
            self = ._1_0
    
        case ._2_0:
            self = ._2_0
    
        @unknown default:
            self = ._2_0
        }
    }
    
    /// Returns the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    var coreMIDIProtocol: CoreMIDI.MIDIProtocolID {
        switch self {
        case ._1_0:
            return ._1_0
    
        case ._2_0:
            return ._2_0
        }
    }
}
