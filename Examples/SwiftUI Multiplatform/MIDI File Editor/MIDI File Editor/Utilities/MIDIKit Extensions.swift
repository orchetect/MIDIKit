//
//  MIDIKit Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import MIDIKitSMF
import SwiftUI

extension MIDIFileEventType {
    /// Returns an event type name suitable for UI.
    public var name: String {
        switch self {
        case .cc:                 "CC"
        case .channelPrefix:      "Channel Prefix"
        case .keySignature:       "Key Signature"
        case .noteOff:            "Note Off"
        case .noteOn:             "Note On"
        case .notePressure:       "Note Pressure"
        case .pitchBend:          "Pitch Bend"
        case .portPrefix:         "Port Prefix"
        case .pressure:           "Pressure"
        case .programChange:      "Program Change"
        case .rpn:                "RPN"
        case .nrpn:               "NRPN"
        case .sequenceNumber:     "Sequence Number"
        case .sequencerSpecific:  "Sequencer Specific"
        case .smpteOffset:        "SMPTE Offset"
        case .sysEx7:             "SysEx 7"
        case .tempo:              "Tempo"
        case .text:               "Text"
        case .timeSignature:      "Time Signature"
        case .universalSysEx7:    "Universal SysEx 7"
        case .unrecognizedMeta:   "Unrecognized Meta"
        case .xmfPatchTypePrefix: "XMF Patch Type Prefix"
        }
    }
}

extension MIDI1FileFormat {
    /// Returns a format name suitable for UI.
    var name: String {
        switch self {
        case .singleTrack: "Single Track"
        case .multipleTracksSynchronous: "Multiple Tracks (Sync)"
        case .multipleTracksAsynchronous: "Multiple Tracks (Async)"
        }
    }
}

extension MusicalMIDI1File.AnyChunk {
    /// Returns a track name suitable for UI.
    var name: String {
        switch self {
        case let .track(track): track.name
        case let .undefined(chunk): chunk.name
        }
    }
    
    /// Returns a track editor title suitable for UI.
    var title: String {
        switch self {
        case let .track(track):
            "\(track.name) (\(track.events.count) events)"
        case let .undefined(chunk):
            chunk.name
        }
    }
    
    /// Returns an image suitable for UI.
    var image: Image {
        switch self {
        case let .track(track): track.image
        case let .undefined(chunk): chunk.image
        }
    }
    
    /// Returns a label suitable for UI.
    var label: Label<Text, Image> {
        switch self {
        case let .track(track): track.label
        case let .undefined(chunk): chunk.label
        }
    }
    
    /// Returns track event count suitable for UI if the chunk is a track.
    var trackEventCount: Int? {
        switch self {
        case let .track(track): track.events.count
        case .undefined(_): nil
        }
    }
}


extension MusicalMIDI1File.Track {
    /// Returns a track name suitable for UI.
    var name: String {
        initialTrackOrSequenceName
            ?? "Untitled Track"
    }
    
    /// Returns an image suitable for UI.
    var image: Image {
        Image(systemName: "music.note.list")
    }
    
    /// Returns a label suitable for UI.
    var label: Label<Text, Image> {
        Label {
            Text(name)
        } icon: {
            image
        }
    }
}

extension MusicalMIDI1File.Track.Event {
    /// Returns the MIDI file event unwrapped as a `Text` event if it is a text event.
    var textEvent: MIDIFileEvent.Text? {
        guard case let .text(text) = event else { return nil }
        return text
    }
}

extension MusicalMIDI1File.UndefinedChunk {
    /// Returns a chunk name suitable for UI.
    var name: String {
        "Undefined (\(identifier.string))"
    }
    
    /// Returns an image suitable for UI.
    var image: Image {
        Image(systemName: "questionmark")
    }
    
    /// Returns a label suitable for UI.
    var label: Label<Text, Image> {
        Label {
            Text(name)
        } icon: {
            image
        }
    }
}
