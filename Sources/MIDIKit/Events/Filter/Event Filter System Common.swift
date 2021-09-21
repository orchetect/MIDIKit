//
//  Event Filter System Common.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Metadata properties

extension MIDI.Event {
    
    /// Returns true if the event is a System Common message.
    @inlinable public var isSystemCommon: Bool {
        
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
    @inlinable public func isSystemCommon(ofType sysCommonType: SysCommonType) -> Bool {
        
        switch self {
        case .timecodeQuarterFrame : return sysCommonType == .timecodeQuarterFrame
        case .songPositionPointer  : return sysCommonType == .songPositionPointer
        case .songSelect           : return sysCommonType == .songSelect
        case .unofficialBusSelect  : return sysCommonType == .unofficialBusSelect
        case .tuneRequest          : return sysCommonType == .tuneRequest
        default                    : return false
        }
        
    }
    
    /// Returns true if the event is a System Common message of a specific type.
    @inlinable public func isSystemCommon(ofTypes sysCommonTypes: Set<SysCommonType>) -> Bool {
        
        for eventType in sysCommonTypes {
            if self.isSystemCommon(ofType: eventType) { return true }
        }
        
        return false
        
    }
    
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter System Common events.
    @inlinable public func filter(sysCommon types: MIDI.Event.SysCommonTypes) -> [Element] {
        
        switch types {
        case .only:
            return filter { $0.isSystemCommon }
            
        case .onlyType(let specificType):
            return filter { $0.isSystemCommon(ofType: specificType) }
            
        case .onlyTypes(let specificTypes):
            return filter { $0.isSystemCommon(ofTypes: specificTypes) }
            
        case .keepType(let specificType):
            return filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofType: specificType)
            }
            
        case .keepTypes(let specificTypes):
            return filter {
                guard $0.isSystemCommon else { return true }
                return $0.isSystemCommon(ofTypes: specificTypes)
            }
            
        case .drop:
            return filter { !$0.isSystemCommon }
           
        case .dropType(let specificType):
            return filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofType: specificType)
            }
            
        case .dropTypes(let specificTypes):
            return filter {
                guard $0.isSystemCommon else { return true }
                return !$0.isSystemCommon(ofTypes: specificTypes)
            }
           
        }
        
    }
    
}
