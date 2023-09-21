//
//  MIDIEvent Filter System Exclusive.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns `true` if the event is a System Exclusive message.
    public var isSystemExclusive: Bool {
        switch self {
        case .sysEx7,
             .universalSysEx7,
             .sysEx8,
             .universalSysEx8:
            return true
    
        default:
            return false
        }
    }
    
    /// Returns `true` if the event is a System Exclusive message of a specific type.
    public func isSystemExclusive(ofType sysExType: SysExType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .sysEx7          : return sysExType == .sysEx7
        case .universalSysEx7 : return sysExType == .universalSysEx7
        case .sysEx8          : return sysExType == .sysEx8
        case .universalSysEx8 : return sysExType == .universalSysEx8
        default               : return false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns `true` if the event is a System Exclusive message of a specific type.
    public func isSystemExclusive(ofTypes sysExTypes: Set<SysExType>) -> Bool {
        for eventType in sysExTypes {
            if isSystemExclusive(ofType: eventType) { return true }
        }
    
        return false
    }
}

// MARK: - Filter

extension Collection<MIDIEvent> {
    /// Filter System Exclusive events.
    public func filter(sysEx types: MIDIEvent.SysExTypes) -> [Element] {
        switch types {
        case .only:
            return filter { $0.isSystemExclusive }
    
        case let .onlyType(specificType):
            return filter { $0.isSystemExclusive(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            return filter { $0.isSystemExclusive(ofTypes: specificTypes) }
    
        case let .keepType(specificType):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofTypes: specificTypes)
            }
    
        case .drop:
            return filter { !$0.isSystemExclusive }
    
        case let .dropType(specificType):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofTypes: specificTypes)
            }
        }
    }
}
