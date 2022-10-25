//
//  MIDIIOEndpointProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Equatable default implementation

// (conforming types to MIDIIOObject just need to conform to Equatable
// and this implementation will be used)

extension MIDIIOEndpointProtocol {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uniqueID == rhs.uniqueID
    }
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOObject just need to conform to Hashable
// and this implementation will be used)

extension MIDIIOEndpointProtocol {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
}

// MARK: - Identifiable default implementation

// (conforming types to MIDIIOObject just need to conform to Identifiable
// and this implementation will be used)

extension MIDIIOEndpointProtocol {
    public typealias ID = MIDIIdentifier
    
    public var id: ID { uniqueID }
}

#endif
