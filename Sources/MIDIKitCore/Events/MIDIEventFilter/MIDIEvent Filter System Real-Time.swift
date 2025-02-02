//
//  MIDIEvent Filter System Real-Time.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns `true` if the event is a System Real-Time message.
    public var isSystemRealTime: Bool {
        switch self {
        case .timingClock,
             .start,
             .continue,
             .stop,
             .activeSensing,
             .systemReset:
            true
    
        default:
            false
        }
    }
    
    /// Returns `true` if the event is a System Real-Time message of a specific type.
    public func isSystemRealTime(ofType sysRealTimeType: SysRealTimeType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .timingClock   : sysRealTimeType == .timingClock
        case .start         : sysRealTimeType == .start
        case .continue      : sysRealTimeType == .continue
        case .stop          : sysRealTimeType == .stop
        case .activeSensing : sysRealTimeType == .activeSensing
        case .systemReset   : sysRealTimeType == .systemReset
        default             : false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns `true` if the event is a System Real-Time message of a specific type.
    public func isSystemRealTime(ofTypes sysRealTimeTypes: Set<SysRealTimeType>) -> Bool {
        for eventType in sysRealTimeTypes {
            if isSystemRealTime(ofType: eventType) { return true }
        }
    
        return false
    }
}

// MARK: - Filter

extension Collection<MIDIEvent> {
    /// Filter System Real-Time events.
    public func filter(sysRealTime types: MIDIEvent.SysRealTimeTypes) -> [Element] {
        switch types {
        case .only:
            filter { $0.isSystemRealTime }
    
        case let .onlyType(specificType):
            filter { $0.isSystemRealTime(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            filter { $0.isSystemRealTime(ofTypes: specificTypes) }
    
        case let .keepType(specificType):
            filter {
                guard $0.isSystemRealTime else { return true }
                return $0.isSystemRealTime(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            filter {
                guard $0.isSystemRealTime else { return true }
                return $0.isSystemRealTime(ofTypes: specificTypes)
            }
    
        case .drop:
            filter { !$0.isSystemRealTime }
    
        case let .dropType(specificType):
            filter {
                guard $0.isSystemRealTime else { return true }
                return !$0.isSystemRealTime(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            filter {
                guard $0.isSystemRealTime else { return true }
                return !$0.isSystemRealTime(ofTypes: specificTypes)
            }
        }
    }
}
