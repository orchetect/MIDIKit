//
//  Entity UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO.Entity {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID) {
            
            self.coreMIDIUniqueID = coreMIDIUniqueID
            
        }
        
    }
    
}

extension MIDI.IO.Entity.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Entity.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Entity.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Entity.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDI.IO.CoreMIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.Entity.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        "\(coreMIDIUniqueID)"
        
    }
    
}
