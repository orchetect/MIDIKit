//
//  UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

// MARK: - UniqueID

extension MIDI.IO {
    
    /// MIDIKit Unique ID value type, analogous with CoreMIDI object refs.
    public struct UniqueID: Equatable, Hashable {
        
        public let id: Int32
        
        public init(_ id: Int32) {
            self.id = id
        }
        
    }
    
}

extension MIDI.IO.UniqueID: ExpressibleByIntegerLiteral{
    
    public typealias IntegerLiteralType = Int32
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        id = value
        
    }
    
}

extension MIDI.IO.UniqueID: CustomStringConvertible {
    
    public var description: String {
        return "\(id)"
    }
    
}
