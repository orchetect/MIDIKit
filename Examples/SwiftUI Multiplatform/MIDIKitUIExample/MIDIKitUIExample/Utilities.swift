//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Allow use with `@AppStorage` by conforming to a supported `RawRepresentable` type.
extension MIDIIdentifier: @retroactive RawRepresentable {
    public typealias RawValue = Int
    
    public init?(rawValue: RawValue) {
        self = Self(rawValue)
    }
    
    public var rawValue: RawValue {
        Int(self)
    }
}
