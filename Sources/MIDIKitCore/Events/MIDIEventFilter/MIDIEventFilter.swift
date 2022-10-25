//
//  MIDIEventFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

/// MIDI event filter definition.
public enum MIDIEventFilter: Equatable, Hashable {
    case chanVoice(MIDIEvent.ChanVoiceTypes)
    case sysEx(MIDIEvent.SysExTypes)
    case sysCommon(MIDIEvent.SysCommonTypes)
    case sysRealTime(MIDIEvent.SysRealTimeTypes)
    case utility(MIDIEvent.UtilityTypes)
    
    case group(UInt4)
    case groups([UInt4])
}

extension MIDIEventFilter {
    /// Process MIDI events using this filter.
    public func apply(to events: [MIDIEvent]) -> [MIDIEvent] {
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
