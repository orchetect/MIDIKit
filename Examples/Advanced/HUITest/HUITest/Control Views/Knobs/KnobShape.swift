//
//  KnobShape.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

struct KnobShape: View {
    var size: CGFloat
    
    @State private var isHovering: Bool = false
    
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
                        // Text("◀︎")
                        // Text("▶︎")
                        Text("←").rotationEffect(.degrees(360 - 15))
                        Text("→").rotationEffect(.degrees(15))
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.black.opacity(0.7))
                    .scaleEffect(CGSize(width: size / 140, height: size / 140))
                    Spacer()
                }
                .padding(size / 5)
            } else {
                Image(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(width: size / 2, height: size / 2)
                    .contentShape(Rectangle()) // improves hit-testing for mouse hovering
                    .opacity(isHovering ? 1.0 : 0.0)
            }
        }
        .onHover { state in
            withAnimation(.linear(duration: 0.1)) {
                isHovering = state
            }
        }
    }
}
