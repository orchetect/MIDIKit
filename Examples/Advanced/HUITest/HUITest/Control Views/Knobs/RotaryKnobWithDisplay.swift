//
//  RotaryKnobWithDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

extension RotaryKnob {
    struct RotaryKnobWithDisplay: View {
        var label: String
        var size: CGFloat
        
        @Binding var leftBound: Float
        @Binding var rightBound: Float
        @Binding var display: HUIVPotDisplay
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(.black)
                    .frame(width: size, height: size)
                
                KnobShape(size: size * 0.6)
                
                Group {
                    // display knob only, non-interactive
                    if leftBound == -1,
                       rightBound == -1
                    {
                        ArcKnob(
                            label,
                            value: .constant(1.0),
                            range: 0.0 ... 1.0,
                            origin: 0.0
                        )
                        .foregroundColor(.clear)
                        .backgroundColor(.black)
                    } else {
                        ArcKnob(
                            label,
                            value: $rightBound,
                            range: 0.0 ... 1.0,
                            origin: leftBound
                        )
                        .foregroundColor(.red)
                        .backgroundColor(.black)
                    }
                }
                .disabled(true)
                
                VStack {
                    Spacer()
                    Circle()
                        .fill(display.lowerLED ? .red : .black)
                        .frame(width: size / 10, height: size / 10)
                    Spacer().frame(height: size / 15)
                }
            }
            .frame(width: size, height: size)
        }
    }
}
