//
//  UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

public protocol MIDIIOUniqueIDProtocol {
    
    /// CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    var coreMIDIUniqueID: MIDIUniqueID { get }
    
    init(_ coreMIDIUniqueID: MIDIUniqueID)
    
}

extension MIDIIOUniqueIDProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
    
        lhs.coreMIDIUniqueID == rhs.coreMIDIUniqueID
    
    }
    
}

public protocol MIDIIOEndpointUniqueIDProtocol: MIDIIOUniqueIDProtocol {
    
}








extension MIDI.IO.InputEndpoint {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOEndpointUniqueIDProtocol, Hashable {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.InputEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.InputEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}








extension MIDI.IO.OutputEndpoint {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOEndpointUniqueIDProtocol, Hashable {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.OutputEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.OutputEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}







extension MIDI.IO.Device {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOUniqueIDProtocol, Hashable {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.Device.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.Device.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}






extension MIDI.IO.Entity {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOUniqueIDProtocol, Hashable {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.Entity.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.Entity.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}

