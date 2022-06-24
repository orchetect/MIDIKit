//
//  PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Pitch Bend
    public struct PitchBend: Equatable, Hashable {
        
        /// Value
        @ValueValidated
        public var value: Value
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
    }
    
    /// Channel Voice Message: Pitch Bend
    ///
    /// - Parameters:
    ///   - value: 14-bit Value (0...16383) where midpoint is 8192
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func pitchBend(value: PitchBend.Value,
                                 channel: MIDI.UInt4,
                                 group: MIDI.UInt4 = 0x0) -> Self {
        
        .pitchBend(
            .init(value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.PitchBend {
    
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        let bytePair = value.midi1Value.bytePair
        
        return [0xE0 + channel.uInt8Value,
                bytePair.lsb,
                bytePair.msb]
        
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
            let bytePair = value.midi1Value.bytePair
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xE0 + channel.uInt8Value,
                                    bytePair.lsb,
                                    bytePair.msb)
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0xE0 + channel.uInt8Value,
                                     0x00, // reserved
                                     0x00) // reserved
            
            let word2 = value.midi2Value
            
            return [word1, word2]
            
        }
        
    }
    
}
