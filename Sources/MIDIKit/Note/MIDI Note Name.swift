//
//  MIDI Note Name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public extension MIDI.Note {
    
    /// Note name
    enum Name: String, CaseIterable {
        
        case A       = "A"
        case A_sharp = "A#"
        case B       = "B"
        case C       = "C"
        case C_sharp = "C#"
        case D       = "D"
        case D_sharp = "D#"
        case E       = "E"
        case F       = "F"
        case F_sharp = "F#"
        case G       = "G"
        case G_sharp = "G#"
        
        /// Semitone offset, originating from note C
        public var scaleOffset: Int {
            
            switch self {
            case .A: return 9
            case .A_sharp: return 10
            case .B: return 11
            case .C: return 0
            case .C_sharp: return 1
            case .D: return 2
            case .D_sharp: return 3
            case .E: return 4
            case .F: return 5
            case .F_sharp: return 6
            case .G: return 7
            case .G_sharp: return 8
            }
            
        }
        
    }
    
}
