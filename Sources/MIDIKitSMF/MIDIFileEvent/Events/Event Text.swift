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
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
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

    public static func initFrom<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D
    ) throws -> StreamDecodeResult {
        try Self.initFrom(stream: stream)
    }

    internal static func initFrom<D: DataProtocol>(
        stream rawBytes: D
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
            
            let bodyBytes = try dataReader.nonAdvancingRead()
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
            
            guard let formedText = byteSlice.asciiDataToString() else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not decode ASCII string. It may contain unsupported characters."
                )
            }
            
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
