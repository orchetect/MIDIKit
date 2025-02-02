//
//  LargeTextDisplayView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView {
    struct LargeTextDisplayView: View {
        @Environment(HUISurface.self) var huiSurface
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(huiSurface.model.largeDisplay.top.stringValue)
                Text(huiSurface.model.largeDisplay.bottom.stringValue)
            }
            .font(.system(size: 14, weight: .regular, design: .monospaced))
            .foregroundColor(.white)
            .frame(width: 360, height: 42)
            .background(.black)
            .cornerRadius(3.0, antialiased: true)
        }
    }
}
