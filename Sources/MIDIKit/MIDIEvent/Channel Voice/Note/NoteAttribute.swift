//
//  Note Attribute.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Note Attribute
    /// (MIDI 2.0)
    public enum NoteAttribute: Equatable, Hashable {
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
        case undefined(attributeType: Byte, data: UInt16)
    }
}

extension MIDIEvent.NoteAttribute {
    /// Note Attribute
    /// (MIDI 2.0)
    ///
    /// Initialize from raw type and data.
    @inline(__always)
    public init(
        type: Byte,
        data: UInt16
    ) {
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
    
    /// Pitch 7.9 Note Attribute
    /// (MIDI 2.0)
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    ///
    /// - Parameters:
    ///   - coarse: 7-Bit coarse pitch in semitones, based on default Note Number equal temperament scale.
    ///   - fine: 9-Bit fractional pitch above Note Number (i.e., fraction of one semitone).
    @inline(__always)
    public static func pitch7_9(
        coarse: UInt7,
        fine: UInt9
    ) -> Self {
        .pitch7_9(.init(coarse: coarse, fine: fine))
    }
}

extension MIDIEvent.NoteAttribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "none"
            
        case let .manufacturerSpecific(data):
            return "manufacturerSpecific(\(data))"
            
        case let .profileSpecific(data):
            return "profileSpecific(\(data))"
            
        case let .pitch7_9(p79):
            return "\(p79)"
            
        case let .undefined(attributeType: attributeType, data):
            let attrString = attributeType.hex.stringValue(padTo: 2, prefix: true)
            let dataString = data.hex.stringValue(padTo: 4, prefix: true)
            return "undefined(\(attrString), data: \(dataString))"
        }
    }
}

extension MIDIEvent.NoteAttribute {
    /// Attribute Type Byte
    @inline(__always)
    public var attributeType: Byte {
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
    @inline(__always)
    public var attributeData: UInt16 {
        switch self {
        case .none:
            return 0x0000
            
        case let .manufacturerSpecific(data):
            return data
            
        case let .profileSpecific(data):
            return data
            
        case let .pitch7_9(pitch):
            return pitch.uInt16Value
            
        case .undefined(attributeType: _, data: let data):
            return data
        }
    }
}
