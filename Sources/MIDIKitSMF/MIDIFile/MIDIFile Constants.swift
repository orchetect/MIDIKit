//
//  MIDIFile Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - Global Constants

extension MIDIFile {
    static let kChunkMIDITrackEnd: [UInt8] = [0xFF, 0x2F, 0x00]
    
    static let kEventHeaders: [MIDIFileEventType: [UInt8]] = [
        .sequenceNumber:     [0xFF, 0x00, 0x02],
        .channelPrefix:      [0xFF, 0x20, 0x01],
        .portPrefix:         [0xFF, 0x21, 0x01],
        .tempo:              [0xFF, 0x51, 0x03],
        .smpteOffset:        [0xFF, 0x54, 0x05],
        .timeSignature:      [0xFF, 0x58, 0x04],
        .keySignature:       [0xFF, 0x59, 0x02],
        .xmfPatchTypePrefix: [0xFF, 0x60],
        .sequencerSpecific:  [0xFF, 0x7F]
    ]
    
    static let kTextEventHeaders: [MIDIFileEvent.Text.EventType: [UInt8]] = [
        .text:                [0xFF, 0x01],
        .copyright:           [0xFF, 0x02],
        .trackOrSequenceName: [0xFF, 0x03],
        .instrumentName:      [0xFF, 0x04],
        .lyric:               [0xFF, 0x05],
        .marker:              [0xFF, 0x06],
        .cuePoint:            [0xFF, 0x07],
        .programName:         [0xFF, 0x08],
        .deviceName:          [0xFF, 0x09]
    ]
}
