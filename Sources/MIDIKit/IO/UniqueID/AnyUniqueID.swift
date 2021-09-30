//
//  AnyUniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Type-erased box for `MIDIIOUniqueIDProtocol`.
    ///
    /// MIDIKit Object Unique ID value type.
    /// Analogous with Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct AnyUniqueID: MIDIIOUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID) {
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
    
    public typealias IntegerLiteralType = MIDI.IO.CoreMIDIUniqueID
    
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

