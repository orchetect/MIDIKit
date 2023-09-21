//
//  Event Text.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

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
    /// Text is restricted to ASCII format only. If extended characters or encodings are used, it
    /// will be converted to ASCII lossily before encoding into the MIDI file.
    public struct Text: Equatable, Hashable {
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

extension MIDIFileEvent.Text: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .text
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        let result = try Self.initFrom(stream: rawBytes).newEvent
        
        textType = result.textType
        text = result.text
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 01 length text
        
        let stringData = text.data(using: .nonLossyASCII) ?? Data()
        
        return MIDIFile.kTextEventHeaders[textType]! +
            // length
            MIDIFile.encodeVariableLengthValue(stringData.count) +
            // text
            stringData
    }

    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        try initFrom(stream: stream)
    }

    static func initFrom(
        stream rawBytes: some DataProtocol
    ) throws -> StreamDecodeResult {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        return try rawBytes.withDataReader { dataReader in
            // 2-byte preambles
            let headerBytes = try dataReader.read(bytes: 2)
            guard let textTypeMatch = MIDIFile.kTextEventHeaders
                .first(where: { headerBytes.elementsEqual($0.value) })
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Event is not a textual event."
                )
            }
            
            let readAheadCount = dataReader.remainingByteCount.clamped(to: 1 ... 4)
            let bodyBytes = try dataReader.nonAdvancingRead(bytes: readAheadCount)
            guard let length = MIDIFile.decodeVariableLengthValue(from: bodyBytes)
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not extract variable length."
                )
            }
            dataReader.advanceBy(length.byteLength)
            
            guard dataReader.remainingByteCount >= length.value else {
                throw MIDIFile.DecodeError.malformed(
                    "Fewer bytes are available (\(dataReader.remainingByteCount)) than are expected (\(length.value))."
                )
            }
            
            let byteSlice = try dataReader.read(bytes: length.value)
            
            let formedText = byteSlice.asciiDataToStringLossy() // .removing(.newlines)
            
            let newInstance = Self(
                type: textTypeMatch.key,
                string: formedText
            )
            
            return (
                newEvent: newInstance,
                bufferLength: dataReader.readOffset
            )
        }
    }
    
    public var smfDescription: String {
        "\(textType): " + text.quoted
    }
    
    public var smfDebugDescription: String {
        "Text(" + smfDescription + ")"
    }
}

// MARK: - TextEventType

extension MIDIFileEvent.Text {
    public enum EventType: String, CaseIterable, Equatable, Hashable {
        // MARK: Track Events - First track
        // MARK: ... head of track
        case copyright
        // MARK: ... anywhere in track
        case marker
        case cuePoint

        // MARK: Track Events - Any track
        // MARK: ... head of track
        case trackOrSequenceName
        case instrumentName
        case text
        // MARK: ... anywhere in track
        case programName
        case deviceName
        case lyric
    }
}
