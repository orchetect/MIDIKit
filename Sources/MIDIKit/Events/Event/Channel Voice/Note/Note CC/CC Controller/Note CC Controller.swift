//
//  Note CC Controller.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note.CC {
    /// Per-Note Controller
    /// (MIDI 2.0)
    public enum Controller: Equatable, Hashable {
        /// Registered Per-Note Controller
        case registered(Registered)
        
        /// Assignable Per-Note Controller (Non-Registered)
        case assignable(Assignable)
    }
}

extension MIDI.Event.Note.CC.Controller: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .registered(cc):
            return "registered(\(cc.number))"
            
        case let .assignable(cc):
            return "assignable(\(cc))"
        }
    }
}

extension MIDI.Event.Note.CC.Controller {
    /// Returns the controller number.
    @inline(__always)
    public var number: UInt8 {
        switch self {
        case let .registered(cc):
            return cc.number
            
        case let .assignable(cc):
            return cc
        }
    }
}
