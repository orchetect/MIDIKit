//
//  HUISectionLabel.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct HUISectionLabel: View {
    var label: LocalizedStringKey
    
    init(_ label: LocalizedStringKey) {
        self.label = label
    }
    
    var body: some View {
        Text(label)
            .font(.system(size: 10))
    }
}
