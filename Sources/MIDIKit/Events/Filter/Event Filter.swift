//
//  Event Filter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// A MIDI event filter definition.
    public enum Filter {
        
        case chanVoice(MIDI.Event.ChanVoiceTypes)
        case sysEx(MIDI.Event.SysExTypes)
        case sysCommon(MIDI.Event.SysCommonTypes)
        case sysRealTime(MIDI.Event.SysRealTimeTypes)
        
    }
    
}

extension MIDI.Event.Filter {
    
    /// Process MIDI events using this filter.
    public func apply(to events: [MIDI.Event]) -> [MIDI.Event] {
        
        switch self {
        case .chanVoice(let types):
            return events.filter(chanVoice: types)
            
        case .sysEx(let types):
            return events.filter(sysEx: types)
            
        case .sysCommon(let types):
            return events.filter(sysCommon: types)
            
        case .sysRealTime(let types):
            return events.filter(sysRealTime: types)
            
        }
        
    }
    
}
