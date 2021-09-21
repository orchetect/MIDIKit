//
//  CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Controller Change (CC) (Status `0xB`)
    public struct CC: Equatable, Hashable {
        
        public var controller: Controller
        
        public var value: MIDI.UInt7
        
        public var channel: MIDI.UInt4
        
        public var group: MIDI.UInt4 = 0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Controller Change (CC) (Status `0xB`)
    public static func cc(_ controller: CC.Controller,
                          value: MIDI.UInt7,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0) -> Self {
        
        .cc(
            .init(controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Controller Change (CC) (Status `0xB`)
    public static func cc(_ controller: MIDI.UInt7,
                          value: MIDI.UInt7,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0) -> Self {
        
        .cc(
            .init(controller: .init(number: controller),
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.CC {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xB0 + channel.uInt8Value,
         controller.number.uInt8Value,
         value.uInt8Value]
        
    }
    
}
