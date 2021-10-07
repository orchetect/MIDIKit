//
//  ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Program Change
    ///
    /// This event can optionally contain a Bank Select message. In MIDI 1.0, these will be transmit as separate messages. In MIDI 2.0, this information is all contained within a single packet.
    ///
    /// - remark: MIDI 2.0 Spec:
    ///
    /// "In the MIDI 2.0 Protocol, this message combines the MIDI 1.0 Protocol's separate Program Change and Bank Select messages into a single, unified message; by contrast, the MIDI 1.0 Protocol mechanism for selecting Banks and Programs requires sending three MIDI separate 1.0 Messages. The MIDI 1.0 Protocol’s existing 16,384 Banks, each with 128 Programs, are preserved and translate directly to the MIDI 2.0 Protocol."
    public struct ProgramChange: Equatable, Hashable {
        
        /// Program Number
        public var program: MIDI.UInt7
        
        /// Bank Select
        ///
        /// When receiving a Program Change event, if a bank number is present then the Bank Select event should be processed prior to the Program Change event.
        ///
        /// # MIDI 1.0
        ///
        /// For MIDI 1.0, this results in 3 messages being transmitted in this order:
        ///  - Bank Select MSB (CC 0)
        ///  - Bank Select LSB (CC 32)
        ///  - Program Change
        ///
        /// Bank numbers in MIDI 1.0 are expressed as two 7-bit bytes (MSB/"coarse" and LSB/"fine").
        ///
        /// In some implementations, manufacturers have chosen to only use the MSB/"coarse" adjust (CC 0) switch banks since many devices don't have more than 128 banks (of 128 programs each).
        ///
        /// # MIDI 2.0
        ///
        /// For MIDI 2.0, Program Change and Bank Select information is all contained within a single UMP (Universal MIDI Packet).
        ///
        /// Bank numbers in MIDI 2.0 are expressed by combining the two MIDI 1.0 7-bit bytes into a 14-bit number (0...16383). They correlate exactly to MIDI 1.0 bank numbers.
        public var bank: Bank
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Program Change
    ///
    /// - Parameters:
    ///   - program: Program Number
    ///   - bank: Bank Select operation to occur first
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func programChange(program: MIDI.UInt7,
                                     bank: ProgramChange.Bank = .noBankSelect,
                                     channel: MIDI.UInt4,
                                     group: MIDI.UInt4 = 0x0) -> Self {
        
        .programChange(
            .init(program: program,
                  bank: bank,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.ProgramChange {
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        let programChangeMessage = [0xC0 + channel.uInt8Value,
                                    program.uInt8Value]
        
        switch bank {
        case .noBankSelect:
            return programChangeMessage
            
        case .bankSelect(let bankNumber):
            
            // Assemble 3 messages in order:
            // - Bank Select MSB (CC 0)
            // - Bank Select LSB (CC 32)
            // - Program Change
            
            return [0xB0 + channel.uInt8Value,
                    0x00,
                    bankNumber.midiUInt7Pair.msb.uInt8Value]
                + [0xB0 + channel.uInt8Value,
                   0x32,
                   bankNumber.midiUInt7Pair.lsb.uInt8Value]
                + programChangeMessage
            
        }
        
    }
    
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        switch midiProtocol {
        case ._1_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xC0 + channel.uInt8Value,
                                    program.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case ._2_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            #warning("> TODO: umpRawWords() needs coding")
            _ = mtAndGroup
            
            //let word1 = MIDI.UMPWord()
            
            return []
            
        }
        
    }
    
}
