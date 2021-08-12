//
//  ChanVoiceType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    public enum ChanVoiceTypes {
        
        case only
        case onlyType(ChanVoiceType)
        case onlyTypes(Set<ChanVoiceType>)
        case onlyChannel(MIDI.UInt4)
        case onlyChannels([MIDI.UInt4])
        case onlyCC(MIDI.Event.CC)
        case onlyCCs([MIDI.Event.CC])
        
        case keepType(ChanVoiceType)
        case keepTypes(Set<ChanVoiceType>)
        case keepChannel(MIDI.UInt4)
        case keepChannels([MIDI.UInt4])
        case keepCC(MIDI.Event.CC)
        case keepCCs([MIDI.Event.CC])
        
        case drop
        case dropType(ChanVoiceType)
        case dropTypes(Set<ChanVoiceType>)
        case dropChannel(MIDI.UInt4)
        case dropChannels([MIDI.UInt4])
        case dropCC(MIDI.Event.CC)
        case dropCCs([MIDI.Event.CC])
        
    }
    
    public enum ChanVoiceType {
        
        case noteOff
        case noteOn
        case polyAftertouch
        case cc
        case programChange
        case chanAftertouch
        case pitchBend
        
    }
    
}
