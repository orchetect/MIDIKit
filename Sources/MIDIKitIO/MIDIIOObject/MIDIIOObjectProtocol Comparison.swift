//
//  MIDIIOObjectProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Equatable default implementation

// (conforming types to MIDIIOObject just need to conform to Equatable and this implementation will be used)

extension MIDIIOObject {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.coreMIDIObjectRef == rhs.coreMIDIObjectRef
    }
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOObject just need to conform to Hashable and this implementation will be used)

extension MIDIIOObject {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coreMIDIObjectRef)
    }
}

#endif
