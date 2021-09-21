//
//  CC NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC.Controller {
    
    /// MIDI CC NRPNs (Non-Registered Parameter Numbers)
    ///
    /// See Recommended Practise RP-018 of the MIDI 1.0 Spec Addenda.
    public struct NRPN: Equatable, Hashable {
        
        let parameter: MIDI.UInt7.Pair
        
        /// Data Entry MSB (optional).
        let dataEntryMSB: MIDI.UInt7?
        
        /// Data Entry LSB (optional).
        let dataEntryLSB: MIDI.UInt7?
        
    }
    
}

extension MIDI.Event.CC.Controller.NRPN {
    
    /// Returns the NRPN message consisting of 2-4 MIDI Events.
    public func events(channel: MIDI.UInt4,
                       group: MIDI.UInt4 = 0) -> [MIDI.Event] {
        
        #warning("> not sure this is correct")
        
        var nrpnEvents: [MIDI.Event] = [
            .cc(.nrpnMSB,
                value: parameter.msb,
                channel: channel,
                group: group),
            
            .cc(.nrpnLSB,
                value: parameter.lsb,
                channel: channel,
                group: group)
        ]
        
        if let dataEntryMSB = dataEntryMSB {
            nrpnEvents.append(.cc(.dataEntry,
                                  value: dataEntryMSB,
                                  channel: channel,
                                  group: group))
        }
        
        if let dataEntryLSB = dataEntryLSB {
            nrpnEvents.append(.cc(.dataEntry,
                                  value: dataEntryLSB,
                                  channel: channel,
                                  group: group))
        }
        
        return nrpnEvents
        
    }
    
}

extension MIDI.Event {
    
    /// Creates an NRPN message, consisting of multiple MIDI Events.
    public static func ccNRPN(parameter: MIDI.UInt7.Pair,
                              dataEntryMSB: MIDI.UInt7?,
                              dataEntryLSB: MIDI.UInt7?,
                              channel: MIDI.UInt4,
                              group: MIDI.UInt4 = 0) -> [MIDI.Event] {
        
        CC.Controller
            .NRPN(parameter: parameter,
                  dataEntryMSB: dataEntryMSB,
                  dataEntryLSB: dataEntryLSB)
            .events(channel: channel,
                    group: group)
        
    }
    
}
