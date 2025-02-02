//
//  MIDIEvent Filter System Common.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns `true` if the event is a System Common message.
    public var isSystemCommon: Bool {
        switch self {
        case .timecodeQuarterFrame,
             .songPositionPointer,
             .songSelect,
             .tuneRequest:
            true
    
        default:
            false
        }
    }
    
    /// Returns `true` if the event is a System Common message of a specific type.
    public func isSystemCommon(ofType sysCommonType: SysCommonType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .timecodeQuarterFrame : sysCommonType == .timecodeQuarterFrame
        case .songPositionPointer  : sysCommonType == .songPositionPointer
        case .songSelect           : sysCommonType == .songSelect
        case .tuneRequest          : sysCommonType == .tuneRequest
        default                    : false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns `true` if the event is a System Common message of a specific type.
    public func isSystemCommon(ofTypes sysCommonTypes: Set<SysCommonType>) -> Bool {
        for eventType in sysCommonTypes {
            if isSystemCommon(ofType: eventType) { return true }
        }
    
        return false
    }
}

// MARK: - Filter

extension Collection<MIDIEvent> {
    /// Filter System Common events.
    public func filter(sysCommon types: MIDIEvent.SysCommonTypes) -> [Element] {
        switch types {
        case .only:
            filter { $0.isSystemCommon }
    
        case let .onlyType(specificType):
            filter { $0.isSystemCommon(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            filter { $0.isSystemCommon(ofTypes: specificTypes) }
    
        case let .keepType(specificType):
            filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofTypes: specificTypes)
            }
    
        case .drop:
            filter { !$0.isSystemCommon }
    
        case let .dropType(specificType):
            filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofTypes: specificTypes)
            }
        }
    }
}
