//
//  Property.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct Property: Hashable {
    let key: String
    let value: String
    let isError: Bool
}

extension Property: Identifiable {
    var id: String { key }
}
