//
//  MIDIEvent Filter Utility.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns `true` if the event is a Utility message.
    public var isUtility: Bool {
        switch self {
        case .noOp,
             .jrClock,
             .jrTimestamp:
            true
    
        default:
            false
        }
    }
    
    /// Returns `true` if the event is a Utility message of a specific type.
    public func isUtility(ofType utilityType: UtilityType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .noOp        : utilityType == .noOp
        case .jrClock     : utilityType == .jrClock
        case .jrTimestamp : utilityType == .jrTimestamp
        default           : false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns `true` if the event is a Utility message of a specific type.
    public func isUtility(ofTypes utilityTypes: Set<UtilityType>) -> Bool {
        for eventType in utilityTypes {
            if isUtility(ofType: eventType) { return true }
        }
    
        return false
    }
}

// MARK: - Filter

extension Collection<MIDIEvent> {
    /// Filter Utility events.
    public func filter(utility types: MIDIEvent.UtilityTypes) -> [Element] {
        switch types {
        case .only:
            filter { $0.isUtility }
    
        case let .onlyType(specificType):
            filter { $0.isUtility(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            filter { $0.isUtility(ofTypes: specificTypes) }
    
        case let .keepType(specificType):
            filter {
                guard $0.isUtility else { return true }
                return $0.isUtility(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            filter {
                guard $0.isUtility else { return true }
                return $0.isUtility(ofTypes: specificTypes)
            }
    
        case .drop:
            filter { !$0.isUtility }
    
        case let .dropType(specificType):
            filter {
                guard $0.isUtility else { return true }
                return !$0.isUtility(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            filter {
                guard $0.isUtility else { return true }
                return !$0.isUtility(ofTypes: specificTypes)
            }
        }
    }
}
