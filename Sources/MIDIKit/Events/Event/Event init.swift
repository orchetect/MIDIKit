//
//  Event init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Static nested enum inits

extension MIDI.Event {
    
    /// Channel Voice Message: Controller Change (CC) (Status `0xB`)
    public static func cc(controller: CC,
                          value: MIDI.UInt7,
                          channel: MIDI.UInt4) -> Self {
        
        .cc(controller: controller.controller,
            value: value,
            channel: channel)
        
    }
    
}

// MARK: - Static multi-Event messages

extension MIDI.Event {
    
    /// Creates an RPN message.
    public static func ccRPN(_ rpn: CC.RPN,
                             channel: MIDI.UInt4) -> [MIDI.Event] {
        
        rpn.events(channel: channel)
        
    }
    
    /// Creates an NRPN message, consisting of 3 or 4 MIDI Events.
    public static func ccNRPN(parameter: MIDI.UInt7.Pair,
                              dataEntryMSB: MIDI.UInt7?,
                              dataEntryLSB: MIDI.UInt7?,
                              channel: MIDI.UInt4) -> [MIDI.Event] {
        
        CC
            .NRPN(parameter: parameter,
                  dataEntryMSB: dataEntryMSB,
                  dataEntryLSB: dataEntryLSB)
            .events(channel: channel)
        
    }
    
}
