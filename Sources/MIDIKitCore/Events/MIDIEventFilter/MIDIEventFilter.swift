//
//  MIDIEventFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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

extension MIDIEventFilter: Sendable { }

extension MIDIEventFilter {
    /// Process MIDI events using this filter.
    public func apply(to events: [MIDIEvent]) -> [MIDIEvent] {
        switch self {
        case let .chanVoice(types):
            events.filter(chanVoice: types)
    
        case let .sysEx(types):
            events.filter(sysEx: types)
    
        case let .sysCommon(types):
            events.filter(sysCommon: types)
    
        case let .sysRealTime(types):
            events.filter(sysRealTime: types)
    
        case let .utility(types):
            events.filter(utility: types)
    
        case let .group(group):
            events.filter(group: group)
    
        case let .groups(groups):
            events.filter(groups: groups)
        }
    }
}
