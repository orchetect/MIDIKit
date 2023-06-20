//
//  NotePressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public struct NotePressure: Equatable, Hashable {
        /// Note Number for which pressure is applied
        public var note: MIDINote
    
        /// Pressure Amount
        @AmountValidated
        public var amount: Amount
    
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        /// Channel Voice Message: Polyphonic Aftertouch
        /// (MIDI 1.0 / 2.0)
        ///
        /// Also known as:
        /// - Pro Tools: "Polyphonic Aftertouch"
        /// - Logic Pro: "Polyphonic Aftertouch"
        /// - Cubase: "Poly Pressure"
        public init(
            note: UInt7,
            amount: Amount,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = MIDINote(note)
            self.amount = amount
            self.channel = channel
            self.group = group
        }
    
        /// Channel Voice Message: Polyphonic Aftertouch
        /// (MIDI 1.0 / 2.0)
        ///
        /// Also known as:
        /// - Pro Tools: "Polyphonic Aftertouch"
        /// - Logic Pro: "Polyphonic Aftertouch"
        /// - Cubase: "Poly Pressure"
        public init(
            note: MIDINote,
            amount: Amount,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = note
            self.amount = amount
            self.channel = channel
            self.group = group
        }
    }
}

extension MIDIEvent {
    /// Channel Voice Message: Polyphonic Aftertouch
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    ///
    /// - Parameters:
    ///   - note: Note Number for which pressure is applied
    ///   - amount: Pressure Amount
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func notePressure(
        note: UInt7,
        amount: NotePressure.Amount,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .notePressure(
            .init(
                note: note,
                amount: amount,
                channel: channel,
                group: group
            )
        )
    }
    
    /// Channel Voice Message: Polyphonic Aftertouch
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    ///
    /// - Parameters:
    ///   - note: Note Number for which pressure is applied
    ///   - amount: Pressure Amount
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func notePressure(
        note: MIDINote,
        amount: NotePressure.Amount,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .notePressure(
            .init(
                note: note.number,
                amount: amount,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.NotePressure {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xA0 + channel.uInt8Value
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> (data1: UInt8, data2: UInt8) {
        (data1: note.number.uInt8Value, data2: amount.midi1Value.uInt8Value)
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        let dataBytes = midi1RawDataBytes()
        return [midi1RawStatusByte(), dataBytes.data1, dataBytes.data2]
    }
    
    private func umpMessageType(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> MIDIUMPMessageType {
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
    
        case ._2_0:
            return .midi2ChannelVoice
        }
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [UMPWord] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
            .uInt8Value
    
        switch midiProtocol {
        case ._1_0:
            let word = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                note.number.uInt8Value,
                amount.midi1Value.uInt8Value
            )
    
            return [word]
    
        case ._2_0:
            let word1 = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                note.number.uInt8Value,
                0x00
            ) // reserved
    
            let word2 = amount.midi2Value
    
            return [word1, word2]
        }
    }
}
