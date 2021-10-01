//
//  UnofficialBusSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Unofficial Bus Select (Status `0xF5`)
    ///
    /// "Some vendors have produced boxes with a single MIDI input, and multiple MIDI outputs. The Bus Select message specifies which of the outputs further data should be sent to. This is not an official message; the vendors in question should have used a SysEx command." -- [David Van Brink's MIDI Spec](https://www.cs.cmu.edu/~music/cmsip/readings/davids-midi-spec.htm)
    public struct UnofficialBusSelect: Equatable, Hashable {
        
        /// Bus Number
        public var bus: MIDI.UInt7 = 0
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Unofficial Bus Select (Status `0xF5`)
    ///
    /// "Some vendors have produced boxes with a single MIDI input, and multiple MIDI outputs. The Bus Select message specifies which of the outputs further data should be sent to. This is not an official message; the vendors in question should have used a SysEx command." -- [David Van Brink's MIDI Spec](https://www.cs.cmu.edu/~music/cmsip/readings/davids-midi-spec.htm)
    ///
    /// - Parameters:
    ///   - bus: Bus Number (0x00...0x7F)
    ///   - group: UMP Group (0x0...0xF)
    public static func unofficialBusSelect(bus: MIDI.UInt7,
                                           group: MIDI.UInt4 = 0x0) -> Self {
        
        .unofficialBusSelect(
            .init(bus: bus,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.UnofficialBusSelect {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF5, bus.uInt8Value]
        
    }
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF5,
                                bus.uInt8Value,
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
