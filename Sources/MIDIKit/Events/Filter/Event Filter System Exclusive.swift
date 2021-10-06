//
//  Event Filter System Exclusive.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Metadata properties

extension MIDI.Event {
    
    /// Returns true if the event is a System Exclusive message.
    @inlinable
    public var isSystemExclusive: Bool {
        
        switch self {
        case .sysEx,
             .universalSysEx:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a System Exclusive message of a specific type.
    @inlinable
    public func isSystemExclusive(ofType sysExType: SysExType) -> Bool {
        
        switch self {
        case .sysEx          : return sysExType == .sysEx
        case .universalSysEx : return sysExType == .universalSysEx
        default              : return false
        }
        
    }
    
    /// Returns true if the event is a System Exclusive message of a specific type.
    @inlinable
    public func isSystemExclusive(ofTypes sysExTypes: Set<SysExType>) -> Bool {
        
        for eventType in sysExTypes {
            if self.isSystemExclusive(ofType: eventType) { return true }
        }
        
        return false
        
    }
    
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter System Exclusive events.
    @inlinable
    public func filter(sysEx types: MIDI.Event.SysExTypes) -> [Element] {
        
        switch types {
        case .only:
            return filter { $0.isSystemExclusive }
            
        case .onlyType(let specificType):
            return filter { $0.isSystemExclusive(ofType: specificType) }
            
        case .onlyTypes(let specificTypes):
            return filter { $0.isSystemExclusive(ofTypes: specificTypes) }
            
        case .keepType(let specificType):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofType: specificType)
            }
            
        case .keepTypes(let specificTypes):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return $0.isSystemExclusive(ofTypes: specificTypes)
            }
            
        case .drop:
            return filter { !$0.isSystemExclusive }
            
        case .dropType(let specificType):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofType: specificType)
            }
            
        case .dropTypes(let specificTypes):
            return filter {
                guard $0.isSystemExclusive else { return true }
                return !$0.isSystemExclusive(ofTypes: specificTypes)
            }
            
        }
        
    }
    
}
