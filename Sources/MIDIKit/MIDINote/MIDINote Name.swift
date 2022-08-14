//
//  MIDINote Name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDINote {
    /// MIDI note name.
    public enum Name: CaseIterable, Equatable, Hashable {
        case A
        case A_sharp
        case B
        case C
        case C_sharp
        case D
        case D_sharp
        case E
        case F
        case F_sharp
        case G
        case G_sharp
        
        public static let sharpAccidental: Character = "#"
        public static let sharpAccidentalUnicode: Character = "♯"
        
        public static let flatAccidental: Character = "b"
        public static let flatAccidentalUnicode: Character = "♭"
        
        /// Initialize MIDI note name from a string.
        /// (ie: "A", "F#", "F♯", "Bb", "B♭")
        public init?(_ string: String) {
            guard !string.isEmpty else { return nil }
            let accidental: Character? = string.count > 1
                ? string[string.index(after: string.startIndex)]
                : nil
            
            switch string[string.startIndex].uppercased() {
            case "A":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .A_sharp
                        
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .G_sharp
                        
                    default:
                        return nil
                    }
                } else {
                    self = .A
                }
                
            case "B":
                if let accidental = accidental {
                    switch accidental {
                    // don't allow B♭ to become C, as octave number would change
                    // case Self.sharpAccidental,
                    //    Self.sharpAccidentalUnicode:
                    //    self = .C // C♮
                    //
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .A_sharp
                        
                    default:
                        return nil
                    }
                } else {
                    self = .B
                }
                
            case "C":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .C_sharp
                    
                    // don't allow C♯ to become B, as octave number would change
                    // case Self.flatAccidental,
                    //    Self.flatAccidentalUnicode:
                    //    self = .B // B♮
                        
                    default:
                        return nil
                    }
                } else {
                    self = .C
                }
                
            case "D":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .D_sharp
                        
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .C_sharp
                        
                    default:
                        return nil
                    }
                } else {
                    self = .D
                }
                
            case "E":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .F // F♮
                    
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .D_sharp
                        
                    default:
                        return nil
                    }
                } else {
                    self = .E
                }
                
            case "F":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .F_sharp
                        
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .E // E♮
                        
                    default:
                        return nil
                    }
                } else {
                    self = .F
                }
                
            case "G":
                if let accidental = accidental {
                    switch accidental {
                    case Self.sharpAccidental,
                         Self.sharpAccidentalUnicode:
                        self = .G_sharp
                        
                    case Self.flatAccidental,
                         Self.flatAccidentalUnicode:
                        self = .F_sharp
                        
                    default:
                        return nil
                    }
                } else {
                    self = .G
                }
                
            default:
                return nil
            }
        }
        
        /// Returns the note name as a string.
        ///
        /// - Parameters:
        ///   - respellSharpAsFlat: If note is sharp, respell enharmonically as a flat (ie: G♯ becomes A♭) Otherwise, sharp is always used, which is typical convention for MIDI note names.
        ///   - unicodeAccidental: Use stylized unicode character for sharp (♯) and flat (♭).
        public func stringValue(
            respellSharpAsFlat: Bool = false,
            unicodeAccidental: Bool = false
        ) -> String {
            let flat = unicodeAccidental
                ? Self.flatAccidentalUnicode
                : Self.flatAccidental
            let sharp = unicodeAccidental
                ? Self.sharpAccidentalUnicode
                : Self.sharpAccidental
            
            // swiftformat:disable spacearoundoperators
            switch self {
            case .A       : return "A"
            case .A_sharp : return respellSharpAsFlat ? "B\(flat)" : "A\(sharp)"
            case .B       : return "B"
            case .C       : return "C"
            case .C_sharp : return respellSharpAsFlat ? "D\(flat)" : "C\(sharp)"
            case .D       : return "D"
            case .D_sharp : return respellSharpAsFlat ? "E\(flat)" : "D\(sharp)"
            case .E       : return "E"
            case .F       : return "F"
            case .F_sharp : return respellSharpAsFlat ? "G\(flat)" : "F\(sharp)"
            case .G       : return "G"
            case .G_sharp : return respellSharpAsFlat ? "A\(flat)" : "G\(sharp)"
            }
        }
        
        /// Semitone offset originating from note C, ascending.
        public var scaleOffset: Int {
            // swiftformat:disable spacearoundoperators
            switch self {
            case .A       : return 9
            case .A_sharp : return 10
            case .B       : return 11
            case .C       : return 0
            case .C_sharp : return 1
            case .D       : return 2
            case .D_sharp : return 3
            case .E       : return 4
            case .F       : return 5
            case .F_sharp : return 6
            case .G       : return 7
            case .G_sharp : return 8
            }
            // swiftformat:enable spacearoundoperators
        }
        
        /// Returns `true` if note is sharp (has a ♯ accidental). On a piano keyboard, this would be a black key.
        public var isSharp: Bool {
            switch self {
            case .A,
                 .B,
                 .C,
                 .D,
                 .E,
                 .F,
                 .G:
                return false
                
            case .A_sharp,
                 .C_sharp,
                 .D_sharp,
                 .F_sharp,
                 .G_sharp:
                return true
            }
        }
        
        /// Returns note name and octave for the MIDI note number.
        /// Returns `nil` if MIDI note number is invalid.
        internal static func convert(
            noteNumber: UInt7,
            style: Style = .yamaha
        ) -> (name: Self, octave: Int) {
            // UInt7 is guaranteed to be a valid MIDI note number
            
            let octave = (noteNumber.intValue / 12) + style.firstOctaveOffset
            
            // swiftformat:disable spacearoundoperators
            switch noteNumber.intValue % 12 {
            case 9:  return (name: .A, octave: octave)
            case 10: return (name: .A_sharp, octave: octave)
            case 11: return (name: .B, octave: octave)
            case 0:  return (name: .C, octave: octave)
            case 1:  return (name: .C_sharp, octave: octave)
            case 2:  return (name: .D, octave: octave)
            case 3:  return (name: .D_sharp, octave: octave)
            case 4:  return (name: .E, octave: octave)
            case 5:  return (name: .F, octave: octave)
            case 6:  return (name: .F_sharp, octave: octave)
            case 7:  return (name: .G, octave: octave)
            case 8:  return (name: .G_sharp, octave: octave)
            default:
                // should never happen
                assertionFailure("Modulus is broken.")
                return (name: .C, octave: style.firstOctaveOffset)
            }
            // swiftformat:enable spacearoundoperators
        }
    }
}
