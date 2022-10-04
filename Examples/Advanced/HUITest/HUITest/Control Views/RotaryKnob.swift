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
    
    init(
        label: String,
        size: CGFloat,
        vPot: HUIVPot
    ) {
        self.label = label
        self.size = size
        self.vPot = vPot
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if vPot.hasDisplay {
                ZStack {
                    KnobShape(size: size * 0.5)
                
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
            
                Circle()
                    .fill(display.lowerLED ? .red : .black)
                    .frame(width: size / 10, height: size / 10)
            } else {
                KnobShape(size: size)
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

struct KnobShape: View {
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray)
                .frame(width: size, height: size)
            Circle()
                .stroke(
                    Color(white: 0.3),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [3])
                )
                .frame(width: size * 0.8, height: size * 0.8)
        }
    }
}

struct JogWheel: View {
    @EnvironmentObject var huiSurface: HUISurface
    
    var size: CGFloat
    
    @State private var lastDragLocation: CGPoint?
    
    var body: some View {
        PlaceholderKnob(name: "Jog Wheel", size: size)
            .highPriorityGesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { v in
                        let getLastDragLocation = lastDragLocation ?? v.location
                        let isPositive = v.location.x > getLastDragLocation.x
                        let delta: Int7 = isPositive ? 1 : -1
                        huiSurface.transmitJogWheel(delta: delta)
                        lastDragLocation = v.location
                    }
            )
    }
}
