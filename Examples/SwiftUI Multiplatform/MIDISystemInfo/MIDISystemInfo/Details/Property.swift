//
//  Property.swift
//  MIDISystemInfo
//
//  Created by Steffan Andrews on 2023-11-10.
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
