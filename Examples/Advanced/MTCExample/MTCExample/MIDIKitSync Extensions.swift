//
//  MIDIKitSync Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitSync

extension MTCEncoder.FullFrameBehavior {
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
