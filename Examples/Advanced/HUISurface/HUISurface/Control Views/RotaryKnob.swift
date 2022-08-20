//
//  RotaryKnob.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct RotaryKnob: View {
    var size: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .fill(Color(white: 0.1))
                    .frame(height: size / 2)
            )
    }
}
