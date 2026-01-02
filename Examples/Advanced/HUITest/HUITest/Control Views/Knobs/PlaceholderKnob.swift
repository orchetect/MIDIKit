//
//  PlaceholderKnob.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

struct PlaceholderKnob: View {
    var name: String = ""
    var size: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color(white: 0.2))
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .fill(Color.gray)
                    .frame(height: size * 0.9)
            )
            .overlay {
                Text(name)
                    .foregroundColor(.black)
            }
    }
}
