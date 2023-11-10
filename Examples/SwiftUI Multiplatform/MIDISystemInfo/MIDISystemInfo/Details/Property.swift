//
//  Property.swift
//  MIDISystemInfo
//
//  Created by Steffan Andrews on 2023-11-10.
//

import MIDIKitIO
import SwiftUI

struct Property: Identifiable, Hashable {
    let key: String
    let value: String
    
    var id: String { key }
}
