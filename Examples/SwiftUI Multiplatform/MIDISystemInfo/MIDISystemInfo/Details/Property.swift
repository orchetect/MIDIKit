//
//  Property.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct Property: Hashable {
    let key: String
    let value: String
}

extension Property: Identifiable {
    var id: String { key }
}
