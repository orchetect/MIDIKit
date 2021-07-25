//
//  CC NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC {
    
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

extension MIDI.Event.CC.NRPN {
    
    /// Returns the NRPN message consisting of 2-4 MIDI Events.
    public func events(channel: MIDI.UInt4) -> [MIDI.Event] {
        
        #warning("> not sure this is correct")
        
        var nrpnEvents: [MIDI.Event] = [
            .cc(controller: .nrpnMSB,
                value: parameter.msb,
                channel: channel),
            
            .cc(controller: .nrpnLSB,
                value: parameter.lsb,
                channel: channel)
        ]
        
        if let dataEntryMSB = dataEntryMSB {
            nrpnEvents.append(.cc(controller: .dataEntry,
                                  value: dataEntryMSB,
                                  channel: channel))
        }
        
        if let dataEntryLSB = dataEntryLSB {
            nrpnEvents.append(.cc(controller: .dataEntry,
                                  value: dataEntryLSB,
                                  channel: channel))
        }
        
        return nrpnEvents
        
    }
    
}
