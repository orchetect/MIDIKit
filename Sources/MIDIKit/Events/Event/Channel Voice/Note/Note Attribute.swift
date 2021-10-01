//
//  Note Attribute.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// MIDI 2.0 Note Attribute
    public enum Attribute: Equatable, Hashable {
        
        /// None:
        /// When sending, Attribute Value will be 0x0000 and receiver should ignore Attribute Value.
        case none
        
        /// Manufacturer Specific:
        /// Interpretation of Attribute Data is determined by manufacturer.
        case manufacturerSpecific(data: UInt16)
        
        /// Profile Specific:
        /// Interpretation of Attribute Data is determined by MIDI-CI Profile in use.
        case profileSpecific(data: UInt16)
        
        /// Pitch 7.9:
        /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
        case pitch7_9(Pitch7_9)
        
        /// Undefined (0x04...0xFF)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// A Profile might define another Attribute Type that is defined for more specific use by that one Profile only.
        /// The application of an Attribute Type value might be defined by MMA/AMEI in a MIDI-CI Profile specification. For example, a drum Profile might define an Attribute Type as “Strike Position” with the Attribute Data value declaring the position from center of drum/cymbal to outer edge. An orchestral string Profile might define Attribute values to be used as Articulation choice such as Arco, Pizzicato, Spiccato, Tremolo, etc. Such cases generally require assigning 1 of the 256 available Attribute Types for use by that Profile. Some Profiles might be able to share some common Attribute types.
        case undefined(attributeType: MIDI.Byte, data: UInt16)
        
    }
    
}

extension MIDI.Event.Note.Attribute {
    
    public init(type: MIDI.Byte, data: UInt16) {
        
        switch type {
        case 0x00:
            self = .none
            
        case 0x01:
            self = .manufacturerSpecific(data: data)
            
        case 0x02:
            self = .profileSpecific(data: data)
            
        case 0x03:
            self = .pitch7_9(.init(data))
            
        default:
            self = .undefined(attributeType: type, data: data)
            
        }
        
    }
    
}

extension MIDI.Event.Note.Attribute {
    
    /// Attribute Type Byte
    public var attributeType: MIDI.Byte {
        
        switch self {
        case .none:
            return 0x00
            
        case .manufacturerSpecific:
            return 0x01
            
        case .profileSpecific:
            return 0x02
            
        case .pitch7_9:
            return 0x03
            
        case .undefined(attributeType: let attributeType, data: _):
            return attributeType
            
        }
        
    }
    
    /// Attribute Data
    public var attributeData: UInt16 {
        
        switch self {
        case .none:
            return 0x0000
            
        case .manufacturerSpecific(let data):
            return data
            
        case .profileSpecific(let data):
            return data
            
        case .pitch7_9(let pitch):
            return pitch.uInt16Value
            
        case .undefined(attributeType: _, data: let data):
            return data
            
        }
        
    }
    
}
