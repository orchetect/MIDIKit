//
//  UniversalMIDIPacket MessageType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Packet.UniversalPacketData {
    
    public enum MessageType: MIDI.Nibble, CaseIterable {
        
        case utility                 = 0x0
        case systemRealTimeAndCommon = 0x1
        case midi1ChannelVoice       = 0x2
        case data64bit               = 0x3
        case midi2ChannelVoice       = 0x4
        case data128bit              = 0x5
        
        // 0x6...0xF are reserved as of MIDI 2.0 spec
        
    }
    
    public enum SysExStatusField: MIDI.Nibble, CaseIterable {
        
        /// Complete System Exclusive Message in one UMP System Exclusive.
        case complete = 0x0
        
        /// System Exclusive Start UMP.
        case start = 0x1
        
        /// System Exclusive Continue UMP.
        /// There might be multiple Continue UMPs in a single message.
        case `continue` = 0x2
        
        /// System Exclusive End UMP.
        case end = 0x3
        
        // 0x4... are unused/reserved
        
    }
    
}
