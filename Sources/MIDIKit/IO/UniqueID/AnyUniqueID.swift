//
//  AnyUniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// Type-erased box for `MIDIIOUniqueIDProtocol`.
    ///
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct AnyUniqueID: MIDIIOUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.AnyEndpoint.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.AnyEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}

extension MIDIIOUniqueIDProtocol {
    
    /// Returns the unique ID as a type-erased `AnyUniqueID`.
    public var asAnyUniqueID: MIDI.IO.AnyUniqueID {
        
        .init(coreMIDIUniqueID)
        
    }
    
}

