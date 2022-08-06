//
//  Event Filter System Real Time.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Metadata properties

extension MIDI.Event {
    /// Returns true if the event is a System Real Time message.
    @inlinable
    public var isSystemRealTime: Bool {
        switch self {
        case .timingClock,
             .start,
             .continue,
             .stop,
             .activeSensing,
             .systemReset:
            return true
            
        default:
            return false
        }
    }
    
    /// Returns true if the event is a System Real Time message of a specific type.
    @inlinable
    public func isSystemRealTime(ofType sysRealTimeType: SysRealTimeType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .timingClock   : return sysRealTimeType == .timingClock
        case .start         : return sysRealTimeType == .start
        case .continue      : return sysRealTimeType == .continue
        case .stop          : return sysRealTimeType == .stop
        case .activeSensing : return sysRealTimeType == .activeSensing
        case .systemReset   : return sysRealTimeType == .systemReset
        default             : return false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns true if the event is a System Real Time message of a specific type.
    @inlinable
    public func isSystemRealTime(ofTypes sysRealTimeTypes: Set<SysRealTimeType>) -> Bool {
        for eventType in sysRealTimeTypes {
            if isSystemRealTime(ofType: eventType) { return true }
        }
        
        return false
    }
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    /// Filter System Real Time events.
    @inlinable
    public func filter(sysRealTime types: MIDI.Event.SysRealTimeTypes) -> [Element] {
        switch types {
        case .only:
            return filter { $0.isSystemRealTime }
            
        case let .onlyType(specificType):
            return filter { $0.isSystemRealTime(ofType: specificType) }
            
        case let .onlyTypes(specificTypes):
            return filter { $0.isSystemRealTime(ofTypes: specificTypes) }
            
        case let .keepType(specificType):
            return filter {
                guard $0.isSystemRealTime else { return true }
                return $0.isSystemRealTime(ofType: specificType)
            }
            
        case let .keepTypes(specificTypes):
            return filter {
                guard $0.isSystemRealTime else { return true }
                return $0.isSystemRealTime(ofTypes: specificTypes)
            }
            
        case .drop:
            return filter { !$0.isSystemRealTime }
            
        case let .dropType(specificType):
            return filter {
                guard $0.isSystemRealTime else { return true }
                return !$0.isSystemRealTime(ofType: specificType)
            }
            
        case let .dropTypes(specificTypes):
            return filter {
                guard $0.isSystemRealTime else { return true }
                return !$0.isSystemRealTime(ofTypes: specificTypes)
            }
        }
    }
}
