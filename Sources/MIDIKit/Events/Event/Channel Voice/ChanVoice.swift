//
//  ChanVoice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    public enum ChanVoice {
        
        case noteOff
        case noteOn
        case polyAftertouch
        case cc
        case programChange
        case chanAftertouch
        case pitchBend
        
    }
    
}
