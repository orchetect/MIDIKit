//
//  Event Text.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Text

extension MIDIFileEvent {
    public struct Text: Equatable, Hashable {
        /// Type of text event.
        public var textType: EventType = .text
        
        /// Text content.
        ///
        /// ASCII text only. If extended characters or encodings are used, it will be converted to ASCII before encoding into the MIDI file.
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

extension MIDIFileEvent.Text: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .text
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        let result = try Self.initFrom(rawBuffer: rawBytes).newEvent
        
        textType = result.textType
        text = result.text
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 01 length text
        
        let stringData = text.data(using: .nonLossyASCII) ?? Data()
        
        return MIDIFile.kTextEventHeaders[textType]! +
            // length
            MIDIFile.encodeVariableLengthValue(stringData.count) +
            // text
            stringData
    }

    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        try Self.initFrom(rawBuffer: rawBuffer.bytes)
    }

    internal static func initFrom(
        rawBuffer rawBytes: [Byte]
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }

        // 2-byte preambles
        guard let textTypeMatch = MIDIFile.kTextEventHeaders
            .first(where: { rawBytes.starts(with: $0.value) })
        else {
            throw MIDIFile.DecodeError.malformed(
                "Event is not a textual event."
            )
        }

        guard let length = MIDIFile.decodeVariableLengthValue(from: Array(rawBytes[2...])) else {
            throw MIDIFile.DecodeError.malformed(
                "Could not extract variable length."
            )
        }

        let expectedFullLength = 2 + length.byteLength + length.value

        guard rawBytes.count >= expectedFullLength else {
            throw MIDIFile.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }

        let byteSlice = Array(rawBytes[(2 + length.byteLength) ..< expectedFullLength]).data

        let formedText: String

        if let getText = byteSlice
            .toString(using: .nonLossyASCII)?
            .convertToASCII()
        {
            formedText = getText

        } else if let getText = byteSlice
            .toString(using: .ascii)?
            .convertToASCII()
        {
            formedText = getText

        } else if let getText = byteSlice
            .toString(using: .utf8)?
            .convertToASCII()
        {
            formedText = getText

        } else {
            throw MIDIFile.DecodeError.malformed(
                "Could not decode ASCII string. It may contain unsupported characters"
            )
        }

        let newInstance = Self(
            type: textTypeMatch.key,
            string: formedText
        )

        return (
            newEvent: newInstance,
            bufferLength: expectedFullLength
        )
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
