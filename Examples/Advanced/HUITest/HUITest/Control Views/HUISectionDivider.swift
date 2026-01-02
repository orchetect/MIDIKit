//
//  HUISectionDivider.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct HUISectionDivider: View {
    var orientation: Orientation
    
    init(_ orientation: Orientation) {
        self.orientation = orientation
    }
    
    var body: some View {
        switch orientation {
        case .vertical:
            Color.primary.frame(width: 1)
            
        case .horizontal:
            Color.primary.frame(height: 1)
        }
    }
}

extension HUISectionDivider {
    enum Orientation {
        case vertical
        case horizontal
    }
}
