//
//  Device UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO.Device {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.Device.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Device.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Device.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.Device.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDI.IO.CoreMIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.Device.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}
