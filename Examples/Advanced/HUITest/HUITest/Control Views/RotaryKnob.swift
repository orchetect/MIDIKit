//
//  RotaryKnob.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces
import Controls

struct RotaryKnob: View {
    @EnvironmentObject var huiSurface: HUISurface
    
    var label: String
    var size: CGFloat
    var vPot: HUIVPot
    
    @State private var leftBound: Float = -1
    @State private var rightBound: Float = -1
    @State var display: HUIVPotDisplay = .allOff
    
    @State private var lastDragLocation: CGPoint?
    
    init(label: String,
         size: CGFloat,
         vPot: HUIVPot) {
        self.label = label
        self.size = size
        self.vPot = vPot
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
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
            }
            .frame(width: size, height: size)
            
            if vPot.hasDisplay {
                Circle()
                    .fill(display.lowerLED ? .red : .gray)
                    .frame(width: size / 10, height: size / 10)
            }
        }
        .onChange(of: huiSurface.model.state(of: vPot)) { newValue in
            updateDisplay(newValue)
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 2)
                .onChanged { v in
                    let getLastDragLocation = lastDragLocation ?? v.location
                    let isPositive = v.location.x > getLastDragLocation.x
                    let delta: Int7 = isPositive ? 1 : -1
                    huiSurface.transmitVPot(delta: delta, for: vPot)
                    lastDragLocation = v.location
                }
        )
    }
    
    func updateDisplay(_ newDisplay: HUIVPotDisplay) {
        display = newDisplay
        if let bounds = newDisplay.leds.unitIntervalBounds {
            leftBound = Float(bounds.lowerBound)
            rightBound = Float(bounds.upperBound)
        } else {
            leftBound = -1
            rightBound = -1
        }
    }
}

struct PlaceholderKnob: View {
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
