//
//  RotaryKnob.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

struct RotaryKnob: View {
    @Environment(HUISurface.self) var huiSurface
    
    var label: String
    var size: CGFloat
    var vPot: HUIVPot
    
    @State private var leftBound: Float = -1
    @State private var rightBound: Float = -1
    @State private var display: HUIVPotDisplay = .allOff
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
                RotaryKnobWithDisplay(label: label, size: size, leftBound: $leftBound, rightBound: $rightBound, display: $display)
            } else {
                KnobShape(size: size)
            }
        }
        .onChange(of: huiSurface.model.state(of: vPot)) { oldValue, newValue in
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
}

// MARK: - ViewModel

extension RotaryKnob {
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
