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
        case onlyCC(MIDI.Event.CC.Controller)
        case onlyCCs([MIDI.Event.CC.Controller])
        
        case keepType(ChanVoiceType)
        case keepTypes(Set<ChanVoiceType>)
        case keepChannel(MIDI.UInt4)
        case keepChannels([MIDI.UInt4])
        case keepCC(MIDI.Event.CC.Controller)
        case keepCCs([MIDI.Event.CC.Controller])
        
        case drop
        case dropType(ChanVoiceType)
        case dropTypes(Set<ChanVoiceType>)
        case dropChannel(MIDI.UInt4)
        case dropChannels([MIDI.UInt4])
        case dropCC(MIDI.Event.CC.Controller)
        case dropCCs([MIDI.Event.CC.Controller])
        
    }
    
    public enum ChanVoiceType {
        
        case noteOn
        case noteOff
        case noteCC
        case notePitchBend
        case notePressure
        case noteManagement
        case cc
        case programChange
        case pressure
        case pitchBend
        
    }
    
}
