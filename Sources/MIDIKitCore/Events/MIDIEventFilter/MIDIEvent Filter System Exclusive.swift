//
//  MIDIEvent Filter System Exclusive.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
            true
    
        default:
            false
        }
    }
    
    /// Returns `true` if the event is a System Exclusive message of a specific type.
    public func isSystemExclusive(ofType sysExType: SysExType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .sysEx7          : sysExType == .sysEx7
        case .universalSysEx7 : sysExType == .universalSysEx7
        case .sysEx8          : sysExType == .sysEx8
        case .universalSysEx8 : sysExType == .universalSysEx8
        default               : false
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
            filter { $0.isSystemExclusive }
    
        case let .onlyType(specificType):
            filter { $0.isSystemExclusive(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            filter { $0.isSystemExclusive(ofTypes: specificTypes) }
    
        case let .keepType(specificType):
            filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofTypes: specificTypes)
            }
    
        case .drop:
            filter { !$0.isSystemExclusive }
    
        case let .dropType(specificType):
            filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofTypes: specificTypes)
            }
        }
    }
}
