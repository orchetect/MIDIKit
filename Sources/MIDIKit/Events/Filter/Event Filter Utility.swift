//
//  Event Filter Utility.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Metadata properties

extension MIDI.Event {
    
    /// Returns true if the event is a Utility message.
    @inlinable
    public var isUtility: Bool {
        
        switch self {
        case .noOp,
             .jrClock,
             .jrTimestamp:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a Utility message of a specific type.
    @inlinable
    public func isUtility(ofType utilityType: UtilityType) -> Bool {
        
        switch self {
        case .noOp        : return utilityType == .noOp
        case .jrClock     : return utilityType == .jrClock
        case .jrTimestamp : return utilityType == .jrTimestamp
        default           : return false
        }
        
    }
    
    /// Returns true if the event is a Utility message of a specific type.
    @inlinable
    public func isUtility(ofTypes utilityTypes: Set<UtilityType>) -> Bool {
        
        for eventType in utilityTypes {
            if self.isUtility(ofType: eventType) { return true }
        }
        
        return false
        
    }
    
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter Utility events.
    @inlinable
    public func filter(utility types: MIDI.Event.UtilityTypes) -> [Element] {
        
        switch types {
        case .only:
            return filter { $0.isUtility }
            
        case .onlyType(let specificType):
            return filter { $0.isUtility(ofType: specificType) }
            
        case .onlyTypes(let specificTypes):
            return filter { $0.isUtility(ofTypes: specificTypes) }
            
        case .keepType(let specificType):
            return filter {
                guard $0.isUtility else { return true }
                return $0.isUtility(ofType: specificType)
            }
            
        case .keepTypes(let specificTypes):
            return filter {
                guard $0.isUtility else { return true }
                return $0.isUtility(ofTypes: specificTypes)
            }
            
        case .drop:
            return filter { !$0.isUtility }
            
        case .dropType(let specificType):
            return filter {
                guard $0.isUtility else { return true }
                return !$0.isUtility(ofType: specificType)
            }
            
        case .dropTypes(let specificTypes):
            return filter {
                guard $0.isUtility else { return true }
                return !$0.isUtility(ofTypes: specificTypes)
            }
            
        }
        
    }
    
}
