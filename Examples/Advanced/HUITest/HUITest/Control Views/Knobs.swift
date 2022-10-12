//
//  Knobs.swift
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
    
    @State private var hover: Bool = false
    
    var body: some View {
        let interiorLineWidth = min(5, size / 10)
        let interiorDash: [CGFloat] = [size / 10]
        let interiorOffset = max(size - 15, size * 0.7)
        let darkGray = Color(white: 0.4)
        
        ZStack {
            Circle()
                .fill(darkGray)
                .frame(width: size, height: size)
            Circle()
                .fill(.radialGradient(
                    colors: [Color(white: 0.5), Color(white: 0.7)],
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: size
                ))
                .frame(width: interiorOffset, height: interiorOffset)
                .shadow(color: .black, radius: size / 20, x: size / 30, y: size / 30)
            Circle()
                .stroke(
                    .gray,
                    style: StrokeStyle(
                        lineWidth: interiorLineWidth,
                        lineCap: .round,
                        lineJoin: .round,
                        dash: interiorDash
                    )
                )
                .frame(width: interiorOffset, height: interiorOffset)
            
            if size > 100 {
                VStack {
                    HStack { // ◀︎ ▶︎ ← →
                        //Text("◀︎")
                        //Text("▶︎")
                        Text("←").rotationEffect(.degrees(360 - 15))
                        Text("→").rotationEffect(.degrees(15))
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.black.opacity(0.7))
                    .scaleEffect(CGSize.init(width: size/140, height: size/140))
                    Spacer()
                }
                .padding(size / 5)
            } else {
                Image(
                    systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill"
                )
                .resizable()
                .foregroundColor(.black)
                .frame(width: size / 2, height: size / 2)
                .opacity(hover ? 1.0 : 0.0)
            }
        }
        .onHover { state in
            withAnimation(.linear(duration: 0.1)) {
                hover = state
            }
        }
    }
}

struct JogWheel: View {
    @EnvironmentObject var huiSurface: HUISurface
    
    var size: CGFloat
    
    @State private var lastDragLocation: CGPoint?
    
    var body: some View {
        ZStack {
            KnobShape(size: size)
            Text("Jog Wheel")
                .foregroundColor(.black)
        }
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
