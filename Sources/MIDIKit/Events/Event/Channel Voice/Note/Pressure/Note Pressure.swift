//
//  Note Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Polyphonic Aftertouch
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public struct Pressure: Equatable, Hashable {
        
        /// Note Number for which pressure is applied
        public var note: MIDI.UInt7
        
        /// Pressure Amount
        @AmountValidated
        public var amount: Amount
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        /// Channel Voice Message: Polyphonic Aftertouch
        /// (MIDI 1.0 / 2.0)
        ///
        /// Also known as:
        /// - Pro Tools: "Polyphonic Aftertouch"
        /// - Logic Pro: "Polyphonic Aftertouch"
        /// - Cubase: "Poly Pressure"
        public init(note: MIDI.UInt7,
                    amount: Amount,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note
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
        public init(note: MIDI.Note,
                    amount: Amount,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note.number
            self.amount = amount
            self.channel = channel
            self.group = group
            
        }
        
    }
    
}

extension MIDI.Event {
    
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
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func notePressure(note: MIDI.UInt7,
                                    amount: Note.Pressure.Amount,
                                    channel: MIDI.UInt4,
                                    group: MIDI.UInt4 = 0x0) -> Self {
        
        .notePressure(
            .init(note: note,
                  amount: amount,
                  channel: channel,
                  group: group)
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
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func notePressure(note: MIDI.Note,
                                    amount: Note.Pressure.Amount,
                                    channel: MIDI.UInt4,
                                    group: MIDI.UInt4 = 0x0) -> Self {
        
        .notePressure(
            .init(note: note.number,
                  amount: amount,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.Pressure {
    
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xA0 + channel.uInt8Value,
         note.uInt8Value,
         amount.midi1Value.uInt8Value]
        
    }
    
    @inline(__always)
    private func umpMessageType(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> MIDI.Packet.UniversalPacketData.MessageType {
        
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
            
        case ._2_0:
            return .midi2ChannelVoice
        }
        
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xA0 + channel.uInt8Value,
                                    note.uInt8Value,
                                    amount.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0xA0 + channel.uInt8Value,
                                     note.uInt8Value,
                                     0x00) // reserved
            
            let word2 = amount.midi2Value
            
            return [word1, word2]
            
        }
        
    }
    
}
