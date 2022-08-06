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
        case utility(MIDI.Event.UtilityTypes)
        
        case group(MIDI.UInt4)
        case groups([MIDI.UInt4])
    }
}

extension MIDI.Event.Filter {
    /// Process MIDI events using this filter.
    public func apply(to events: [MIDI.Event]) -> [MIDI.Event] {
        switch self {
        case let .chanVoice(types):
            return events.filter(chanVoice: types)
            
        case let .sysEx(types):
            return events.filter(sysEx: types)
            
        case let .sysCommon(types):
            return events.filter(sysCommon: types)
            
        case let .sysRealTime(types):
            return events.filter(sysRealTime: types)
            
        case let .utility(types):
            return events.filter(utility: types)
            
        case let .group(group):
            return events.filter(group: group)
            
        case let .groups(groups):
            return events.filter(groups: groups)
        }
    }
}
