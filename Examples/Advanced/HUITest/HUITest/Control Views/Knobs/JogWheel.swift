//
//  JogWheel.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

struct JogWheel: View {
    @Environment(HUISurface.self) var huiSurface
    
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
