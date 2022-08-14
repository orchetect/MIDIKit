//
//  ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Program Change
    /// (MIDI 1.0 / 2.0)
    ///
    /// This event can optionally contain a Bank Select message. In MIDI 1.0, these will be transmit as separate messages. In MIDI 2.0, this information is all contained within a single packet. See the `bank` property for more info.
    ///
    /// - remark: MIDI 2.0 Spec:
    ///
    /// "In the MIDI 2.0 Protocol, this message combines the MIDI 1.0 Protocol's separate Program Change and Bank Select messages into a single, unified message; by contrast, the MIDI 1.0 Protocol mechanism for selecting Banks and Programs requires sending three MIDI separate 1.0 Messages. The MIDI 1.0 Protocol’s existing 16,384 Banks, each with 128 Programs, are preserved and translate directly to the MIDI 2.0 Protocol."
    public struct ProgramChange: Equatable, Hashable {
        /// Program Number
        public var program: UInt7
        
        /// Bank Select
        /// (MIDI 1.0 / 2.0)
        ///
        /// When receiving a Program Change event, if a bank number is present then the Bank Select event should be processed prior to the Program Change event.
        ///
        /// **MIDI 1.0**
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
        /// **MIDI 2.0**
        ///
        /// For MIDI 2.0, Program Change and Bank Select information is all contained within a single UMP (Universal MIDI Packet).
        ///
        /// Bank numbers in MIDI 2.0 are expressed by combining the two MIDI 1.0 7-bit bytes into a 14-bit number (0...16383). They correlate exactly to MIDI 1.0 bank numbers.
        public var bank: Bank
        
        /// Channel Number (0x0...0xF)
        public var channel: UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: UInt4 = 0x0
        
        /// Channel Voice Message: Program Change
        /// (MIDI 1.0 / 2.0)
        ///
        /// - Parameters:
        ///   - program: Program Number
        ///   - bank: Optional Bank Select operation to occur first
        ///   - channel: Channel Number (0x0...0xF)
        ///   - group: UMP Group (0x0...0xF)
        public init(
            program: UInt7,
            bank: Bank,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.program = program
            self.bank = bank
            self.channel = channel
            self.group = group
        }
    }
    
    /// Channel Voice Message: Program Change
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - program: Program Number
    ///   - bank: Optional Bank Select operation to occur first
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func programChange(
        program: UInt7,
        bank: ProgramChange.Bank = .noBankSelect,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .programChange(
            .init(
                program: program,
                bank: bank,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.ProgramChange {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes() -> [Byte] {
        let programChangeMessage = [
            0xC0 + channel.uInt8Value,
            program.uInt8Value
        ]
        
        switch bank {
        case .noBankSelect:
            return programChangeMessage
            
        case let .bankSelect(bankNumber):
            // Assemble 3 messages in order:
            // - Bank Select MSB (CC 0)
            // - Bank Select LSB (CC 32)
            // - Program Change
            
            return [
                0xB0 + channel.uInt8Value,
                0x00,
                bankNumber.midiUInt7Pair.msb.uInt8Value
            ]
                + [
                    0xB0 + channel.uInt8Value,
                    0x32,
                    bankNumber.midiUInt7Pair.lsb.uInt8Value
                ]
                + programChangeMessage
        }
    }
    
    @inline(__always)
    private func umpMessageType(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> UniversalMIDIPacketData.MessageType {
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
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [UMPWord] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = UMPWord(
                mtAndGroup,
                0xC0 + channel.uInt8Value,
                program.uInt8Value,
                0x00
            ) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case ._2_0:
            let optionFlags: Byte
            let bankMSB: Byte
            let bankLSB: Byte
            
            switch bank {
            case .noBankSelect:
                optionFlags = 0b0000_0000
                bankMSB = 0x00
                bankLSB = 0x00
                
            case let .bankSelect(bankUInt14):
                optionFlags = 0b0000_0001
                let bytePair = bankUInt14.bytePair
                bankMSB = bytePair.msb
                bankLSB = bytePair.lsb
            }
            
            let word1 = UMPWord(
                mtAndGroup,
                0xC0 + channel.uInt8Value,
                0x00, // reserved
                optionFlags
            )
            
            let word2 = UMPWord(
                program.uInt8Value,
                0x00, // reserved
                bankMSB,
                bankLSB
            )
            
            return [word1, word2]
        }
    }
}
