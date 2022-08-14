//
//  MIDIEvent Filter System Common.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns true if the event is a System Common message.
    @inlinable
    public var isSystemCommon: Bool {
        switch self {
        case .timecodeQuarterFrame,
             .songPositionPointer,
             .songSelect,
             .unofficialBusSelect,
             .tuneRequest:
            return true
            
        default:
            return false
        }
    }
    
    /// Returns true if the event is a System Common message of a specific type.
    @inlinable
    public func isSystemCommon(ofType sysCommonType: SysCommonType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .timecodeQuarterFrame : return sysCommonType == .timecodeQuarterFrame
        case .songPositionPointer  : return sysCommonType == .songPositionPointer
        case .songSelect           : return sysCommonType == .songSelect
        case .unofficialBusSelect  : return sysCommonType == .unofficialBusSelect
        case .tuneRequest          : return sysCommonType == .tuneRequest
        default                    : return false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns true if the event is a System Common message of a specific type.
    @inlinable
    public func isSystemCommon(ofTypes sysCommonTypes: Set<SysCommonType>) -> Bool {
        for eventType in sysCommonTypes {
            if isSystemCommon(ofType: eventType) { return true }
        }
        
        return false
    }
}

// MARK: - Filter

extension Collection where Element == MIDIEvent {
    /// Filter System Common events.
    @inlinable
    public func filter(sysCommon types: MIDIEvent.SysCommonTypes) -> [Element] {
        switch types {
        case .only:
            return filter { $0.isSystemCommon }
            
        case let .onlyType(specificType):
            return filter { $0.isSystemCommon(ofType: specificType) }
            
        case let .onlyTypes(specificTypes):
            return filter { $0.isSystemCommon(ofTypes: specificTypes) }
            
        case let .keepType(specificType):
            return filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofType: specificType)
            }
            
        case let .keepTypes(specificTypes):
            return filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofTypes: specificTypes)
            }
            
        case .drop:
            return filter { !$0.isSystemCommon }
            
        case let .dropType(specificType):
            return filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofType: specificType)
            }
            
        case let .dropTypes(specificTypes):
            return filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofTypes: specificTypes)
            }
        }
    }
}
