//
//  Note Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Polyphonic Aftertouch
    /// (MIDI 1.0 / 2.0)
    ///
    /// DAWs are known to use variations on the terminology:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public struct Pressure: Equatable, Hashable {
        
        /// Note Number for which pressure is applied
        public var note: MIDI.UInt7
        
        /// Pressure Amount
        public var amount: Amount
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Polyphonic Aftertouch
    /// (MIDI 1.0 / 2.0)
    /// 
    /// DAWs are known to use variations on the terminology:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    ///
    /// - Parameters:
    ///   - note: Note Number for which pressure is applied
    ///   - amount: Pressure Amount
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
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
    
}

extension MIDI.Event.Note.Pressure {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xA0 + channel.uInt8Value,
         note.uInt8Value,
         amount.midi1Value.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xA0 + channel.uInt8Value,
                                note.uInt8Value,
                                amount.midi1Value.uInt8Value)
        
        return [word]
        
    }
    
}
