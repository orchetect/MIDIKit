//
//  MIDIKitSync Extensions.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitSync

extension MIDI.MTC.Encoder.FullFrameBehavior {
    public var nameForUI: String {
        switch self {
        case .always:
            return "Always"
        case .ifDifferent:
            return "If Different"
        case .never:
            return "Never"
        }
    }
}
