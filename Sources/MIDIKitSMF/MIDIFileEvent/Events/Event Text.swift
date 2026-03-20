//
//  Event Text.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - Text

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Text event.
    /// Includes copyright, marker, cue point, track/sequence name, instrument name, generic text,
    /// program name, device name, or lyric.
    ///
    /// Text is restricted to ASCII characters only. If extended characters or other encodings are used, it
    /// will be converted to ASCII lossily before encoding into the MIDI file.
    public struct Text {
        /// Type of text event.
        public var textType: EventType = .text
        
        /// Text content.
        ///
        /// ASCII text only. If extended characters or encodings are used, it will be converted to
        /// ASCII before encoding into the MIDI file.
        ///
        /// (Arbitrary limit imposed: truncates at 65,536 characters long.)
        public var text: String = "" {
            didSet {
                if oldValue != text { text_Validate() }
            }
        }

        private mutating func text_Validate() {
            if text.count > 65536 {
                text = text.prefix(65536).convertToASCII()
            }
        }

        // MARK: - Init

        public init() { }

        public init(
            type: EventType,
            string: String
        ) {
            textType = type
            text = string
            
            text_Validate()
        }

        // MARK: - Init (types)

        public init(copyright: String) {
            self.init(type: .copyright, string: copyright)
        }

        public init(marker: String) {
            self.init(type: .marker, string: marker)
        }

        public init(cuePoint: String) {
            self.init(type: .cuePoint, string: cuePoint)
        }

        public init(trackOrSequenceName: String) {
            self.init(type: .trackOrSequenceName, string: trackOrSequenceName)
        }

        public init(instrumentName: String) {
            self.init(type: .instrumentName, string: instrumentName)
        }

        public init(text: String) {
            self.init(type: .text, string: text)
        }

        public init(programName: String) {
            self.init(type: .programName, string: programName)
        }

        public init(deviceName: String) {
            self.init(type: .deviceName, string: deviceName)
        }

        public init(lyric: String) {
            self.init(type: .lyric, string: lyric)
        }
    }
}

extension MIDIFileEvent.Text: Equatable { }

extension MIDIFileEvent.Text: Hashable { }

extension MIDIFileEvent.Text: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Text event.
    /// Includes copyright, marker, cue point, track/sequence name, instrument name, generic text,
    /// program name, device name, or lyric.
    ///
    /// Text is restricted to ASCII format only. If extended characters or encodings are used, it
    /// will be converted to ASCII lossily before encoding into the MIDI file.
    public static func text(
        delta: DeltaTime = .none,
        type: Text.EventType,
        string: String
    ) -> Self {
        .text(
            delta: delta,
            event: .init(
                type: type,
                string: string
            )
        )
    }
}

// MARK: - Encoding

extension MIDIFileEvent.Text: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .text(delta: delta, event: self)
    }
    
    public static let smfEventType: MIDIFileEvent.EventType = .text
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        let result = try Self.initFrom(stream: rawBytes).newEvent
        
        textType = result.textType
        text = result.text
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        return try initFrom(stream: stream)
    }

    static func initFrom(
        stream rawBytes: some DataProtocol
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        guard rawBytes.count >= 3 else {
            throw .malformed("Not enough bytes.")
        }
        
        return try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) in
            // 2-byte preambles
            let headerBytes = try parser.toMIDIFileDecodeError(
                malformedReason: "Missing event header bytes.",
                try parser.read(bytes: 2)
            )
            guard let textTypeMatch = EventType(midi1SMFRawBytes: headerBytes)
            else {
                throw .malformed(
                    "Event is not a text event."
                )
            }
            
            let length = try parser.decodeVariableLengthValue()
            
            guard parser.remainingByteCount >= length else {
                throw .malformed(
                    "Fewer bytes are available (\(parser.remainingByteCount)) than are expected (\(length))."
                )
            }
            
            let byteSlice = try parser.toMIDIFileDecodeError(
                malformedReason: "Not enough bytes.",
                try parser.read(bytes: length)
            )
            
            let formedText = byteSlice.asciiDataToStringLossy() // .removing(.newlines)
            
            let newInstance = Self(
                type: textTypeMatch,
                string: formedText
            )
            
            return (
                newEvent: newInstance,
                bufferLength: parser.readOffset
            )
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 01 length text
        
        let stringData = text.data(using: .nonLossyASCII) ?? Data()
        
        return textType.prefixBytes
            // length
            + MIDIFile.encodeVariableLengthValue(stringData.count, as: D.self)
            // text
            + stringData
    }
    
    public var smfDescription: String {
        "\(textType): " + text.quoted
    }
    
    public var smfDebugDescription: String {
        "Text(" + smfDescription + ")"
    }
}

// MARK: - EventType

extension MIDIFileEvent.Text {
    /// Specialized text-based MIDI file track events.
    public enum EventType: String {
        // MARK: Track Events - First track
        
        // MARK: ... head of track
        
        /// Copyright text.
        /// If present, this event should only exist at the start of the first track.
        case copyright
        
        // MARK: ... anywhere in track
        
        /// Marker text event.
        /// If present, this event can appear anywhere within a track, but should only exist in the first track.
        case marker
        
        /// Cue point text event.
        /// If present, this event can appear anywhere within a track, but should only exist in the first track.
        case cuePoint

        // MARK: Track Events - Any track
        
        // MARK: ... head of track
        
        /// Track or sequence name text event.
        /// If present, this event can be used in one or more tracks, but should only exist at the start of each track.
        case trackOrSequenceName
        
        /// Instrument name text event.
        /// If present, this event can be used in one or more tracks, but should only exist at the start of each track.
        case instrumentName
        
        /// Generic text event.
        /// If present, this event can be used in one or more tracks, but should only exist at the start of each track.
        case text
        
        // MARK: ... anywhere in track
        
        /// Program name text event.
        /// This event can be used as often as desired anywhere within any track(s).
        case programName
        
        /// Device name text event.
        /// This event can be used as often as desired anywhere within any track(s).
        case deviceName
        
        /// Lyric text event.
        /// This event can be used as often as desired anywhere within any track(s).
        case lyric
    }
}

extension MIDIFileEvent.Text.EventType: Equatable { }

extension MIDIFileEvent.Text.EventType: Hashable { }

extension MIDIFileEvent.Text.EventType: CaseIterable { }

extension MIDIFileEvent.Text.EventType: Sendable { }

// MARK: - EventType init

extension MIDIFileEvent.Text.EventType {
    public init?(midi1SMFRawBytes rawBytes: some DataProtocol) {
        guard let match = Self.allCases.first(where: {
            $0.prefixBytes.elementsEqual(rawBytes)
        }) else { return nil }
        self = match
    }
}

// MARK: - TextEventType Static

extension MIDIFileEvent.Text.EventType {
    /// The prefix bytes that define the start of the event.
    public var prefixBytes: [UInt8] {
        switch self {
        case .text:                [0xFF, 0x01]
        case .copyright:           [0xFF, 0x02]
        case .trackOrSequenceName: [0xFF, 0x03]
        case .instrumentName:      [0xFF, 0x04]
        case .lyric:               [0xFF, 0x05]
        case .marker:              [0xFF, 0x06]
        case .cuePoint:            [0xFF, 0x07]
        case .programName:         [0xFF, 0x08]
        case .deviceName:          [0xFF, 0x09]
        }
    }
}
