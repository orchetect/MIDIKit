//
//  CC RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC {
    
    /// Cases describing MIDI CC RPNs (Registered Parameter Numbers)
    ///
    /// - remark: As per MIDI 1.0 spec:
    ///
    /// To set or change the value of a Registered Parameter:
    ///
    /// 1. Send two Control Change messages using Control Numbers 101 (0x65) and 100 (0x64) to select the desired Registered Parameter Number.
    ///
    /// 2. To set the selected Registered Parameter to a specific value, send a Control Change messages to the Data Entry MSB controller (Control Number 6). If the selected Registered Parameter requires the LSB to be set, send another Control Change message to the Data Entry LSB controller (Control Number 38).
    ///
    /// 3. To make a relative adjustment to the selected Registered Parameter's current value, use the Data Increment or Data Decrement controllers (Control Numbers 96 and 97).
    ///
    /// Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    ///
    /// For custom Parameter Number use, see NRPN (non-Registered Parameter Numbers).
    ///
    /// - note: See Recommended Practise RP-018 of the MIDI 1.0 Spec Addenda.
    public enum RPN: Equatable, Hashable {
        
        /// Pitch Bend Sensitivity
        case pitchBendSensitivity(semitones: MIDI.UInt7,
                                  cents: MIDI.UInt7)
        
        /// Channel Fine Tuning
        /// (formerly Fine Tuning - see MMA RP-022)
        ///
        /// Resolution: 100/8192 cents
        /// Midpoint = A440, min/max -/+ 100 cents
        case channelFineTuning(MIDI.UInt14)
        
        /// Channel Coarse Tuning
        /// (formerly Coarse Tuning - see MMA RP-022)
        ///
        /// Resolution: 100 cents
        /// 0x00 = -6400 cents
        /// 0x40 = A440
        /// 0x7F = +6300 cents
        case channelCoarseTuning(MIDI.UInt7)
        
        /// Tuning Program Change
        case tuningProgramChange(number: Int)
        
        /// Tuning Bank Select
        case tuningBankSelect(number: Int)
        
        /// Modulation Depth Range
        /// (see MMA General MIDI Level 2 Specification)
        ///
        /// For GM2, defined in GM2 Specification.
        /// For other systems, defined by manufacturer.
        case modulationDepthRange(dataEntryMSB: MIDI.UInt7?,
                                  dataEntryLSB: MIDI.UInt7?)
        
        /// MPE Configuration Message
        /// (see MPE Specification)
        case mpeConfigurationMessage(dataEntryMSB: MIDI.UInt7?,
                                     dataEntryLSB: MIDI.UInt7?)
        
        /// Null Function Number for RPN/NRPN
        ///
        /// Will disable the data entry, data increment, and data decrement controllers until a new RPN or NRPN is selected.
        case null
        
        /// Form an RPM message from a raw parameter number byte pair
        case raw(parameter: MIDI.UInt7.Pair,
                 dataEntryMSB: MIDI.UInt7?,
                 dataEntryLSB: MIDI.UInt7?)
        
    }
    
}

extension MIDI.Event.CC.RPN {
    
    /// Parameter number byte pair
    public var parameter: MIDI.UInt7.Pair {
        
        switch self {
        case .pitchBendSensitivity:
            return .init(msb: 0x00, lsb: 0x00)
            
        case .channelFineTuning:
            return .init(msb: 0x00, lsb: 0x01)
            
        case .channelCoarseTuning:
            return .init(msb: 0x00, lsb: 0x02)
            
        case .tuningProgramChange:
            return .init(msb: 0x00, lsb: 0x03)
            
        case .tuningBankSelect:
            return .init(msb: 0x00, lsb: 0x04)
            
        case .modulationDepthRange:
            return .init(msb: 0x00, lsb: 0x05)
            
        case .mpeConfigurationMessage:
            return .init(msb: 0x00, lsb: 0x06)
            
        case .null:
            return .init(msb: 0x7F, lsb: 0x7F)
            
        case .raw(let param, _, _):
            return param
            
        }
        
    }
    
    public var dataEntryBytes: (msb: MIDI.UInt7?,
                                lsb: MIDI.UInt7?) {
        
        switch self {
        case .pitchBendSensitivity(semitones: let semitones,
                                   cents: let cents):
            return (msb: semitones,
                    lsb: cents)
            
        case .channelFineTuning(let value):
            let uint7Pair = value.midiUInt7Pair
            return (msb: uint7Pair.msb,
                    lsb: uint7Pair.lsb)
            
        case .channelCoarseTuning(let value):
            return (msb: value,
                    lsb: nil)
            
        case .tuningProgramChange(number: let number):
            #warning("> not sure if this is correct")
            return (msb: number.toMIDIUInt7Exactly,
                    lsb: nil)
            
        case .tuningBankSelect(number: let number):
            #warning("> not sure if this is correct")
            return (msb: number.toMIDIUInt7Exactly,
                    lsb: nil)
            
        case .modulationDepthRange(dataEntryMSB: let dataEntryMSB,
                                   dataEntryLSB: let dataEntryLSB):
            return (msb: dataEntryMSB,
                    lsb: dataEntryLSB)
            
        case .mpeConfigurationMessage(dataEntryMSB: let dataEntryMSB,
                                      dataEntryLSB: let dataEntryLSB):
            return (msb: dataEntryMSB,
                    lsb: dataEntryLSB)
            
        case .null:
            return (msb: 0x7F,
                    lsb: 0x7F)
            
        case .raw(parameter: _,
                  dataEntryMSB: let dataEntryMSB,
                  dataEntryLSB: let dataEntryLSB):
            return (msb: dataEntryMSB,
                    lsb: dataEntryLSB)
            
        }
        
    }
    
}

extension MIDI.Event.CC.RPN {
    
    /// Returns the RPN message consisting of 2-4 MIDI Events.
    public func events(channel: MIDI.UInt4) -> [MIDI.Event] {
        
        #warning("> not sure this is correct")
        
        var rpnEvents: [MIDI.Event] = [
            .cc(controller: .rpnMSB,
                value: parameter.msb,
                channel: channel),
            
            .cc(controller: .rpnLSB,
                value: parameter.lsb,
                channel: channel)
        ]
        
        let dataEntryBytes = self.dataEntryBytes
        
        if let dataEntryMSB = dataEntryBytes.msb {
            rpnEvents.append(.cc(controller: .dataEntry,
                             value: dataEntryMSB,
                             channel: channel))
        }
        
        if let dataEntryLSB = dataEntryBytes.lsb {
            rpnEvents.append(.cc(controller: .dataEntry,
                             value: dataEntryLSB,
                             channel: channel))
        }
        
        return rpnEvents
        
    }
    
}
